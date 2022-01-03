<?php
// Run with:
// docker build -t php .
// docker run --rm -i -v "$(pwd)":/aoc -w /aoc php php -f 'Part1&2.php'
// 
// Good resources:
// - https://www.php.net/manual/en/langref.php
// - https://www.php.net/manual/en/funcref.php

class Node {
    public $id;
    public $isSmall;
    public $neighbors = [];
    
    function __construct($id) {
        $this->id = $id;
        $this->isSmall = ctype_lower($id);
    }
}

function readNodes() {
    $nodes = [];
    while (true) {
        $line = readline();
        if ($line === false) {
            break;
        }
        
        $tokens = explode('-', $line);
        
        $node1 = $nodes[$tokens[0]] ?? new Node($tokens[0]);
        $node2 = $nodes[$tokens[1]] ?? new Node($tokens[1]);
        
        $node1->neighbors[] = $node2;
        $node2->neighbors[] = $node1;
        
        $nodes[$tokens[0]] = $node1;
        $nodes[$tokens[1]] = $node2;
    }
    return $nodes;
}

function countPaths($node, $visited, $hasVisitedTwice) {
    if ($node->id === "end") {
        return 1;
    }
    
    $paths = 0;
    if ($node->isSmall) {
        if (!$hasVisitedTwice && $node->id !== "start") {
            // If we haven't visited a node twice yet we try to visit this node twice. Note that it
            // hasn't been added to "visited" at this point.
            $paths += visitNeighbours($node, $visited, true);
        }
        $visited->add($node->id);
        if (!$hasVisitedTwice && $node->id !== "start") {
            // Then we need to subtract all the paths that we count twice (all possible paths where
            // node wasn't visited a second time). Note that now the node has been added to "visited".
            $paths -= visitNeighbours($node, $visited, true);
        }
    }
    
    $paths += visitNeighbours($node, $visited, $hasVisitedTwice);
    return $paths;
}

function visitNeighbours($node, $visited, $hasVisitedTwice) {
    $paths = 0;
    foreach ($node->neighbors as $n) {
        if (!$visited->contains($n->id)) {
            $v = $visited->copy();
            $paths += countPaths($n, $v, $hasVisitedTwice);
        }
    }
    return $paths;
}

$nodes = readNodes();
$start = $nodes["start"];

echo "Total amount of paths (single visit): " . countPaths($start, new \Ds\Set(), true) . "\n";
echo "Total amount of paths (double visit): " . countPaths($start, new \Ds\Set(), false) . "\n";
?>