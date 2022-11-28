// Run with:
// docker build -t kotlin .
// docker run --rm -i -v "$(pwd)":/aoc -w /aoc kotlin bash -c "kotlinc -include-runtime -d out.jar 'Part12.kt' && java -jar out.jar"

// https://adventofcode.com/2021/day/23#part2
//
// https://kotlinlang.org/docs/control-flow.html#when-expression
// https://kotlinlang.org/docs/arrays.html
// https://kotlinlang.org/api/latest/jvm/stdlib/kotlin.collections/

import kotlin.math.min

// const val DEPTH = 2

class State(depth: Int) {
    val s = Array(4) { IntArray(depth) }

    val hall = IntArray(11)

    fun copy(): State {
        val copy = State(s[0].size)
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
    
    fun key(): String {
        return "${hall.joinToString(",")}|${s[0].joinToString(",")}|${s[1].joinToString(",")}|${s[2].joinToString(",")}|${s[3].joinToString(",")}"
    }
}

fun costFor(type: Int, steps: Int): Int {
    return when (type) {
        1 -> 1
        2 -> 10
        3 -> 100
        4 -> 1000
        else -> {
            throw java.lang.RuntimeException("FAILED")
        }
    } * steps
}

val BLOCKED = setOf(2, 4, 6, 8)
fun tryMoveOut2(state: State, sIdx: Int, idx: Int, start: Int): Pair<Int, MutableList<Pair<State, Int>>> {
    var cost = Int.MAX_VALUE
    var bestStates = mutableListOf<Pair<State, Int>>()
    var bestMoveCost = 0
    // Go left
    for (i in start-1 downTo 0) {
        if (i in BLOCKED) {
            continue
        }

        if (state.hall[i] != 0) {
            break
        }

        val clone = state.copy()
        clone.hall[i] = clone.s[sIdx][idx]
        clone.s[sIdx][idx] = 0
        val (subCost, subStates) = solve(clone, 1)
        if (subCost != Int.MAX_VALUE) {
            val newCost = subCost + costFor(clone.hall[i], idx + start - i + 1)
            if (newCost < cost) {
                cost = newCost
                bestStates = subStates
                bestMoveCost = newCost - subCost
            }
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

        val clone = state.copy()
        clone.hall[i] = clone.s[sIdx][idx]
        clone.s[sIdx][idx] = 0
        val (subCost, subStates) = solve(clone, 1)
        if (subCost != Int.MAX_VALUE) {
            val newCost = subCost + costFor(clone.hall[i], idx + i - start + 1)
            if (newCost < cost) {
                cost = newCost
                bestStates = subStates
                bestMoveCost = newCost - subCost
            }
        }
    }
    bestStates.add(Pair(state, bestMoveCost))
    return Pair(cost, bestStates)
}

fun tryMoveOut(state: State, sIdx: Int, start: Int): Pair<Int, MutableList<Pair<State, Int>>> {
    val array = state.s[sIdx]
    val validToMove = array.any { v -> v != sIdx+1 && v != 0 }
    if (validToMove) {
        for (i in array.indices) {
            if (array[i] != 0) {
                return tryMoveOut2(state, sIdx, i, start)
            }
        }
    }
    return Pair(Int.MAX_VALUE, mutableListOf(Pair(state, Int.MAX_VALUE)))
}

fun tryMoveIn(state: State, sIdx: Int, target: Int): Pair<Int, MutableList<Pair<State, Int>>> {
    if (state.s[sIdx][0] != 0) {
        return Pair(Int.MAX_VALUE, mutableListOf(Pair(state, Int.MAX_VALUE))) // Target is already full!
    }

    var cost = Int.MAX_VALUE
    var bestStates = mutableListOf<Pair<State, Int>>()
    var bestMoveCost = 0
    // Move from hallway to the left
    for (i in target-1 downTo 0) {
        // We can only move a space that's occupied
        if (state.hall[i] != 0) {
            // We can only move when the type matches
            if (state.hall[i] == sIdx+1) {
                for (j in state.s[sIdx].lastIndex downTo 0) {
                    // Look for first unoccupied space in the side room
                    if (state.s[sIdx][j] == 0) {
                        // Success
                        val clone = state.copy()
                        clone.s[sIdx][j] = clone.hall[i]
                        clone.hall[i] = 0
                        val (subCost, subStates) = solve(clone, 1)
                        if (subCost != Int.MAX_VALUE) {
                            val newCost = subCost + costFor(sIdx+1, j + target - i + 1)
                            if (newCost < cost) {
                                cost = newCost
                                bestStates = subStates
                                bestMoveCost = newCost - subCost
                            }
                        }
                        break
                    }
                    // Fail, can't move into side room when occupied by other type!
                    if (state.s[sIdx][j] != sIdx+1) {
                        break
                    }
                }
            }
            break
        }
    }
    // Move from hallway to the right
    for (i in target+1..state.hall.lastIndex) {
        // We can only move a space that's occupied
        if (state.hall[i] != 0) {
            // We can only move when the type matches
            if (state.hall[i] == sIdx+1) {
                for (j in state.s[sIdx].lastIndex downTo 0) {
                    // Look for first unoccupied space in the side room
                    if (state.s[sIdx][j] == 0) {
                        // Success
                        val clone = state.copy()
                        clone.s[sIdx][j] = clone.hall[i]
                        clone.hall[i] = 0
                        val (subCost, subStates) = solve(clone, 1)
                        if (subCost != Int.MAX_VALUE) {
                            val newCost = subCost + costFor(sIdx+1, j + i - target + 1)
                            if (newCost < cost) {
                                cost = newCost
                                bestStates = subStates
                                bestMoveCost = newCost - subCost
                            }
                        }
                        break
                    }
                    // Fail, can't move into side room when occupied by other type!
                    if (state.s[sIdx][j] != sIdx+1) {
                        break
                    }
                }
            }
            break
        }
    }
    bestStates.add(Pair(state, bestMoveCost))
    return Pair(cost, bestStates)
}

fun printState(state: State) {
    println()
    println("#".repeat(state.hall.size + 2))
    print("#")
    for (v in state.hall) {
        if (v != 0) {
            print(v)
        } else {
            print(" ")
        }
    }
    print("#\n")
    for (r in 0..state.s[0].size-1) {
        if (r == 0) {
            print("##")
        } else {
            print("  ")
        }
        for (s in state.s) {
            if (s[r] != 0) {
                print("#${s[r]}")
            } else {
                print("# ")
            }
        }
        if (r == 0) {
            print("###")
        } else {
            print("#  ")
        }
        print("\n")
    }
    println("  #########  ")
}

fun minPair(p1: Pair<Int, MutableList<Pair<State, Int>>>, p2: Pair<Int, MutableList<Pair<State, Int>>>): Pair<Int, MutableList<Pair<State, Int>>> {
    if (p1.first > p2.first) {
        return p2
    }
    return p1
}


val table: HashMap<String, Pair<Int, MutableList<Pair<State, Int>>>> = hashMapOf()
fun solve(state: State, d: Int = 0): Pair<Int, MutableList<Pair<State, Int>>> {
    val key = state.key()
    val entry = table.get(key)
    if (entry != null) {
        return entry
    }
    
    if (state.isSolved()) {
        val result = Pair(0, mutableListOf(Pair(state, 0)))
        table.put(key, result)
        return result
    }

    //printState(state)

//     if (d != 0)
//         return 0

    var cost = Pair(Int.MAX_VALUE, mutableListOf<Pair<State, Int>>())

    // Try moving to hallway
    cost = minPair(cost, tryMoveOut(state, 0, 2))
    cost = minPair(cost, tryMoveOut(state, 1, 4))
    cost = minPair(cost, tryMoveOut(state, 2, 6))
    cost = minPair(cost, tryMoveOut(state, 3, 8))

    // Try moving to side rooms
    cost = minPair(cost, tryMoveIn(state, 0, 2))
    cost = minPair(cost, tryMoveIn(state, 1, 4))
    cost = minPair(cost, tryMoveIn(state, 2, 6))
    cost = minPair(cost, tryMoveIn(state, 3, 8))
    
    table.put(key, cost)
    return cost
}

fun main() {
    // 0 = empty, 1 = A, 2 = B, 3 = C, 4 = D
    val initial = State(4)

    // Full part 1
//     initial.s[0][0] = 2
//     initial.s[0][1] = 4
// 
//     initial.s[1][0] = 2
//     initial.s[1][1] = 3
// 
//     initial.s[2][0] = 3
//     initial.s[2][1] = 1
// 
//     initial.s[3][0] = 4
//     initial.s[3][1] = 1

    // Ex part 1
//     initial.s[0][0] = 2
//     initial.s[0][1] = 1
//     
//     initial.s[1][0] = 3
//     initial.s[1][1] = 4
//     
//     initial.s[2][0] = 2
//     initial.s[2][1] = 3
//     
//     initial.s[3][0] = 4
//     initial.s[3][1] = 1
    
    // Full part 2
    initial.s[0][0] = 2
    initial.s[0][1] = 4
    initial.s[0][2] = 4
    initial.s[0][3] = 4

    initial.s[1][0] = 2
    initial.s[1][1] = 3
    initial.s[1][2] = 2
    initial.s[1][3] = 3

    initial.s[2][0] = 3
    initial.s[2][1] = 2
    initial.s[2][2] = 1
    initial.s[2][3] = 1

    initial.s[3][0] = 4
    initial.s[3][1] = 1
    initial.s[3][2] = 3
    initial.s[3][3] = 1
    
    // Ex part 2
//     initial.s[0][0] = 2
//     initial.s[0][1] = 4
//     initial.s[0][2] = 4
//     initial.s[0][3] = 1
//     
//     initial.s[1][0] = 3
//     initial.s[1][1] = 3
//     initial.s[1][2] = 2
//     initial.s[1][3] = 4
//     
//     initial.s[2][0] = 2
//     initial.s[2][1] = 2
//     initial.s[2][2] = 1
//     initial.s[2][3] = 3
//     
//     initial.s[3][0] = 4
//     initial.s[3][1] = 1
//     initial.s[3][2] = 3
//     initial.s[3][3] = 1

    println("Initial key: ${initial.key()}")

    val (cost, states) = solve(initial.copy())
    
    for ((state, moveCost) in states.asReversed()) {
//         printState(state)
//         println("Move cost $moveCost")
    }
    
    println("Cost: $cost")
}
