// Run with:
// docker run --rm -i -v "$(pwd)":/aoc -w /aoc gcc bash -c "gcc 'Part2.c' && ./a.out"

#include "stdio.h"
#include "stdbool.h"

// This table says how many times each sum of throws occcurs. Since we throw three times and
// the dice are three-sided we end up with sums from 3 to 9 which occur with different
// frequencies. E.g. throwing three 1s can only happen one way but one 2 and two 1s can
// happen three ways, etc...
int OCCURRENCES[] = {
    0, // Padding
    0, // Padding
    0, // Padding
    1, // 3
    3, // 4
    6, // 5
    7, // 6
    6, // 7
    3, // 8
    1, // 9
};

typedef struct {
    unsigned long long p1_wins;
    unsigned long long p2_wins;
} wins_t;

wins_t count_universes(int p1, int p2, int s1, int s2, bool turn, unsigned long long times) {
    if (s1 >= 21) {
        return (wins_t) { .p1_wins = times };
    }
    if (s2 >= 21) {
        return (wins_t) { .p2_wins = times };
    }
    
    wins_t result = { 0 };
    for (int i = 3; i <= 9; i++) {
        wins_t partial;
        if (turn) {
            int newP1 = (p1 + i) % 10;
            partial = count_universes(newP1, p2, s1 + newP1 + 1, s2, false, times * OCCURRENCES[i]);
        } else {
            int newP2 = (p2 + i) % 10;
            partial = count_universes(p1, newP2, s1, s2 + newP2 + 1, true, times * OCCURRENCES[i]);
        }
        result.p1_wins += partial.p1_wins;
        result.p2_wins += partial.p2_wins;
    }
    return result;
}

void main() {
    int p1;
    int p2;
    scanf("Player 1 starting position: %d\n", &p1);
    scanf("Player 2 starting position: %d\n", &p2);
    
    wins_t result = count_universes(p1-1, p2-1, 0, 0, true, 1);
    printf("Wins for P1: %llu\n", result.p1_wins);
    printf("Wins for P2: %llu\n", result.p2_wins);
}