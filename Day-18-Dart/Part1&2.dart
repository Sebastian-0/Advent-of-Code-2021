// Run with:
// docker run --rm -i -v "$(pwd)":/aoc -w /aoc dart dart 'Part1&2.dart'

// Good resources:
// - Language samples: https://dart.dev/samples
// - API reference: https://api.dart.dev

import 'dart:convert';
import 'dart:io';
import 'dart:math';

class Node {
    Node? left;
    Node? right;
    Node? parent;
    
    int? num;
    
    bool isNum() {
        return num != null;
    }
    
    bool mergeLeft(Node source, int number) {
        if (isNum()) {
            num = num! + number;
            return true;
        }
        
        if (source == parent) {
            return right!.mergeLeft(this, number) || left!.mergeLeft(this, number);
        }

        if (source == right) {
            return left!.mergeLeft(this, number) || (parent?.mergeLeft(this, number) ?? false);
        }
        
        if (source == left) {
            return parent?.mergeLeft(this, number) ?? false;
        }
        
        return false;
    }
    
    bool mergeRight(Node source, int number) {
        if (isNum()) {
            num = num! + number;
            return true;
        }
        
        if (source == parent) {
            return left!.mergeRight(this, number) || right!.mergeRight(this, number);
        }

        if (source == left) {
            return right!.mergeRight(this, number) || (parent?.mergeRight(this, number) ?? false);
        }
        
        if (source == right) {
            return parent?.mergeRight(this, number) ?? false;
        }
        
        return false;
    }
    
    bool explode([int depth = 0]) {
        if (isNum()) {
            return false;
        }
        
        if (depth == 4) {
            assert(left!.isNum());
            assert(right!.isNum());
            parent!.mergeLeft(this, left!.num!);
            parent!.mergeRight(this, right!.num!);
            left = null;
            right = null;
            num = 0;
            return true;
        }

        return left!.explode(depth + 1) || right!.explode(depth + 1);
    }
    
    bool split() {
        if (isNum()) {
            if (num! > 9) {
                left = Node();
                right = Node();
                left!.parent = this;
                right!.parent = this;
                left!.num = num! ~/ 2; // Integer division operator
                right!.num = num! - left!.num!;
                num = null;
                return true;
            }
        } else {
            return left!.split() || right!.split();
        }
        return false;
    }
    
    int magnitude() {
        if (isNum()) {
            return num!;
        }
        return left!.magnitude() * 3 + right!.magnitude() * 2;
    }
    
    Node clone([Node? parent = null]) {
        final clone = Node();
        clone.parent = parent;
        clone.num = num;
        clone.left = left?.clone(clone);
        clone.right = right?.clone(clone);
        return clone;
    }
    
    @override String toString() {
        if (isNum()) {
            return "$num";
        }
        return "[$left,$right]";
    }
}

class Parser {
    int idx = 0;
    String line;
    
    Parser(this.line);
    
    Node parse([Node? parent = null]) {
        final node = Node();
        node.parent = parent;
        if (line[idx] == '[') {
            idx++; // Skip [
            node.left = parse(node);
            idx++; // Skip ,
            node.right = parse(node);
            idx++; // Skip ]
        } else {
            final regex = RegExp(r'^(\d+)');
            final match = regex.firstMatch(line.substring(idx))?.group(1);
            if (match != null) {
                idx += match.length;
                node.num = int.parse(match);
            }
        }
        return node;
    }
}

void reduce(Node node) {
    while (node.explode() || node.split());
}

Node add(Node n1, Node n2) {
    final node = Node();
    node.left = n1;
    node.right = n2;
    n1.parent = node;
    n2.parent = node;
    reduce(node);
    return node;
}

void main() {
    final numbers = <Node>[];
    String? input;
    while ((input = stdin.readLineSync(encoding: utf8)) != null) {
        final line = input!;
        numbers.add(Parser(line).parse());
    }
    
    var result = numbers[0].clone();
    for (final number in numbers.sublist(1)) {
        result = add(result, number.clone());
    }
    
    print("Resulting number: $result");
    print("Magnitude is: ${result.magnitude()}");
    
    var highest = 0;
    for (final n1 in numbers) {
        for (final n2 in numbers) {
            if (n1 != n2) {
                highest = max(highest, add(n1.clone(), n2.clone()).magnitude());
            }
        }
    }
    print("Highest pairwise magnitude is: $highest");
}