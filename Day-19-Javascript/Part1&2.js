// Run with:
// docker run --rm -i -v "$(pwd)":/aoc -w /aoc node node 'Part1&2.js'

// Good resources:
// - Mozilla reference: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference

const fs = require('fs')

function Point(x, y, z) {
    this.x = x
    this.y = y
    this.z = z
    this.sub = (other) => new Point(this.x - other.x, this.y - other.y, this.z - other.z)
    this.add = (other) => new Point(this.x + other.x, this.y + other.y, this.z + other.z)
    this.equals = (other) => this.x === other.x && this.y === other.y && this.z === other.z
    this.magnitude = () => Math.abs(this.x) + Math.abs(this.y) + Math.abs(this.z)
}

function rotateAround(scanner, axis, degrees) {
    const radians = Math.PI * degrees/180
    
    const [r00, r01, r10, r11] = [ Math.cos(radians), -Math.sin(radians), Math.sin(radians), Math.cos(radians) ].map(v => Math.round(v))
    
    let rotated = []
    for (const p of scanner) {
        let np = new Point(p.x, p.y, p.z)
        if (axis === 'x') {
            np.z = r00 * p.z + r01 * p.y
            np.y = r10 * p.z + r11 * p.y
        }
        if (axis === 'y') {
            np.x = r00 * p.x + r01 * p.z
            np.z = r10 * p.x + r11 * p.z
        }
        if (axis === 'z') {
            np.x = r00 * p.x + r01 * p.y
            np.y = r10 * p.x + r11 * p.y
        }
        rotated.push(np)
    }
    return rotated
}

function transformScanner(scanner) {
    const candidates = [
        rotateAround(scanner, 'z', 0),   // Facing X+
        rotateAround(scanner, 'z', 180), // Facing X-
        rotateAround(scanner, 'z', 90),  // Facing Y+
        rotateAround(scanner, 'z', 270), // Facing Y-
        rotateAround(scanner, 'y', 90),   // Facing Z+
        rotateAround(scanner, 'y', 270) // Facing Z-
    ]
    
    let transforms = []
    for (const candidate of candidates) {
        for (let d = 0; d < 360; d += 90) {
            transforms.push(rotateAround(candidate, 'x', d))
        }
    }
    
    return transforms
}

function contains(list, value) {
    for (const p of list) {
        if (p.equals(value)) {
            return true
        }
    }
    return false
}

function isMatch(s1, s2, offset) {
    let matches = 0
    for (const p2 of s2) {
        const t = p2.add(offset)
        if (contains(s1, t)) {
            matches += 1
        }
    }
    return matches >= 12
}

function findMatchOffset(s1, s2) {
    if (s1 === s2) {
        return undefined
    }
    for (const start of s1) {
        for (const other of s2) {
            const offset = start.sub(other)
            
            if (isMatch(s1, s2, offset)) {
                return offset
            }
        }
    }
    
    return undefined
}

function mergeInto(target, other, offset) {
    for (const p of other) {
        const t = p.add(offset)
        if (!contains(target, t)) {
            target.push(t)
        }
    }
}

// This only works for console input, not files! Also only reads the
// first line if you paste multiple at the same time...
// async function readConsoleInput() {
//     const rl = require('readline/promises').createInterface({
//         input: process.stdin,
//         output: process.stdout,
//     });
//     
//     let data = ''
//     while (true) {
//         let line = await rl.question('')
//         data += line + '\n'
//     }
//     
//     rl.close()
//     
//     return data
// }

async function main() {
    // const data = await readConsoleInput()
    // const data = fs.readFileSync('example.in').toString()
    const data = fs.readFileSync('full.in').toString()

    scannerIdx = -1
    scanners = new Map()
    for (line of data.split('\n')) {
        if (line.length == 0) {
            continue
        }
        
        if (line.startsWith('---')) {
            scannerIdx += 1
            scanners.set(scannerIdx, [])
        } else {
            const [x, y, z] = line.split(',').map(v => parseInt(v))
            scanners.get(scannerIdx).push(new Point(x, y, z))
        }
    }

    target = scanners.get(0)
    scanners.delete(0)

    scannersTransformed = new Map()
    for (const [id, sc] of scanners) {
        scannersTransformed.set(id, transformScanner(sc))
    }

    scannerPositions = [new Point(0, 0, 0)]
    while (scannersTransformed.size > 0) {
        for (const [i, transforms] of scannersTransformed) {
            for (const scanner of transforms) {
                const offset = findMatchOffset(target, scanner)
                if (offset !== undefined) {
                    console.log(`Match offset found for scanner ${i}!`)
                    mergeInto(target, scanner, offset)
                    scannersTransformed.delete(i)
                    scannerPositions.push(offset)
                    break
                }
            }
        }
    }

    console.log(`Total amount of sensors: ${target.length}`)

    let longestDistance = 0
    for (const p1 of scannerPositions) {
        for (const p2 of scannerPositions) {
            if (p1 != p2) {
                longestDistance = Math.max(longestDistance, p1.sub(p2).magnitude())
            }
        }
    }

    console.log(`Longet distance: ${longestDistance}`)
}

main()
