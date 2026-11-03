#!/usr/bin/env bash
# Print a day's puzzle text in the terminal, fetched from adventofcode.com.
#
#   problem.sh DAY
#
# Part 2 shows up once part 1 is solved, and only when logged in: put your
# session cookie in .session or $AOC_SESSION. Without one, only part 1 shows.
set -euo pipefail
source "$(dirname "$0")/lib.sh"

[[ $# -eq 1 ]] || die "usage: problem.sh DAY"
url="$(day_url "$1")"
html="$(aoc_get "$url")" || die "could not fetch $url (unlocked yet?)"
articles="$(aoc_articles <<< "$html")"
[[ -n "$articles" ]] || die "no puzzle text on $url"

cols=$(( $(tput cols 2>/dev/null || echo 80) < 100 ? $(tput cols 2>/dev/null || echo 80) : 100 ))
text="$(pandoc -f html -t plain --wrap=auto --columns="$cols" <<< "$articles")"
[[ -z "$(aoc_session)" ]] && text+=$'\n\n'"(not logged in: part 2 is hidden; see .session in the README)"

if [[ -t 1 ]]; then less -FRX <<< "$text"; else printf '%s\n' "$text"; fi
