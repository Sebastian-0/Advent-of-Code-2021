
# Run with:
# docker run --rm -i -v "$(pwd)":/aoc -w /aoc ruby ruby 'Part1&2.rb'

# Good resources:
# - Tutorials: https://www.tutorialspoint.com/ruby/index.htm
# - API docs: https://apidock.com/ruby/

class Entry
    attr_accessor :x
    attr_accessor :y
    attr_accessor :cost
    attr_accessor :parent
    
    def initialize(x, y, cost, parent)
        @x = x
        @y = y
        @cost = cost
        @parent = parent
    end
end

# Adds (x,  y) to list to be considered if it's within the bounds of the board and if not already visited.
# If we have seen the position before we must check to see if we now have a cheaper path.
def add_if_valid(matrix, taken, x, y, parent, entries)
    if x < 0 or x >= matrix[0].length() or y < 0 or y >= matrix.length()
        return
    end
    
    cost = parent.cost + matrix[y][x]
    if taken[y][x]
        if taken[y][x].cost > cost
            taken[y][x].parent = parent
            taken[y][x].cost = cost
        end
    else
        taken[y][x] = Entry.new(x, y, cost, parent)
        entries << taken[y][x]
    end
end

# Compute the cheapest path from (0, 0) -> (width-1, height-1)
def cheapest_path(matrix)
    taken = Array.new(matrix.length()) { Array.new(matrix[0].length(), nil) }
    taken[0][0] = Entry.new(0, 0, 0, nil)

    entries = []
    entries << taken[0][0]

    while !entries.empty? do
        entry = entries.shift
        if entry.x == matrix[0].length() - 1 and entry.y == matrix.length() - 1
            return entry.cost
        end
        
        add_if_valid(matrix, taken, entry.x - 1, entry.y, entry, entries)
        add_if_valid(matrix, taken, entry.x + 1, entry.y, entry, entries)
        add_if_valid(matrix, taken, entry.x, entry.y - 1, entry, entries)
        add_if_valid(matrix, taken, entry.x, entry.y + 1, entry, entries)
        
        # This is way slower than using the appropriate data structure! There is no
        # TreeSet/PriorityQueue in the standard library, and the third party variants
        # do not support updates!
        entries.sort_by! &-> (e) { e.cost }
    end
end

text = $stdin.read
lines = text.split "\n"

matrix = lines.map(&-> (l) {l.split("").map(&:to_i)})

print "Small matrix: Cheapest path: #{cheapest_path(matrix)}\n"

# Create the 5 times bigger matrix for part 2
big_matrix = Array.new(matrix.length() * 5) { Array.new(matrix[0].length() * 5, 0) }
for y in 0..big_matrix.length() - 1
    for x in 0..big_matrix[0].length() - 1
        offset = y / matrix.length() + x / matrix[0].length()
        big_matrix[y][x] = (matrix[y % matrix.length()][x % matrix[0].length()] + offset - 1) % 9 + 1
    end
end

print "Big matrix: Cheapest path: #{cheapest_path(big_matrix)}\n"
