#!/usr/bin/env bash
# Download a day's input into in/input.txt, and its example into in/example.txt.
#
#   fetch.sh DAY
#
# Needs your adventofcode.com session cookie, in $AOC_SESSION or the file
# .session at the repo root (both git-ignored). Find it in the browser's dev
# tools: the `session` cookie on adventofcode.com.
#
# The input never changes, so it is fetched only once. The first code block
# of the puzzle goes to in/example.txt if that is empty; it is usually the
# example, but check it.
set -euo pipefail
source "$(dirname "$0")/lib.sh"

[[ $# -eq 1 ]] || die "usage: fetch.sh DAY"
dir="$(day_dir "$1")"
url="$(day_url "$1")"
[[ -n "$(aoc_session)" ]] || die "set AOC_SESSION or put your session cookie in .session"

mkdir -p "$dir/in" "$dir/out"

if [[ ! -s "$dir/in/example.txt" ]]; then
    articles="$(aoc_get "$url" | aoc_articles)" || die "could not fetch $url (unlocked yet? cookie still valid?)"
    example="$(awk '/<pre><code>/{on=1} on{print} /<\/code><\/pre>/{if(on)exit}' <<< "$articles" \
        | sed -e 's#.*<pre><code>##' -e 's#</code></pre>.*##' -e 's/<[^>]*>//g' \
              -e 's/&lt;/</g' -e 's/&gt;/>/g' -e 's/&quot;/"/g' -e 's/&amp;/\&/g')"
    if [[ -n "$example" ]]; then
        printf '%s\n' "$example" > "$dir/in/example.txt"
        echo "wrote ${dir#$ROOT/}/in/example.txt (first code block; check it)"
    fi
fi

if [[ -s "$dir/in/input.txt" ]]; then
    echo "${dir#$ROOT/}/in/input.txt already there"
else
    aoc_get "$url/input" > "$dir/in/input.txt.tmp" || { rm -f "$dir/in/input.txt.tmp"; die "could not fetch $url/input"; }
    mv "$dir/in/input.txt.tmp" "$dir/in/input.txt"
    echo "wrote ${dir#$ROOT/}/in/input.txt ($(wc -l < "$dir/in/input.txt") lines)"
fi
