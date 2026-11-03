# Advent of Code 2025 in Goose. DAY is a number: 1, 01 or day01 all work.

set shell := ["bash", "-uc"]

# List the recipes
default:
    @just --list --unsorted

# Build DAY and check it on its inputs (all of in/, or the INSTANCES named)
run day *instances:
    @scripts/run.sh {{day}} {{instances}}

# Same as run, through `goose run` (in-process JIT, no C compiler needed)
jit day *instances:
    @scripts/run.sh --jit {{day}} {{instances}}

# Run the reference solution in solutions/ on DAY's inputs (answers only, no code shown)
ref day *instances:
    @scripts/run.sh --ref {{day}} {{instances}}

# Record what DAY prints on INSTANCE as its expected output (PARTS=1: only part 1's line)
accept day instance parts="0":
    @scripts/run.sh --save-parts={{parts}} {{day}} {{instance}}

# Rerun DAY whenever a file in its directory changes
watch day *instances:
    watchexec --clear --restart --watch day$(printf '%02d' $((10#{{day}}))) -- scripts/run.sh {{day}} {{instances}}

# Run every day that has an input, and summarize
all:
    #!/usr/bin/env bash
    fails=() ran=0
    for d in day*/; do
        d="${d%/}"
        [[ -n "$(find "$d/in" -name '*.txt' -size +0 2>/dev/null)" ]] || continue
        ran=$((ran + 1))
        scripts/run.sh "$d" || fails+=("$d")
        echo
    done
    if ((ran == 0)); then echo "no day has an input yet"
    elif [[ ${#fails[@]} -eq 0 ]]; then echo "$ran day(s), all passing"
    else echo "failing: ${fails[*]}"; exit 1; fi

# Download DAY's input and example (needs AOC_SESSION or .session)
fetch day:
    @scripts/fetch.sh {{day}}

# Create anything missing from the day directories (never overwrites)
scaffold *days:
    @scripts/scaffold.sh {{days}}

# Typecheck DAY without running it
check day:
    goose check day$(printf '%02d' $((10#{{day}})))/solution.goose

# Time DAY's optimized build on one instance
bench day instance="input":
    #!/usr/bin/env bash
    set -e
    d=day$(printf '%02d' $((10#{{day}})))
    mkdir -p .build && goose build $d/solution.goose -o .build/$d >/dev/null
    hyperfine --warmup 3 --input $d/in/{{instance}}.txt --output null .build/$d

# Print DAY's puzzle text, fetched from adventofcode.com (part 2 needs .session)
problem day:
    @scripts/problem.sh {{day}}

# Format every Goose file
fmt:
    goose format .

# Remove build outputs
clean:
    rm -rf .build
