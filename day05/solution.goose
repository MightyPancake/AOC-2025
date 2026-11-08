// Advent of Code 2025, day 5: https://adventofcode.com/2025/day/5
//
// Reads the puzzle input on stdin and prints the answer to part 1, then the
// answer to part 2, one per line. `just run 5` checks them against out/.

import std;
import os;

struct Range {
    start: i64,
    end: i64
}

fn valid_id(ranges: Range[:], id: i64) -> i64 {
    for range in ranges {
        if id >= range.start && id <= range.end {
            return 1;
        }
    }
    return 0;
}

fn parse_input(lines) -> Range[>..], i64[>..] {
    var ranges: Range[>..] = [];
    var ids: i64[>..] = [];
    var parsing_ranges: bool = true;
    for line in lines {
        if line.len == 0 { parsing_ranges = false; continue;}
        if parsing_ranges {
            // Parse ranges
            let parts = split(line, '-');
            guard parts.len == 2;
            let start, ok1 = parse_int(parts[0]);
            let end, ok2 = parse_int(parts[1]);
            assert(ok1 && ok2);
            ranges.push(Range { start, end });
        } else {
            // Parse IDs
            let id, ok = parse_int(line);
            assert(ok);
            ids.push(id);
        }
    }
    // print("Ranges: ", ranges);
    // print("IDs: ", ids);
    return ranges, ids;
}

fn part1(ranges, ids) -> i64 {
    let result = ids.fold(0){
        acc, x => acc + valid_id(ranges, x)
    };
    result

}

fn part2(lines) -> i64 {
    0
}

fn main() {
    var input: u8[>..] = [];
    read_stdin(input);
    let lines = split(trim_end(input), '\n');
    let ranges, ids = parse_input(lines);
    print(part1(ranges, ids));
    print(part2(lines));
}
