// Run with:
// docker run --rm -i -v "$(pwd)":/aoc -w /aoc rust bash -c "rustc 'Part1.rs' && ./Part1"

// Good resources:
// - Rust book: https://doc.rust-lang.org/book/
// - API docs of STD: https://doc.rust-lang.org/stable/std/index.html
// - User packages: https://crates.io

use std::io;

fn parse_range(range: &str) -> (i32, i32) {
    let mut tokens = range[2..].split("..");
    (
        tokens.next().unwrap().parse().unwrap(),
        tokens.next().unwrap().parse().unwrap(),
    )
}

fn main() -> Result<(), std::io::Error> {
    const SIZE: usize = 101;
    let mut cubes = [[[false; SIZE]; SIZE]; SIZE];

    loop {
        let mut input = String::new();
        io::stdin().read_line(&mut input)?;
        if input == "" {
            break;
        }

        let mut tokens = input.trim().split_whitespace();
        let state = tokens.next().unwrap() == "on";

        let mut tokens = tokens.next().unwrap().split(',');
        let (x_min, x_max) = parse_range(tokens.next().unwrap());
        let (y_min, y_max) = parse_range(tokens.next().unwrap());
        let (z_min, z_max) = parse_range(tokens.next().unwrap());

        if x_min.abs() > 50
            || x_max.abs() > 50
            || y_min.abs() > 50
            || y_max.abs() > 50
            || z_min.abs() > 50
            || z_max.abs() > 50
        {
            continue;
        }

        for x in x_min..=x_max {
            for y in y_min..=y_max {
                for z in z_min..=z_max {
                    cubes[(x + 50) as usize][(y + 50) as usize][(z + 50) as usize] = state;
                }
            }
        }
    }

    let mut set = 0;
    for x in 0..SIZE {
        for y in 0..SIZE {
            for z in 0..SIZE {
                if cubes[x][y][z] {
                    set += 1;
                }
            }
        }
    }

    println!("Cubes set {set}");

    Ok(())
}
