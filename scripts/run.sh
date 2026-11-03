#!/usr/bin/env bash
# Build a day's solution and run it on its inputs, checking against out/.
#
#   run.sh DAY [INSTANCE...]   INSTANCE is a file name in DAY/in without .txt;
#                              none means every in/*.txt
#   run.sh --save DAY INST...  also write what it prints to out/INST.txt
#   run.sh --save-parts=N ...  the same, keeping only the first N lines (parts)
#   run.sh --jit DAY ...       use `goose run` instead of an optimized build
#   run.sh --ref DAY ...       run solutions/dayNN.goose instead of yours
#
# Each line of out/INST.txt is the expected answer of one part, in order.
# Lines the solution prints beyond those are shown but not checked, so an
# out file with only the part 1 answer works while part 2 is in progress.
# Exit status: 0 all checked parts pass, 1 a mismatch or crash, 2 a usage
# or compile error.
set -uo pipefail
source "$(dirname "$0")/lib.sh"

save=0 save_parts=0 jit=0 ref=0
while [[ $# -gt 0 && "$1" == --* ]]; do
    case "$1" in
        --save) save=1 ;;
        --save-parts=*) save=1 save_parts="${1#*=}"
            [[ "$save_parts" =~ ^[0-9]+$ ]] || die "--save-parts takes a number" ;;
        --jit) jit=1 ;;
        --ref) ref=1 ;;
        *) die "unknown option $1" ;;
    esac
    shift
done
[[ $# -ge 1 ]] || die "usage: run.sh [--save] [--jit] [--ref] DAY [INSTANCE...]"

dir="$(day_dir "$1")"; shift
name="$(basename "$dir")"
if ((ref)); then
    src="$ROOT/solutions/$name.goose"
    [[ -f "$src" ]] || die "no reference solution at ${src#$ROOT/}"
else
    src="$dir/solution.goose"
    [[ -f "$src" ]] || die "$src does not exist (just scaffold)"
fi

instances=("$@")
if [[ ${#instances[@]} -eq 0 ]]; then
    for f in "$dir"/in/*.txt; do
        [[ -e "$f" ]] && instances+=("$(basename "$f" .txt)")
    done
fi
[[ ${#instances[@]} -gt 0 ]] || die "$name/in has no inputs (just fetch ${name#day})"

# Compile once, then run every instance with the same executable.
if ((jit)); then
    runner=(goose run "$src" --)
else
    exe="$ROOT/.build/$name"
    ((ref)) && exe+="-ref"
    mkdir -p "$ROOT/.build"
    goose build "$src" -o "$exe" >/dev/null || exit 2
    runner=("$exe")
fi

status=0
for inst in "${instances[@]}"; do
    in="$dir/in/$inst.txt"
    out="$dir/out/$inst.txt"
    [[ -f "$in" ]] || { echo "${C_RED}✗ $name/$inst${C_RESET}: no $in"; status=1; continue; }
    if [[ ! -s "$in" ]]; then
        echo "${C_DIM}$name/$inst: in/$inst.txt is empty, skipped${C_RESET}"
        continue
    fi

    start=$(date +%s%N)
    actual="$("${runner[@]}" < "$in")"
    code=$?
    ms=$(( ($(date +%s%N) - start) / 1000000 ))

    echo "${C_BOLD}$name/$inst${C_RESET} ${C_DIM}(${ms} ms)${C_RESET}"
    if ((code != 0)); then
        echo "  ${C_RED}✗ exited with $code${C_RESET}"
        status=1
    fi

    mapfile -t got <<< "$actual"
    [[ -z "$actual" ]] && got=()
    expected=()
    [[ -f "$out" ]] && mapfile -t expected < "$out"

    n=$(( ${#got[@]} > ${#expected[@]} ? ${#got[@]} : ${#expected[@]} ))
    for ((i = 0; i < n; i++)); do
        g="${got[i]-}" e="${expected[i]-}"
        label="part $((i + 1))"
        if ((i >= ${#expected[@]})); then
            echo "  ${C_YELLOW}?${C_RESET} $label: $g ${C_DIM}(not checked)${C_RESET}"
        elif ((i >= ${#got[@]})); then
            echo "  ${C_RED}✗${C_RESET} $label: printed nothing, expected $e"
            status=1
        elif [[ "$g" == "$e" ]]; then
            echo "  ${C_GREEN}✓${C_RESET} $label: $g"
        else
            echo "  ${C_RED}✗${C_RESET} $label: $g, expected $e"
            status=1
        fi
    done
    ((n == 0)) && echo "  ${C_YELLOW}?${C_RESET} printed nothing"

    if ((save)); then
        keep=${#got[@]}
        ((save_parts > 0 && save_parts < keep)) && keep=$save_parts
        mkdir -p "$dir/out"
        if ((keep > 0)); then printf '%s\n' "${got[@]:0:keep}" > "$out"; else : > "$out"; fi
        echo "  ${C_DIM}saved $keep part(s) to ${out#$ROOT/}${C_RESET}"
    fi
done
exit $status
