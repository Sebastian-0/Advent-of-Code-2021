
# Run with:
# docker run --rm -i -v "$(pwd)":/aoc -w /aoc perl perl 'Part1&2.pl'

# Good resources:
# - Tutorial overview: https://perldoc.perl.org/perl#Tutorials
# - General intro: https://perldoc.perl.org/perlintro
# - Operators: https://perldoc.perl.org/perlop
# - Data types: https://perldoc.perl.org/perldata#Version-Strings
# - Pre-defined variables: https://perldoc.perl.org/perlvar
# - How to define subroutines: https://www.tutorialspoint.com/perl/perl_subroutines.htm


use strict;
use warnings;

use List::Util qw( min max );

# The polymer rules as given by the input
my %mappings;
# The initial starting state as given by the input
my $string = '';

# Trim leading/trailing whitespace
sub trim {
    $_ =~ s/^\s+|\s+$//g;
}

# Ceil the input value
sub ceil {
    return int($_[0] + 0.99999);
}

# Applies the polymer rules once.
# - Input/Output are hashes counting how often each rule occured in the previous iteration.
# - This function uses the global $mappings variable
sub step {
    my (%counts) = @_;
    my %new_counts;
    foreach my $key (keys %counts) {
        my $w1 = substr($key, 0, 1) . $mappings{$key};
        my $w2 = $mappings{$key} . substr($key, 1, 1);
        $new_counts{$w1} += $counts{$key};
        $new_counts{$w2} += $counts{$key};
    }
    return %new_counts;
}

# Convert counts of pairs of polymers to how often each character appears
sub collect {
    my (%counts) = @_;
    my %chars;
    foreach my $key (keys %counts) {
        $chars{substr $key, 0, 1} += $counts{$key};
        $chars{substr $key, 1, 1} += $counts{$key};
    }
    # Since we count the characters twice we need to divide by two here!
    # The exceptions are the first and last characters that are only counted once.
    foreach my $key (keys %chars) {
        my $first_letter = substr $string, 0, 1;
        my $last_letter = substr $string, -1, 1;
        
        # Don't divide the first/last characters
        my $single_counted = 0;
        if ($key eq $first_letter) {
            $single_counted += 1;
        }
        if ($key eq $last_letter) {
            $single_counted += 1;
        }
        $chars{$key} = ceil(($chars{$key} - $single_counted) / 2) + $single_counted;
    }
    return %chars;
}

# Computes difference between #occurences of most/least occuring characters
sub min_max {
    my (%chars) = @_;
    my $min = min (values %chars);
    my $max = max (values %chars);
    return $max - $min;
}

# Read input, note that we use the default variable $_ to store intermediary results
while(<>) {
    trim;
    if (/[A-Z]+ -> [A-Z]+/) {
        my @tokens = split / -> /;
        $mappings{$tokens[0]} = $tokens[1];
    } elsif (/[A-Z]+/) {
        $string = $_;
        $string =~ s/\s+$//;
    }
}

# Compute how many times each rule occurs in the input
my %counts;
for (my $i = 0; $i < length($string) - 1; $i++) {
    my $word = substr $string, $i, 2;
    if (exists $mappings{$word}) {
        $counts{$word} += 1;
    } else {
        print "Missing mapping for $word!\n";
    }
}

# Run first 10 steps
for (my $i = 0; $i < 10; $i++) {
    %counts = step(%counts);
}

my %chars = collect(%counts);
my $delta = min_max(%chars);
print "Delta after 10 steps: $delta\n";

# Run 30 more steps for a total of 40
for (my $i = 0; $i < 30; $i++) {
    %counts = step(%counts);
}

%chars = collect(%counts);
$delta = min_max(%chars); # This becomes one too many for the example input, I don't know why though.
print "Delta after 40 steps: $delta\n";
