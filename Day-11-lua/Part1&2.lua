
-- Run with:
-- docker build -t lua .
-- docker run --rm -i -v "$(pwd)":/aoc -w /aoc lua lua 'Part1&2.lua'

-- Good resources:
-- - https://moys.gov.iq/upload/common/Programming_in_Lua,_4th_ed._(2017)_.pdf
-- - If above is no longer available go for the free 1st ed. 
-- - Reference: https://www.lua.org/manual/5.4/

total_flashes = 0

function read_matrix()
    matrix = {}
    while true do
        line = io.read()
        if not line then
            break;
        end

        row = {}
        for i = 1, #line do
            row[i] = tonumber(line:sub(i, i))
        end
        matrix[#matrix + 1] = row
    end
    
    return matrix
end

function print_matrix(m)
    for r = 1, #m do
        line = ''
        for c = 1, #m[r] do
            line = line .. m[r][c]
        end
        print(line)
    end
end

function flash_octopus(m, r, c)
    if c < 1 or c > #m[1] or r < 1 or r > #m then
        return
    end
    
    
    if m[r][c] ~= 0 then
        m[r][c] = m[r][c] + 1
        if m[r][c] > 9 then
            m[r][c] = 0
            flash(m, r, c)
        end
    end
end

function flash(m, r, c)
    total_flashes = total_flashes + 1
    flash_octopus(m, r  , c+1)
    flash_octopus(m, r+1, c+1)
    flash_octopus(m, r+1, c)
    flash_octopus(m, r+1, c-1)
    flash_octopus(m, r  , c-1, r)
    flash_octopus(m, r-1, c-1)
    flash_octopus(m, r-1, c)
    flash_octopus(m, r-1, c+1)
end

function simulate_step(m)
    -- Increase all by one
    for r = 1, #m do
        for c = 1, #m[r] do
            m[r][c] = m[r][c] + 1
        end
    end
    
    -- Flash if necessary
    for r = 1, #m do
        for c = 1, #m[r] do
            if m[r][c] > 9 then
                m[r][c] = 0
                flash(m, r, c)
            end
        end
    end
end

function is_synchronized(m)
    for r = 1, #m do
        for c = 1, #m[r] do
            if m[r][c] ~= 0 then
                return false
            end
        end
    end
    return true
end

matrix = read_matrix()

s = 1
while true do
    simulate_step(matrix)
    if s == 100 then
        print('Total flashes after 100 steps: ' .. total_flashes)
    end
    if is_synchronized(matrix) then
        print('Synchronized after ' .. s .. ' steps')
        break
    end
    s = s + 1
end