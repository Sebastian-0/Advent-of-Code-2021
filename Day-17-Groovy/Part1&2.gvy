// Run with:
// docker run --rm -i -v "$(pwd)":/aoc -w /aoc groovy groovy 'Part1&2.gvy'

// Good resources:
// - Documentation: https://groovy-lang.org/documentation.html


// Use withReader to get automatic resource management
def line = ''
System.in.withReader(reader -> {
    line = reader.readLine()
})

def matches = line =~ /.*x=(-?\d+)..(-?\d+), y=(-?\d+)..(-?\d+)/

// Not using def here makes the variables "global" and thus accessible in the helper function below.
// Note that a class will be created for the file and all code outside any function will be collected
// in an anonymous main function.
(xMin, xMax, yMin, yMax) = matches[0][1..-1].collect(t -> t.toInteger())

// -1 here since an initial speed upwards of X will result on a move X+1 downwards from the starting position
def vy = -yMin - 1
def topY = vy * (1 + vy) / 2

println("Highest y pos: $topY for initial speed $vy")

def simulate(int vx, int vy) {
    def x = 0
    def y = 0
    while (x <= xMax && y >= yMin ) {
        x += vx
        y += vy
        vx = Math.max(0, vx - 1)
        vy -= 1
        
        if (x >= xMin && x <= xMax && y >= yMin && y <= yMax ) {
            return true
        }
    } 
    return false
}

def valid = 0
for (vx = 0; vx <= xMax; vx++) {
    for (vy = yMin; vy <= -yMin; vy++) {
        if (simulate(vx, vy)) {
            valid += 1
        }
    }
}

println("Valid initial velocities: $valid")