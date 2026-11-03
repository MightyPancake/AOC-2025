# Shared helpers, sourced by the other scripts.

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
YEAR=2025
DAYS=12 # AoC 2025 has 12 puzzles

if [[ -t 1 && -z "${NO_COLOR:-}" ]]; then
    C_RED=$'\e[31m' C_GREEN=$'\e[32m' C_YELLOW=$'\e[33m' C_DIM=$'\e[2m' C_BOLD=$'\e[1m' C_RESET=$'\e[0m'
else
    C_RED='' C_GREEN='' C_YELLOW='' C_DIM='' C_BOLD='' C_RESET=''
fi

die() { echo "${C_RED}error:${C_RESET} $*" >&2; exit 2; }

# "3", "03" or "day03" -> "03"
norm_day() {
    local d="${1#day}"
    [[ "$d" =~ ^[0-9]+$ ]] || die "not a day: $1"
    d=$((10#$d))
    ((d >= 1 && d <= DAYS)) || die "day must be 1..$DAYS, got $1"
    printf '%02d' "$d"
}

day_dir() { echo "$ROOT/day$(norm_day "$1")"; }

day_url() { echo "https://adventofcode.com/$YEAR/day/$((10#$(norm_day "$1")))"; }

# The adventofcode.com session cookie, from $AOC_SESSION or .session; empty if neither.
aoc_session() {
    if [[ -n "${AOC_SESSION:-}" ]]; then echo "$AOC_SESSION"
    elif [[ -f "$ROOT/.session" ]]; then tr -d '[:space:]' < "$ROOT/.session"
    fi
}

# GET a URL from adventofcode.com, logged in when there is a session.
aoc_get() {
    local session; session="$(aoc_session)"
    # The User-Agent identifies the tool, as the AoC maintainer asks of automated tools.
    local args=(-fsS -A "github.com/MightyPancake/AOC-2025 (curl)")
    [[ -n "$session" ]] && args+=(--cookie "session=$session")
    curl "${args[@]}" "$1"
}

# The <article> elements of a puzzle page: part 1, and part 2 once unlocked.
aoc_articles() { sed -n '/<article/,/<\/article>/p'; }
