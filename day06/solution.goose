// Advent of Code 2025, day 6: https://adventofcode.com/2025/day/6
//
// Reads the puzzle input on stdin and prints the answer to part 1, then the
// answer to part 2, one per line. `just run 6` checks them against out/.

import std;
import os;

fn get_ops(lines) -> u8[>..] {
    let line = lines[lines.len-1];
    let ops = line.split(' ').map() {
        if it.len > 0 {it[0] } else { ' ' }
    }.filter() {
        it != ' '
    };
    ops
}

fn get_init_nums(ops) -> i64[>..] {
    var results: i64[>..] = [];
    for op in ops {
        match op {
            '*' => results.push(1),
            _ => results.push(0)
        }
    }
    results
}

fn part1(lines) -> i64 {
    let ops = get_ops(lines);
    var results: i64[>..] = get_init_nums(ops);
    //print(ops);
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
                _ => {assert(false);}
            }
            col++;
        }
    }
    results.fold(0) { acc, result => acc + result }
}

fn pow(base: i64, exp: i64) -> i64 {
    if exp == 0 { return 1; }
    var result = base;
    for _ in 1..exp {
        result *= base;
    }
    result
}

fn part2(lines) -> i64 {
    let ops = get_ops(lines);
    var results: i64[>..] = get_init_nums(ops);
    var cur_result = 0;
    let width = lines[0].len;
    for i in 0..width {
        var exp = 0;
        var all_space = true;
        var num = 0;
        for k in 0..lines.len-1 {
            let j = lines.len-2-k;
            let ch = lines[j][i];
            if ch == ' ' {continue;}
            all_space = false;
            assert(ch >= '0' && ch <= '9');
            let digit = (ch - '0') as i64;
            num = num + digit * pow(10, exp);
            exp++;
        }
        if !all_space {
            //print("num: ", num, " cur_result: ", cur_result);
            match ops[cur_result] {
                '*' => {
                    results[cur_result] *= num;
                },
                '+' => {
                    results[cur_result] += num;
                },
                _ => {assert(false);}
            }
        }else{
            cur_result++;
        }
    }
    results.fold(0) { acc, result => acc + result }
}

fn main() {
    var input: u8[>..] = [];
    read_stdin(input);
    let lines = split(trim_end(input), '\n');
    //print("Input \n", input);
    print(part1(lines));
    print(part2(lines));
}
