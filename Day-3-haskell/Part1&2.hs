
-- Run with:
-- docker run --rm -i -v "$(pwd)":/haskell -w /haskell haskell bash -c "ghc -o a.out 'Part1&2.hs' && ./a.out"

import Data.Char

-- Common utilities
stringToInts :: String -> [Int]
stringToInts = map digitToInt

stringsToInts :: [String] -> [[Int]]
stringsToInts = map stringToInts

valuesAtIdx :: Int -> [[Int]] -> [Int]
valuesAtIdx idx = map (!!idx)

sumAtIndex :: Int -> [[Int]] -> Int
sumAtIndex idx values = sum $ valuesAtIdx idx values

leastCommonAtIndex :: Int -> [[Int]] -> Int
leastCommonAtIndex idx values
    | fromIntegral(sumAtIndex idx values) >= fromIntegral(length values) / 2 = 0
    | otherwise                                                              = 1

mostCommonAtIndex :: Int -> [[Int]] -> Int
mostCommonAtIndex idx values
    | fromIntegral(sumAtIndex idx values) >= fromIntegral(length values) / 2 = 1
    | otherwise                                                              = 0

-- Part 1
mostCommonAtEachIndex :: [[Int]] -> [Int]
mostCommonAtEachIndex values = go values 0
    where go xs i 
            | i < length (xs!!0) = [mostCommonAtIndex i xs] ++ go xs (i + 1)
            | otherwise          = []

invert :: [Int] -> [Int]
invert bits = go bits
    where go []     = []
          go (x:xs) = [(x + 1) `mod` 2] ++ go xs

bitsToNumber :: [Int] -> Int
bitsToNumber bits = go (reverse bits) 0
    where go [] _     = 0
          go (x:xs) i = x * 2^i + (go xs $ i + 1)

partOne :: [[Int]] -> Int
partOne values = (bitsToNumber x) * (bitsToNumber (invert x))
    where x = mostCommonAtEachIndex values

-- Part 2

pruneNonMatching :: [[Int]] -> Int -> Int -> [[Int]]
pruneNonMatching values idx required = go values idx required
    where go [] _ _     = []
          go (x:xs) i b
              | x!!i == b = [x] ++ go xs i b
              | otherwise = go xs i b

oxygenRating :: [[Int]] -> Int
oxygenRating values = go values 0
    where go xs i
            | length xs == 1 = bitsToNumber $ xs!!0
            | otherwise      = go (pruneNonMatching xs i (mostCommonAtIndex i xs)) $ i + 1

co2Rating :: [[Int]] -> Int
co2Rating values = go values 0
    where go xs i
            | length xs == 1 = bitsToNumber $ xs!!0
            | otherwise      = go (pruneNonMatching xs i (leastCommonAtIndex i xs)) $ i + 1

partTwo :: [[Int]] -> Int        
partTwo values = (oxygenRating values) * (co2Rating values)

-- Main
main = do
    inp <- getContents
    let values = stringsToInts $ lines inp
    putStrLn $ "gamma * epsilon = " ++ show (partOne values)
    putStrLn $ "oxygen * CO2 = " ++ show (partTwo values)
