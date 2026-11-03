// Advent of Code 2025, day 2: https://adventofcode.com/2025/day/2
//
// Reads the puzzle input on stdin and prints the answer to part 1, then the
// answer to part 2, one per line. `just run 2` checks them against out/.

import std;
import os;
import math;

struct ID_Range {
    start: i64,
    end: i64,
}

// Input is said to be a single line
fn parse_input(input:u8[:]) -> ID_Range[>..] {
    var ranges: ID_Range[>..] = [];
    let range_strings = split(trim_end(input), ',');
    for range_str in range_strings {
        //print("Parsing range: ", range_str);
        let parts = split(range_str, '-');
        let start, ok1 = parse_int(parts[0]);
        let end, ok2 = parse_int(parts[1]);
        //print("Parsed range: ", start, " to ", end);
        assert(ok1 && ok2);
        ranges.push(ID_Range { start, end });
    }
    ranges
}

fn pow(base: i64, exp: i64) -> i64 {
    var result: i64 = 1;
    for _ in 0..exp {
        result *= base;
    }
    result
}

fn invalid_id(id:i64) -> bool {
    var num: i64 = id;
    var digits: i64 = 1;
    while (num >= 10) {
        num /= 10;
        digits++;
    }
    // If the number of digits is odd, it cannot be an invalid ID
    if digits % 2 != 0 {
        return false;
    }
    let half_base = pow(10, digits/2);
    let half1 = id / half_base;
    let half2 = id % half_base;
    //print("Checking id: ", id, " with ", digits, " digits. half1: ", half1, " half2: ", half2);
    half1 == half2
}

fn part1(ranges:ID_Range[:]) -> i64 {
    var result: i64 = 0;
    for range in ranges {
        for id in range.start..range.end+1 {
            if invalid_id(id) {
                //print("Invalid ID: ", id);
                result += id;
            }
        }
    }
    result
}

fn part2(ranges:ID_Range[:]) -> i64 {
    0
}

fn main() {
    var input: u8[>..] = [];
    read_stdin(input);
    let ranges = parse_input(input);
    print(part1(ranges));
    print(part2(ranges));
}
