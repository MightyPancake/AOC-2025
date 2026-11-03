// Advent of Code 2025, day 4: https://adventofcode.com/2025/day/4
//
// Reads the puzzle input on stdin and prints the answer to part 1, then the
// answer to part 2, one per line. `just run 4` checks them against out/.

import std;
import os;

fn map_at(lines: const u8[:][:], x: i64, y: i64) -> bool {
    if x < 0 || y < 0 || y >= lines.len || x >= lines[y].len {
        return false;
    }
    lines[y][x] != '.'
}

fn buf_at(buf: u8[:], x: i64, y: i64, w: i64, h: i64) -> bool {
    if x < 0 || y < 0 || y >= h || x >= w {
        return false;
    }
    buf[y * w + x] != '.'
}

fn count_neighbors(lines: const u8[:][:], x: i64, y: i64) -> i64 {
    var count: i64 = 0;
    for dy in [-1,0,1] {
        for dx in [-1,0,1] {
            if dx == 0 && dy == 0 {continue;}
            if map_at(lines, x + dx, y + dy) {
                count++;
            }
        }
    }
    count
}

fn count_neighbors(buf: const u8[:], x: i64, y: i64, w: i64, h: i64) -> i64 {
    var count: i64 = 0;
    for dy in [-1,0,1] {
        for dx in [-1,0,1] {
            if dx == 0 && dy == 0 {continue;}
            if buf_at(buf, x + dx, y + dy, w, h) {
                count++;
            }
        }
    }
    count
}

fn part1(lines) -> i64 {
    var result = 0;
    for y in 0..lines.len {
        for x in 0..lines[y].len {
            guard map_at(lines,x,y);
            let neighbour_count = count_neighbors(lines, x, y);
            //print("At (", x, ",", y, ") = ", [lines[y][x]], " has ", neighbour_count, " neighbors");
            guard neighbour_count <  4 else { continue; }
            result++;
        }
    }
    result
}

fn part2(orig_lines) -> i64 {
    let w = orig_lines[0].len;
    let h = orig_lines.len;
    let buf: u8[>..] = [];
    for line in orig_lines {
        buf.append(line);
    }

    var result = 0;
    var rolls_taken = 1;
    while (rolls_taken > 0){
        rolls_taken = 0;
        for y in 0..h {
            for x in 0..w {
                guard buf_at(buf, x, y, w, h);
                let neighbour_count = count_neighbors(buf, x, y, w, h);
                guard neighbour_count <  4 else { continue; }
                result++;
                rolls_taken++;
                buf[y * w + x] = '%';
            }
        }
        //buf.map(){ if it == '%' {'%'} else {it} };
        for i in 0..buf.len {
            if buf[i] == '%' {
                buf[i] = '.';
            }
        }
    }
    result
}

fn main() {
    var input: u8[>..] = [];
    read_stdin(input);
    let lines = split(trim_end(input), '\n');
    print(part1(lines));
    print(part2(lines));
}
