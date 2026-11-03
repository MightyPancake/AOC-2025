// Advent of Code 2025, day 3: https://adventofcode.com/2025/day/3
//
// Reads the puzzle input on stdin and prints the answer to part 1, then the
// answer to part 2, one per line. `just run 3` checks them against out/.

import std;
import os;
import math;



fn joltage(bank: u8[:], digit_count: u8) -> i64 {
    //Assume the result is always a 2 digit number
    var first_digit = 0;
    let digits: u8[>..] = [];
    for i in 0..digit_count {
        var max_i = first_digit;
        var max: u8 = 0;
        for j in first_digit..bank.len - (digit_count - i-1) {
            if bank[j] > max {
                max = bank[j];
                max_i = j;
            }
        }
        //print("Max digit: ", [max], " at index: ", max_i);
        first_digit = max_i+1;
        digits.push(max);
    }
    let result, ok = parse_int(digits);
    assert(ok);
    result
}

fn part1(lines) -> i64 {
    var result: i64 = 0;
    for bank in lines {
        //let bank, ok1 = parse_int(line);
        //assert(ok1);
        let joltage = joltage(bank, 2);
        result += joltage;
        //print("Bank: ", bank, " Joltage: ", joltage);
    }
    result
}

fn part2(lines) -> i64 {
        var result: i64 = 0;
    for bank in lines {
        //let bank, ok1 = parse_int(line);
        //assert(ok1);
        let joltage = joltage(bank, 12);
        result += joltage;
        //print("Bank: ", bank, " Joltage: ", joltage);
    }
    result
}

fn main() {
    var input: u8[>..] = [];
    read_stdin(input);
    let lines = split(trim_end(input), '\n');
    print(part1(lines));
    print(part2(lines));
    // print(if 3121910778619 == 3121910778619 {"yes"} else {"no"});
}
