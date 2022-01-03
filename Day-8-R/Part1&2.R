
# Run with:
# docker build -t r-lang .
# docker run --rm -i -v "$(pwd)":/aoc -w /aoc r-lang Rscript 'Part1&2.R'

# Good resources:
# - https://www.rdocumentation.org
# - Also use help(command) in the repl!
# - Also magrittr is a useful library!

library(magrittr)

sortStringLetters <- function(s) {
    strsplit(s, '') %>% lapply(sort) %>% sapply(paste, collapse='')
}

isBasicNumber <- function(x) {
    nchar(x) %in% c(2, 4, 3, 7)
}

countMatchingLetters <- function(full, sub) {
    subList <- strsplit(sub, '') %>% unlist
    fullList <- strsplit(full, '') %>% unlist
    subList %>% sapply(function(x){x %in% fullList}) %>% subList[.] %>% length
}

hasAllLetters <- function(full, sub) {
    countMatchingLetters(full, sub) == nchar(sub)
}

count1 <- 0
count2 <- 0

lines <- readLines('stdin')
for (line in lines) {
    elements <- strsplit(line, ' \\| ') %>% unlist
    numbers <- strsplit(elements[1], ' ') %>% unlist %>% sortStringLetters
    code <- strsplit(elements[2], ' ') %>% unlist %>% sortStringLetters

    count1 <- count1 + (code %>% Filter(isBasicNumber, .) %>% length)
    
    # Create the map from number -> letter combination, 10 means 0 since indexing starts at 1 in R
    numToLetters <- character(10)
    
    # Easily mapped numbers (unique number of segments)
    numToLetters[1] <- numbers[nchar(numbers) == 2]
    numToLetters[4] <- numbers[nchar(numbers) == 4]
    numToLetters[7] <- numbers[nchar(numbers) == 3]
    numToLetters[8] <- numbers[nchar(numbers) == 7]
    
    fiveLong <- numbers %>% Filter(function(x) {nchar(x) == 5}, .)
    sixLong <- numbers %>% Filter(function(x) {nchar(x) == 6}, .)

    # Harder to map segments, use overlap between numbers to figure out which is which
    numToLetters[2] <- fiveLong %>% Filter(function(x) {countMatchingLetters(x, numToLetters[4]) == 2}, .)
    numToLetters[3] <- fiveLong %>% Filter(function(x) {hasAllLetters(x, numToLetters[1])}, .)
    numToLetters[5] <- fiveLong %>% Filter(function(x) {x != numToLetters[2] && x != numToLetters[3]}, .)
    numToLetters[6] <- sixLong %>% Filter(function(x) {!hasAllLetters(x, numToLetters[1])}, .)
    numToLetters[9] <- sixLong %>% Filter(function(x) {hasAllLetters(x, numToLetters[4])}, .)
    numToLetters[10] <- sixLong %>% Filter(function(x) {x != numToLetters[6] && x != numToLetters[9]}, .)
    
    # Compute inverse mapping
    lettersToNum <- list()
    for (num in 1:10) {
        lettersToNum[[numToLetters[num]]] = num %% 10
    }
    
    count2 <- count2 + (code %>% Reduce(function(a, b){ a*10 + lettersToNum[[b]] }, ., 0))
}
print(paste('Part 1:', count1))
print(paste('Part 2:', count2))
