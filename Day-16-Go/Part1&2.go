// Run with:
// docker run --rm -i -v "$(pwd)":/aoc -w /aoc golang go run 'Part1&2.go'

// Good resources:
// - Tour: https://go.dev/tour
// - API docs: https://pkg.go.dev
// - How to right "proper" go: https://go.dev/doc/effective_go

package main

import (
    "fmt"
    "bufio"
    "os"
)

const TRACE = false

func log(a ...any) {
    if TRACE {
        fmt.Println(a...)
    }
}

func toBits(hex string) []int {
    bits := []int{}
    for _, char := range hex {
        switch char {
            case '0':
                bits = append(bits, 0, 0, 0, 0)
            case '1':
                bits = append(bits, 0, 0, 0, 1)
            case '2':
                bits = append(bits, 0, 0, 1, 0)
            case '3':
                bits = append(bits, 0, 0, 1, 1)
            case '4':
                bits = append(bits, 0, 1, 0, 0)
            case '5':
                bits = append(bits, 0, 1, 0, 1)
            case '6':
                bits = append(bits, 0, 1, 1, 0)
            case '7':
                bits = append(bits, 0, 1, 1, 1)
            case '8':
                bits = append(bits, 1, 0, 0, 0)
            case '9':
                bits = append(bits, 1, 0, 0, 1)
            case 'A':
                bits = append(bits, 1, 0, 1, 0)
            case 'B':
                bits = append(bits, 1, 0, 1, 1)
            case 'C':
                bits = append(bits, 1, 1, 0, 0)
            case 'D':
                bits = append(bits, 1, 1, 0, 1)
            case 'E':
                bits = append(bits, 1, 1, 1, 0)
            case 'F':
                bits = append(bits, 1, 1, 1, 1)
        }
    }
    return bits
}

func bitsToNum(bits []int) int {
    result := 0
    for _, b := range bits {
        result <<= 1
        result += b
    }
    return result
}

func readField(bits []int, length int, idx *int) int {
    val := bitsToNum(bits[*idx:*idx + length])
    *idx += length
    return val
}

func readLiteral(bits []int, idx *int) int {
    numBits := []int{}
    for {
        isLast := bits[*idx] == 0
        numBits = append(numBits, bits[*idx+1 : *idx+5]...)
        if isLast {
            break
        }
        *idx += 5
    }
    *idx += 5
    return bitsToNum(numBits)
}

func readSubPackages(bits []int, idx, versionSum *int, indent string) []int {
    subPackages := []int {}
    lengthTypeID := readField(bits, 1, idx)
    if lengthTypeID == 0 {
        totalBits := readField(bits, 15, idx)
        log(indent + " - Sub bits:", totalBits)
        target := *idx + totalBits
        for *idx < target {
            value := readPackage(bits, idx, versionSum, indent + "  ")
            subPackages = append(subPackages, value)
        }
        
        if *idx != target {
            fmt.Println("Idx does not match target!")
        }
    } else {
        totalSubPackages := readField(bits, 11, idx)
        log(indent + " - Sub pkgs:", totalSubPackages)
        
        for i := 0; i < totalSubPackages; i++ {
            value := readPackage(bits, idx, versionSum, indent + "  ")
            subPackages = append(subPackages, value)
        }
    }
    return subPackages
}

func readPackage(bits []int, idx, versionSum *int, indent string) int {
    version := readField(bits, 3, idx)
    typeID := readField(bits, 3, idx)
    log(indent + "Package:", version, typeID)
    
    value := 0
    *versionSum += version
    
    switch typeID {
        case 0:
            values := readSubPackages(bits, idx, versionSum, indent)
            for _, v := range values {
                value += v
            }
            log(indent + " - Sum", value)
        case 1:
            values := readSubPackages(bits, idx, versionSum, indent)
            value = values[0]
            for _, v := range values[1:] {
                value *= v
            }
            log(indent + " - Product", value)
        case 2:
            values := readSubPackages(bits, idx, versionSum, indent)
            value = values[0]
            for _, v := range values {
                if v < value {
                    value = v
                }
            }
            log(indent + " - Min", value)
        case 3:
            values := readSubPackages(bits, idx, versionSum, indent)
            value = values[0]
            for _, v := range values {
                if v > value {
                    value = v
                }
            }
            log(indent + " - Max", value)
        case 4:
            value = readLiteral(bits, idx)
            log(indent + " - Literal", value)
        case 5:
            values := readSubPackages(bits, idx, versionSum, indent)
            if values[0] > values[1] {
                value = 1
            }
            log(indent + " - Greater than", value)
        case 6:
            values := readSubPackages(bits, idx, versionSum, indent)
            if values[0] < values[1] {
                value = 1
            }
            log(indent + " - Less than", value)
        case 7:
            values := readSubPackages(bits, idx, versionSum, indent)
            if values[0] == values[1] {
                value = 1
            }
            log(indent + " - Equal to", value)
        default:
            fmt.Println("Unrecognized command!", typeID)
            break
    }
    return value
}

func main() {
    reader := bufio.NewReader(os.Stdin)
    hex, _ := reader.ReadString('\n')
    bits := toBits(hex)
    
    versionSum := 0
    idx := 0
    value := readPackage(bits, &idx, &versionSum, "") // Always just one main package
    
    fmt.Println()
    fmt.Println("Version sum:", versionSum)
    fmt.Println("Package value:", value)
}
