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

fn merge_ranges(ranges: Range[:]) -> Range[>..] {
    ranges.sort() { a, b => a.start < b.start };
    var n = 0;
    for r, i in ranges {
        if n > 0 && r.start <= ranges[n - 1].end + 1 {
            ranges[n - 1].end = max(ranges[n - 1].end, r.end);
        } else {
            ranges[n] = r;
            n++;
        }
    }
    return ranges[0..n];
}

fn print_ranges(ranges: Range[:]) {
    for r in ranges {
        print(r);
    }
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

fn part2(ranges, ids) -> i64 {
    ranges.fold(0){
        acc, r => acc + (r.end - r.start + 1)
    }
}

fn main() {
    var input: u8[>..] = [];
    read_stdin(input);
    let lines = split(trim_end(input), '\n');
    let ranges, ids = parse_input(lines);
    let merged_ranges = merge_ranges(ranges);
    //print_ranges(merged_ranges);
    print(part1(merged_ranges, ids));
    print(part2(merged_ranges, ids));
}
