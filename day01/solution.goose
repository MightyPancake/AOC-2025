// Advent of Code 2025, day 1: https://adventofcode.com/2025/day/1
//
// Reads the puzzle input on stdin and prints the answer to part 1, then the
// answer to part 2, one per line. `just run 1` checks them against out/.
import math;
import std;
import os;

fn part1(lines) -> i64 {
    var state: i64 = 50;
    var code = 0;
    for line in lines {
        let dir = if line[0] == 'R' { 1 } else { -1 };
        let n, ok1 = parse_int(line[1..]);
        assert(ok1);
        state = (state + dir * n) % 100;
        code += if state == 0 { 1 } else { 0 };
        //print(line, " dir: ", dir, ", n: ", n, " ok1: ", ok1, " state: ", state, " code: ", code);
    }
    code
}

fn part2(lines) -> i64 {
    var state: i64 = 50;
    var code = 0;
    for line in lines {
        let dir = if line[0] == 'R' { 1 } else { -1 };
        let n, ok1 = parse_int(line[1..]);
        assert(ok1);
        let diff = dir * n;

        if (diff == 0) { continue; }
        let old_state = state;
        state = (state + diff);
        var incr = 0;
        if (state <= 0 && old_state > 0) { incr++; }
        incr += abs(state) / 100;
        //print("old_state: ", old_state, ", diff: ", diff, ", state: ", state, ", incr: ", incr);
        state %= 100;
        code += incr;
        //print(line, " dir: ", dir, ", n: ", n, " ok1: ", ok1, " state: ", state, " code: ", code);
    }
    code
}

fn main() {
    var input: u8[>..] = [];
    read_stdin(input);
    let lines = split(trim_end(input), '\n');
    print(part1(lines));
    print(part2(lines));
}
