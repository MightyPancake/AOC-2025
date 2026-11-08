// Advent of Code 2025, day 6: https://adventofcode.com/2025/day/6
//
// Reads the puzzle input on stdin and prints the answer to part 1, then the
// answer to part 2, one per line. `just run 6` checks them against out/.

import std;
import os;

fn part1(lines) -> i64 {
    var results: i64[>..] = [];
    let ops = lines[lines.len-1].split(' ').map(){
        if it.len > 0 {it[0] } else { ' ' }
    }.filter()
    {
        it != ' '
    };
    //print(ops);
    for op in ops {
        results.push(
            match op{
                '*' => 1,
                _ => 0
            }
        );
    }
    for i in 0..lines.len-1 {
        let line = lines[i];
        let parts = line.split(' ');
        //print(parts);
        var col = 0;
        for part, j in parts {
            if part.len == 0 { continue; }
            let num, ok = parse_int(part);
            assert(ok);
            match ops[col] {
                '*' => {
                    results[col] *= num;
                },
                '+' => {
                    results[col] += num;
                },
                _ => {}
            }
            col++;
        }
    }
    results.fold(0) { acc, result => acc + result }
}

fn part2(lines) -> u64 {
    var results: i64[>..] = [];
    var lengths: i64[>..] = [];
    let ops = lines[lines.len-1].split(' ').map(){
        if it.len > 0 {it[0] } else { ' ' }
    }.filter()
    {
        it != ' '
    };
        for op in ops {
        results.push(
            match op{
                '*' => 1,
                _ => 0
            }
        );
    }
    for _ in ops {
        lengths.push(0);
    }
    for i in 0..lines.len-1 {
        let line = lines[i];
        let parts = line.split(' ');
        //print(parts);
        var col = 0;
        for part, j in parts {
            if part.len == 0 { continue; }
            lengths[col] = max(lengths[col], part.len);
            col++;
        }
    }
    //Now we have max length of each column!
    let max_len = lengths.fold(0) { acc, len => max(acc, len) };
    for i in max_len..0 {
        for i in 0..lines.len-1 {
        let line = lines[i];
        let parts = line.split(' ');
        for part, j in parts {
            if part.len == 0 { continue; }
            //TODO!
        }
    }
    }
    print(lengths);
    0
}

fn main() {
    var input: u8[>..] = [];
    read_stdin(input);
    let lines = split(trim_end(input), '\n');
    //print("Input \n", input);
    print(part1(lines));
    print(part2(lines));
}
