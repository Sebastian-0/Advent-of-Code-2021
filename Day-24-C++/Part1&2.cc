// Run with:
// docker run --rm -i -v "$(pwd)":/aoc -w /aoc gcc bash -c "g++ 'Part1&2.cc' && ./a.out"

// Good resources:
// - API reference: https://en.cppreference.com/w/
// - StackOverflow, you will need it :)

#include <iostream>
#include <vector>
#include <unordered_map>
#include <algorithm>
#include <sstream>
#include <string>

typedef long long number_t;

// Define our custom table & key types
typedef std::tuple<int, number_t> tbl_key_t;
typedef std::unordered_map<tbl_key_t, bool> tbl_t;

// Implement the hash-function for our custom key type
namespace std {
    template <>
    struct hash<tbl_key_t> {
        std::size_t operator()(const tbl_key_t& k) const {
            return std::hash<int>()(std::get<0>(k)) * 31 +
                std::hash<number_t>()(std::get<1>(k));
        }
    };
}

const int MODEL_NUMBER_LENGTH= 14;

// After some analysis it turned out that almost all instructions in my input
// were duplicated for each number being read. Only three instructions were 
// modified and the only thing changed was the numeric constants. I extracted
// these constants into lookup tables and wrote a compact version of the actual
// computations.
number_t V1[] = { 13, 12, 10, -11, 14, 13, 12, -5, 10, 0, -11, -13, -13, -11 };
number_t V2[] = { 8, 16, 4, 1, 13, 5, 0, 10, 7, 2, 13, 15, 14, 9 };
number_t DIV[] = { 1, 1, 1, 26, 1, 1, 1, 26, 1, 26, 26, 26, 26, 26 };

number_t compute_program(int number_idx, number_t z, number_t w) {
    number_t x = z % 26 + V1[number_idx];

    if (x != w) {
        return (z / DIV[number_idx]) * 26 + (w + V2[number_idx]);
    } else {
        return (z / DIV[number_idx]);
    }
}

bool solve_for_idx(
        tbl_t& table,
        bool find_max,
        std::vector<int>& model_number,
        int number_idx,
        number_t z) {
    auto key = std::make_tuple(number_idx, z);
    if (table.count(key) != 0) {
        return table[key];
    }
    
    if (number_idx == MODEL_NUMBER_LENGTH) {
        table[key] = z == 0;
        return table[key];
    }
    
    table[key] = false;
    // Check for big values of z to prevent overflow, don't know if this is needed though!
    if (z < 10000000000) {
        for (number_t w = find_max ? 9 : 1; find_max ? w >= 1 : w <= 9; find_max ? w-- : w++) {
            number_t z_new = compute_program(number_idx, z, w);
            if (solve_for_idx(table, find_max, model_number, number_idx + 1, z_new)) {
                model_number[number_idx] = w;
                table[key] = true;
                break;
            }
        }
    }
    
    return table[key];
}

bool solve(std::vector<int>& model_number, bool look_for_max) {
    tbl_t table;
    return solve_for_idx(table, look_for_max, model_number, 0, 0);
}

void print(std::vector<int>& modelNumber) {
    for (auto n : modelNumber) {
        std::cout << n;
    }
}

int main() {
    std::vector<int> model_number(MODEL_NUMBER_LENGTH);
    
    if (solve(model_number, true)) {
        std::cout << "Max model number: ";
        print(model_number);
        std::cout << std::endl;
    }
    
    if (solve(model_number, false)) {
        std::cout << "Min model number: ";
        print(model_number);
        std::cout << std::endl;
    }
    
    return 0;
}