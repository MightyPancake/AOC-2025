#!/usr/bin/env bash
# Create whatever is missing of dayNN/{solution.goose,in/,out/}.
# Never overwrites anything.
#
#   scaffold.sh          every day
#   scaffold.sh DAY...   just these
set -euo pipefail
source "$(dirname "$0")/lib.sh"

days=("$@")
[[ ${#days[@]} -gt 0 ]] || days=($(seq 1 "$DAYS"))

for d in "${days[@]}"; do
    dir="$(day_dir "$d")"
    n=$((10#$(norm_day "$d")))
    mkdir -p "$dir/in" "$dir/out"
    [[ -e "$dir/in/example.txt" ]] || : > "$dir/in/example.txt"
    [[ -e "$dir/out/example.txt" ]] || : > "$dir/out/example.txt"
    if [[ ! -e "$dir/solution.goose" ]]; then
        sed "s/{{DAY}}/$n/g" "$ROOT/template.goose" > "$dir/solution.goose"
        echo "created ${dir#$ROOT/}"
    fi
done
