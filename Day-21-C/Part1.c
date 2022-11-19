// Run with:
// docker run --rm -i -v "$(pwd)":/aoc -w /aoc gcc bash -c "gcc 'Part1.c' && ./a.out"

#include "stdio.h"
#include "stdbool.h"

typedef struct {
    int next;
    int rolls;
} die_t;

int roll_die(die_t *die) {
    int v = die->next++ + 1;
    die->next %= 100;
    die->rolls++;
    return v;
}

void main() {
    int p1;
    int p2;
    scanf("Player 1 starting position: %d\n", &p1);
    scanf("Player 2 starting position: %d\n", &p2);
    
    p1 -= 1;
    p2 -= 1;
    
    bool turn = true;
    int s1 = 0;
    int s2 = 0;
    die_t die;
    while (s1 < 1000 && s2 < 1000) {
        if (turn) {
            p1 = (p1 + roll_die(&die) + roll_die(&die) + roll_die(&die)) % 10;
            s1 += p1 + 1;
        } else {
            p2 = (p2 + roll_die(&die) + roll_die(&die) + roll_die(&die)) % 10;
            s2 += p2 + 1;
        }
        turn = !turn;
    }
    
    printf("P1 score: %d\n", s1);
    printf("P2 score: %d\n", s2);
    printf("Die rolls: %d\n", die.rolls);
    printf("");
    printf("Part 1: %d\n", die.rolls * (s1 >= 1000 ? s2 : s1));
}