// Run with:
// docker run --rm -i -v "$(pwd)":/aoc -w /aoc rust bash -c "rustc 'Part2.rs' && ./Part2"

// Good resources:
// - Rust book: https://doc.rust-lang.org/book/
// - API docs of STD: https://doc.rust-lang.org/stable/std/index.html
// - User packages: https://crates.io

use std::io;

struct Cube {
    x1: i32,
    y1: i32,
    z1: i32,
    x2: i32,
    y2: i32,
    z2: i32,
}

impl Cube {
    fn new(x1: i32, y1: i32, z1: i32, x2: i32, y2: i32, z2: i32) -> Self {
        Self {
            x1,
            y1,
            z1,
            x2,
            y2,
            z2,
        }
    }

    fn intersection(&self, other: &Cube) -> Option<Cube> {
        fn overlap(a1: i32, a2: i32, b1: i32, b2: i32) -> Option<(i32, i32)> {
            if a2 < b1 || a1 > b2 {
                None
            } else {
                Some((a1.max(b1), a2.min(b2)))
            }
        }

        let o_x = overlap(self.x1, self.x2, other.x1, other.x2);
        let o_y = overlap(self.y1, self.y2, other.y1, other.y2);
        let o_z = overlap(self.z1, self.z2, other.z1, other.z2);

        match (o_x, o_y, o_z) {
            (Some((x1, x2)), Some((y1, y2)), Some((z1, z2))) => {
                Some(Cube::new(x1, y1, z1, x2, y2, z2))
            }
            _ => None,
        }
    }

    fn pixels(&self) -> usize {
        (self.x2 - self.x1 + 1) as usize
            * (self.y2 - self.y1 + 1) as usize
            * (self.z2 - self.z1 + 1) as usize
    }
}

fn parse_range(range: &str) -> (i32, i32) {
    let mut tokens = range[2..].split("..");
    let v1 = tokens.next().unwrap().parse().unwrap();
    let v2 = tokens.next().unwrap().parse().unwrap();
    if v1 < v2 {
        (v1, v2)
    } else {
        (v2, v1)
    }
}

fn parse_cube(x_range: &str, y_range: &str, z_range: &str) -> Cube {
    let (x_min, x_max) = parse_range(x_range);
    let (y_min, y_max) = parse_range(y_range);
    let (z_min, z_max) = parse_range(z_range);
    Cube::new(x_min, y_min, z_min, x_max, y_max, z_max)
}

fn main() -> Result<(), std::io::Error> {
    let mut positive = Vec::<Cube>::new();
    let mut negative = Vec::<Cube>::new();

    loop {
        let mut input = String::new();
        io::stdin().read_line(&mut input)?;
        if input == "" {
            break;
        }

        let mut tokens = input.trim().split_whitespace();
        let is_on = tokens.next().unwrap() == "on";

        let mut tokens = tokens.next().unwrap().split(',');
        let new_cube = parse_cube(
            tokens.next().unwrap(),
            tokens.next().unwrap(),
            tokens.next().unwrap(),
        );

        let mut new_neg = vec![];
        let mut new_pos = vec![];

        // If new cube is 'off' we must deduct from all existing (positive) ones
        // If new cube is 'on' we must also deduct the overlap, otherwise adding two
        // identical cubes would count towards 'on' twice!
        for old_cube in positive.iter() {
            if let Some(intersection) = old_cube.intersection(&new_cube) {
                new_neg.push(intersection);
            }
        }
        // If new cube is 'off' we must deduct from all existing (negative) ones,
        // otherwise adding two identical cubes would count towards 'off' twice!
        // If new cube is 'on' we must also deduct to negate any 'off' cubes that have
        // turned off part of the region we now turn on!
        for old_cube in negative.iter() {
            if let Some(intersection) = old_cube.intersection(&new_cube) {
                new_pos.push(intersection);
            }
        }

        // Finally, for an 'on' cube we must add the new region
        if is_on {
            positive.push(new_cube);
        }

        negative.append(&mut new_neg);
        positive.append(&mut new_pos);
    }

    let mut set = 0;
    for cube in positive {
        set += cube.pixels();
    }
    for cube in negative {
        set -= cube.pixels();
    }

    println!("Cubes set: {set}");

    Ok(())
}
