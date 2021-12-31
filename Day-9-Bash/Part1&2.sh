#!/bin/bash

# Run with:
# './Part1&2.sh'

# Good resources:
# - My own bash reference
# - Google!

set -euo pipefail

declare -A input

# Read input
row=0
while true; do
    set +e
    read line
    set -e
    if [ -z "$line" ]; then
        break
    fi
    
    col=0
    while read -n1 char; do
        input[$row,$col]=$char
        ((col += 1))
    done < <(echo -n "$line")
    
    ((row += 1))
done

width=$col
height=$row

# Part 1
retval=

is_low_point() {
    local x="$1"
    local y="$2"
    local v="${input[$y,$x]}"
    if ((v < ${input[$((y+1)),$x]-9999} &&
         v < ${input[$((y-1)),$x]-9999} &&
         v < ${input[$y,$((x+1))]-9999} &&
         v < ${input[$y,$((x-1))]-9999})); then
        retval=true
    else
        retval=false
    fi
}

risk_level_sum=0
for ((r = 0; r < height; r++)); do
    for ((c = 0; c < width; c++)); do
        is_low_point $c $r
        if [ "$retval" = true ]; then
            ((risk_level_sum += ${input[$r,$c]} + 1))
        fi
    done
done

echo "Risk level sum: $risk_level_sum"

# Part 2
flood() {
    local x="$1"
    local y="$2"
    local v="${input[$y,$x]-9}"
    
    local size=0
    if [ "$v" != "9" ]; then
        input[$y,$x]=9
        size=1
        flood $((x + 1)) $y; ((size += retval))
        flood $((x - 1)) $y; ((size += retval))
        flood $x $((y + 1)); ((size += retval))
        flood $x $((y - 1)); ((size += retval))
    fi
    retval=$size
}

basins=()
for ((r = 0; r < height; r++)); do
    for ((c = 0; c < width; c++)); do
        flood $c $r
        if [ "$retval" -ne 0 ]; then
            basins+=($retval)
        fi
    done
done

IFS=$'\n' sorted=($(printf '%s\n' "${basins[@]}" | sort -nr)); unset IFS
echo "Basin size multiplication: $((sorted[0] * sorted[1] * sorted[2]))"
