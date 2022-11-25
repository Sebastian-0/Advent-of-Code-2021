// Run with:
// docker build -t kotlin .
// docker run --rm -i -v "$(pwd)":/aoc -w /aoc kotlin bash -c "kotlinc 'Part12.kt' && java Part12Kt.class"

// https://adventofcode.com/2021/day/23#part2
//
// https://kotlinlang.org/docs/control-flow.html#when-expression
// https://kotlinlang.org/docs/arrays.html
// https://kotlinlang.org/api/latest/jvm/stdlib/kotlin.collections/
//

import kotlin.math.min

const val DEPTH = 2

class State {
    val s = Array(4) { IntArray(DEPTH) }
    
    val hall = IntArray(11)
    
    fun copy(): State {
        val copy = State()
        s[0].copyInto(copy.s[0]);
        s[1].copyInto(copy.s[1]);
        s[2].copyInto(copy.s[2]);
        s[3].copyInto(copy.s[3]);
        hall.copyInto(copy.hall);
        return copy
    }
    
    fun isSolved(): Boolean {
        return s[0].all { v -> v == 1 } &&
            s[1].all { v -> v == 2 } &&
            s[2].all { v -> v == 3 } &&
            s[3].all { v -> v == 4 }
    }
}

fun costFor(type: Int, steps: Int): Int {
    return when (type) {
        1 -> 1
        2 -> 10
        3 -> 100
        4 -> 1000
        else -> 0
    } * steps
}

val BLOCKED = setOf(2, 4, 6, 8)
fun tryMoveOut2(state: State, sIdx: Int, idx: Int, start: Int): Int {
    var cost = Int.MAX_VALUE
    // Go left
    for (i in start-1 downTo 0) {
        if (i in BLOCKED) {
            continue
        }
        
        if (state.hall[i] != 0) {
            break
        }
        
        var clone = state.copy()
        clone.hall[i] = clone.s[sIdx][idx]
        clone.s[sIdx][idx] = 0
        val subCost = solve(clone)
        if (subCost != Int.MAX_VALUE) {
            cost = min(cost, subCost + costFor(sIdx, idx + start - i + 1))
        }
    }
    
    // Go right
    for (i in start+1..state.hall.lastIndex) {
        if (i in BLOCKED) {
            continue
        }
        
        if (state.hall[i] != 0) {
            break
        }
        
        var clone = state.copy()
        clone.hall[i] = clone.s[sIdx][idx]
        clone.s[sIdx][idx] = 0
        val subCost = solve(clone)
        if (subCost != Int.MAX_VALUE) {
            cost = min(cost, subCost + costFor(sIdx, idx + i - start + 1))
        }
    }
    return cost
}

fun tryMoveOut(state: State, sIdx: Int, start: Int): Int {
    val array = state.s[sIdx]
    val validToMove = array.any { v -> v != sIdx+1 && v != 0 }
    if (validToMove) {
        for (i in array.indices.reversed()) {
            if (array[i] != 0) {
                return tryMoveOut2(state, sIdx, i, start)
            }
        }
    }
    return Int.MAX_VALUE
}

fun tryMoveIn(state: State, sIdx: Int, target: Int): Int {
    if (state.s[sIdx][0] != 0) {
        return Int.MAX_VALUE // Target is already full!
    }
    
    var cost = Int.MAX_VALUE
    for (i in target-1 downTo 0) {
        // Return items to side room, fail if type is incorrect!
    }
//     // Go left
//     for (i in start-1 downTo 0) {
//         if (i in BLOCKED) {
//             continue
//         }
//         
//         if (state.hall[i] != 0) {
//             break
//         }
//         
//         var clone = state.copy()
//         clone.hall[i] = clone.s[sIdx][idx]
//         clone.s[sIdx][idx] = 0
//         val subCost = solve(clone)
//         if (subCost != Int.MAX_VALUE) {
//             cost = min(cost, subCost + costFor(sIdx, idx + start - i + 1))
//         }
//     }
//     
//     // Go right
//     for (i in start+1..state.hall.lastIndex) {
//         if (i in BLOCKED) {
//             continue
//         }
//         
//         if (state.hall[i] != 0) {
//             break
//         }
//         
//         var clone = state.copy()
//         clone.hall[i] = clone.s[sIdx][idx]
//         clone.s[sIdx][idx] = 0
//         val subCost = solve(clone)
//         if (subCost != Int.MAX_VALUE) {
//             cost = min(cost, subCost + costFor(sIdx, idx + i - start + 1))
//         }
//     }
    return cost
}

fun solve(state: State): Int {
    if (state.isSolved()) {
        return 0
    }
    
    var cost = Int.MAX_VALUE
    
    // Try moving to hallway
    cost = min(cost, tryMoveOut(state, 0, 2))
    cost = min(cost, tryMoveOut(state, 1, 4))
    cost = min(cost, tryMoveOut(state, 2, 6))
    cost = min(cost, tryMoveOut(state, 3, 8))
    
    // Try moving to side rooms
    cost = min(cost, tryMoveIn(state, 0, 2))
    cost = min(cost, tryMoveIn(state, 1, 4))
    cost = min(cost, tryMoveIn(state, 2, 6))
    cost = min(cost, tryMoveIn(state, 3, 8))
    
    return cost
}

fun main() {
    // 0 = empty, 1 = A, 2 = B, 3 = C, 4 = D
    val initial = State()
    
    initial.s[0][0] = 2
    initial.s[0][1] = 4
    
    initial.s[1][0] = 2
    initial.s[1][1] = 3
    
    initial.s[2][0] = 3
    initial.s[2][1] = 1
    
    initial.s[3][0] = 4
    initial.s[3][1] = 1
    
//     initial.s1[0] = 2
//     initial.s1[1] = 4
//     
//     initial.s2[0] = 2
//     initial.s2[1] = 3
//     
//     initial.s3[0] = 3
//     initial.s3[1] = 1
//     
//     initial.s4[0] = 4
//     initial.s4[1] = 1
    
//     initial.s1[0] = 1
//     initial.s1[1] = 1
//     
//     initial.s2[0] = 2
//     initial.s2[1] = 2
//     
//     initial.s3[0] = 3
//     initial.s3[1] = 3
//     
//     initial.s4[0] = 4
//     initial.s4[1] = 4
    
    println("Solved? ${initial.isSolved()}")
    
    val cost = solve(initial.copy())
    
    println("Cost: $cost")
}
