# Advent of Code 2025 in Goose

Solutions to [Advent of Code 2025](https://adventofcode.com/2025) in
[Goose](https://github.com/aardappel/goose).

```bash
nix develop          # or `direnv allow`; builds Goose from source the first time
just problem 1       # read the puzzle in the terminal
just fetch 1         # input + example (needs .session, see below)
$EDITOR day01/solution.goose
just run 1           # build, run on every in/*.txt, check against out/
```

## Layout

```
dayNN/
  solution.goose     reads input on stdin, prints part 1 then part 2
  in/NAME.txt        one input per instance: example.txt, input.txt, ...
  out/NAME.txt       expected output: line 1 = part 1, line 2 = part 2
```

Add more instances by dropping another `in/foo.txt` (and `out/foo.txt`) in.
An out file with only part 1's answer checks only part 1, and anything not
in an out file is printed as "not checked". Empty inputs are skipped.

## Reference solutions

`solutions/dayNN.goose` holds a working solution for each day, out of sight
and git-ignored, for when you are really stuck. `just ref DAY` runs one on
your inputs without showing the code.

## Recipes

| | |
|---|---|
| `just run DAY [INST...]` | optimized build, run, check (exit 1 on a mismatch) |
| `just jit DAY [INST...]` | the same through `goose run` |
| `just watch DAY` | rerun on every save |
| `just ref DAY [INST...]` | run the reference solution from `solutions/` instead (answers only) |
| `just accept DAY INST` | record the current output as `out/INST.txt` |
| `just all` | every day that has input, with a summary |
| `just problem DAY` | print the puzzle text, fetched live (part 2 once solved, when logged in) |
| `just fetch DAY` | get `in/input.txt` once, and the first code block → `in/example.txt` |
| `just check DAY` / `just bench DAY` / `just fmt` / `just clean` | |

## Session cookie

`just fetch` needs your adventofcode.com `session` cookie, from the browser's
dev tools, in `.session` or `$AOC_SESSION`. Both are git-ignored.
`in/input*.txt` is git-ignored too, because AoC asks that
inputs not be republished.
