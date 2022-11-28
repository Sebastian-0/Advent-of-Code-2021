// Run with:
// docker build -t kotlin .
// docker run --rm -i -v "$(pwd)":/aoc -w /aoc kotlin bash -c "kotlinc -include-runtime -d out.jar 'Part12.kt' && java -jar out.jar"

// Good resources:
// - Kotlin docs: https://kotlinlang.org/docs/home.html
// - API reference: https://kotlinlang.org/api/latest/jvm/stdlib/

import kotlin.math.min
import java.util.Arrays

class State(val depth: Int) {
    val hall = IntArray(11)
    val side = Array(4) { IntArray(depth) }

    fun copy(): State {
        val copy = State(side[0].size)
        side[0].copyInto(copy.side[0]);
        side[1].copyInto(copy.side[1]);
        side[2].copyInto(copy.side[2]);
        side[3].copyInto(copy.side[3]);
        hall.copyInto(copy.hall);
        return copy
    }

    fun isSolved(): Boolean {
        return side[0].all { v -> v == 1 } &&
            side[1].all { v -> v == 2 } &&
            side[2].all { v -> v == 3 } &&
            side[3].all { v -> v == 4 }
    }
    
    override fun hashCode(): Int {
        var hash = Arrays.hashCode(hall)
        hash = hash * 31 + Arrays.hashCode(side[0])
        hash = hash * 31 + Arrays.hashCode(side[1])
        hash = hash * 31 + Arrays.hashCode(side[2])
        hash = hash * 31 + Arrays.hashCode(side[3])
        return hash
    }
    
    override fun equals(other: Any?): Boolean {
        if (other is State) {
            return hall contentEquals other.hall &&
                side[0] contentEquals other.side[0] &&
                side[1] contentEquals other.side[1] &&
                side[2] contentEquals other.side[2] &&
                side[3] contentEquals other.side[3]
        }
        return false
    }
}

fun moveCost(type: Int, steps: Int): Int {
    return when (type) {
        1 -> 1
        2 -> 10
        3 -> 100
        4 -> 1000
        else -> {
            throw java.lang.IllegalArgumentException("Unknown type: $type")
        }
    } * steps
}

// Mark hallway indices that are directly outside the side rooms as invalid
val INVALID_HALL_INDICES = setOf(2, 4, 6, 8)
fun tryMoveToHallway2(state: State, sideRoomIdx: Int, idx: Int, startHallIdx: Int): Int {
    var cost = Int.MAX_VALUE
    
    // Search for an empty hallway space to the left
    for (i in startHallIdx-1 downTo 0) {
        if (i in INVALID_HALL_INDICES) {
            continue
        }

        // If occupied abort, we can't move into/past another value
        if (state.hall[i] != 0) {
            break
        }

        val clone = state.copy()
        clone.hall[i] = clone.side[sideRoomIdx][idx]
        clone.side[sideRoomIdx][idx] = 0
        val subCost = doSolve(clone)
        if (subCost != Int.MAX_VALUE) {
            cost = min(cost, subCost + moveCost(clone.hall[i], idx + startHallIdx - i + 1))
        }
    }

    // Search for an empty hallway space to the right
    for (i in startHallIdx+1..state.hall.lastIndex) {
        if (i in INVALID_HALL_INDICES) {
            continue
        }

        // If occupied abort, we can't move into/past another value
        if (state.hall[i] != 0) {
            break
        }

        val clone = state.copy()
        clone.hall[i] = clone.side[sideRoomIdx][idx]
        clone.side[sideRoomIdx][idx] = 0
        val subCost = doSolve(clone)
        if (subCost != Int.MAX_VALUE) {
            cost = min(cost, subCost + moveCost(clone.hall[i], idx + i - startHallIdx + 1))
        }
    }
    return cost
}

fun tryMoveToHallway(state: State, sideRoomIdx: Int, startHallIdx: Int): Int {
    val sideRoom = state.side[sideRoomIdx]
    // We can only move from the side room if there are incorrect values left
    if (sideRoom.any { v -> v != sideRoomIdx + 1 && v != 0 }) {
        for (i in sideRoom.indices) {
            // We can only move a space that's occupied
            if (sideRoom[i] != 0) {
                return tryMoveToHallway2(state, sideRoomIdx, i, startHallIdx)
            }
        }
    }
    return Int.MAX_VALUE
}

fun tryMoveToSideRoom(state: State, sideRoomIdx: Int, targetHallIdx: Int): Int {
    if (state.side[sideRoomIdx][0] != 0) {
        return Int.MAX_VALUE // Target is already full!
    }

    var cost = Int.MAX_VALUE
    // Search for a non-empty hallway space to the left
    for (i in targetHallIdx-1 downTo 0) {
        // We can only move a space that's occupied
        if (state.hall[i] != 0) {
            // We can only move when the type matches
            if (state.hall[i] == sideRoomIdx+1) {
                for (j in state.side[sideRoomIdx].lastIndex downTo 0) {
                    // Look for first unoccupied space in the side room
                    if (state.side[sideRoomIdx][j] == 0) {
                        val clone = state.copy()
                        clone.side[sideRoomIdx][j] = clone.hall[i]
                        clone.hall[i] = 0
                        val subCost = doSolve(clone)
                        if (subCost != Int.MAX_VALUE) {
                            cost = min(cost, subCost + moveCost(sideRoomIdx+1, j + targetHallIdx - i + 1))
                        }
                        break
                    }
                    // Fail, can't move into side room when occupied by other type!
                    if (state.side[sideRoomIdx][j] != sideRoomIdx+1) {
                        break
                    }
                }
            }
            break
        }
    }
    
    // Search for a non-empty hallway space to the right
    for (i in targetHallIdx+1..state.hall.lastIndex) {
        // We can only move a space that's occupied
        if (state.hall[i] != 0) {
            // We can only move when the type matches
            if (state.hall[i] == sideRoomIdx+1) {
                for (j in state.side[sideRoomIdx].lastIndex downTo 0) {
                    // Look for first unoccupied space in the side room
                    if (state.side[sideRoomIdx][j] == 0) {
                        val clone = state.copy()
                        clone.side[sideRoomIdx][j] = clone.hall[i]
                        clone.hall[i] = 0
                        val subCost = doSolve(clone)
                        if (subCost != Int.MAX_VALUE) {
                            cost = min(cost, subCost + moveCost(sideRoomIdx+1, j + i - targetHallIdx + 1))
                        }
                        break
                    }
                    // Fail, can't move into side room when occupied by other type!
                    if (state.side[sideRoomIdx][j] != sideRoomIdx+1) {
                        break
                    }
                }
            }
            break
        }
    }
    return cost
}

val table: HashMap<State, Int> = hashMapOf()
fun doSolve(state: State): Int {
    val entry = table.get(state)
    if (entry != null) {
        return entry
    }
    
    if (state.isSolved()) {
        table.put(state, 0)
        return 0
    }

    var cost = Int.MAX_VALUE

    // Try moving side rooms -> hallway
    cost = min(cost, tryMoveToHallway(state, 0, 2))
    cost = min(cost, tryMoveToHallway(state, 1, 4))
    cost = min(cost, tryMoveToHallway(state, 2, 6))
    cost = min(cost, tryMoveToHallway(state, 3, 8))

    // Try moving hallway -> side rooms
    cost = min(cost, tryMoveToSideRoom(state, 0, 2))
    cost = min(cost, tryMoveToSideRoom(state, 1, 4))
    cost = min(cost, tryMoveToSideRoom(state, 2, 6))
    cost = min(cost, tryMoveToSideRoom(state, 3, 8))
    
    table.put(state, cost)
    return cost
}

fun solve(state: State): Int {
    table.clear()
    return doSolve(state)
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
    for (r in 0..state.depth-1) {
        if (r == 0) {
            print("##")
        } else {
            print("  ")
        }
        for (s in state.side) {
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

fun main() {
    // We translate letters to numbers as follows:
    // 0 = empty
    // 1 = A
    // 2 = B
    // 3 = C
    // 4 = D
    
    var initial = State(2)
    
    // Full part 1
    initial.side[0][0] = 2
    initial.side[0][1] = 4

    initial.side[1][0] = 2
    initial.side[1][1] = 3

    initial.side[2][0] = 3
    initial.side[2][1] = 1

    initial.side[3][0] = 4
    initial.side[3][1] = 1

    // Example part 1
//     initial.side[0][0] = 2
//     initial.side[0][1] = 1
//     
//     initial.side[1][0] = 3
//     initial.side[1][1] = 4
//     
//     initial.side[2][0] = 2
//     initial.side[2][1] = 3
//     
//     initial.side[3][0] = 4
//     initial.side[3][1] = 1

    println("Cost (part 1): ${solve(initial)}")
    
    initial = State(4)
    
    // Full part 2
    initial.side[0][0] = 2
    initial.side[0][1] = 4
    initial.side[0][2] = 4
    initial.side[0][3] = 4

    initial.side[1][0] = 2
    initial.side[1][1] = 3
    initial.side[1][2] = 2
    initial.side[1][3] = 3

    initial.side[2][0] = 3
    initial.side[2][1] = 2
    initial.side[2][2] = 1
    initial.side[2][3] = 1

    initial.side[3][0] = 4
    initial.side[3][1] = 1
    initial.side[3][2] = 3
    initial.side[3][3] = 1
    
    // Example part 2
//     initial.side[0][0] = 2
//     initial.side[0][1] = 4
//     initial.side[0][2] = 4
//     initial.side[0][3] = 1
//     
//     initial.side[1][0] = 3
//     initial.side[1][1] = 3
//     initial.side[1][2] = 2
//     initial.side[1][3] = 4
//     
//     initial.side[2][0] = 2
//     initial.side[2][1] = 2
//     initial.side[2][2] = 1
//     initial.side[2][3] = 3
//     
//     initial.side[3][0] = 4
//     initial.side[3][1] = 1
//     initial.side[3][2] = 3
//     initial.side[3][3] = 1
    
    println("Cost (part 2): ${solve(initial)}")
}
