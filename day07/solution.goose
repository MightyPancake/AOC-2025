// Advent of Code 2025, day 7: https://adventofcode.com/2025/day/7
//
// Reads the puzzle input on stdin and prints the answer to part 1, then the
// answer to part 2, one per line. `just run 7` checks them against out/.

import std;
import os;

fn part1(lines) -> i64 {
    var beams = lines[0].map(){it == 'S'};
    var splits = 0;
    //print("beams: ", beams);
    for line in lines[1..] {
        //print("beam count: ", beams.count(){it});
        // Get splitters
        let splitters = line.map(){it == '^'};
        //print("beams and splitters:\n", beams, "\n", splitters);
        for v, i in beams {
            let s = splitters[i];
            if !v {continue;} //no beam; do nothing
            beams[i] = !s; //Beam continues only if there is no splitter
            // If there is a splitter; create 2 new beams (if not out of bounds)
            if s {
                splits++;
                if i > 0 {beams[i-1] = true;}
                if i < beams.len-1 {beams[i+1] = true;}
            }
        }
    }
    //beams.count(){it}
    splits
}

fn part2(lines) -> i64 {
    0
}

fn main() {
    var input: u8[>..] = [];
    read_stdin(input);
    let lines = split(trim_end(input), '\n');
    //print("lines: ", lines);
    print(part1(lines));
    print(part2(lines));
}
