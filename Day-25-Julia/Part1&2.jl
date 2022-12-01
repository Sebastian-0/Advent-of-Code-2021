# Run with:
# docker run --rm -i -v "$(pwd)":/aoc -w /aoc julia julia 'Part1&2.jl'

# Good resources:
# - Language manual: https://docs.julialang.org/en/v1/

function print_m(matrix)
    for row ∈ eachrow(matrix)
        println(join(row, ""))
    end
end

function move(matrix_ref, dr, dc, target)
    matrix = matrix_ref[]
    new_matrix = copy(matrix)
    rows = size(matrix, 1)
    cols = size(matrix, 2)
    
    changed = false
    for r ∈ 1:rows
        for c ∈ 1:cols
            if matrix[r, c] == target
                nc = (c-1+dc) % cols + 1
                nr = (r-1+dr) % rows + 1
                if matrix[nr, nc] == '.'
                    new_matrix[nr, nc] = target
                    new_matrix[r, c] = '.'
                    changed = true
                end
            end
        end
    end
    matrix_ref[] = new_matrix
    changed
end

function simulate(matrix, verbose=false)
    if verbose
        print_m(matrix)
    end
    
    # Keep the matrix as a reference to avoid having two return values from the move() function
    matrix_ref = Ref(matrix)
    step = 0
    changed = true
    while changed
        changed = false
        
        # Move all to the east
        changed |= move(matrix_ref, 0, 1, '>')
        changed |= move(matrix_ref, 1, 0, 'v')
        
        if verbose
            println()
            print_m(matrix_ref[])
        end
        step += 1
    end
    
    step
end

# Read the map into a 2D array of chars
matrix = map(line -> permutedims(map(only, split(line, ""))), readlines())
matrix = vcat(matrix...)

final_step = simulate(matrix)

println("Movement stopped after $final_step steps")


