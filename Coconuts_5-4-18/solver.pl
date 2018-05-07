#!/usr/bin/perl

# solver for: https://fivethirtyeight.com/features/pirates-monkeys-and-coconuts-oh-my/
#
# We're going to work backwards, trying a number of coconuts that's
# left over in the morning, then working backwards towards before the
# pirates wake up. If any of the pirates would need to see a non-whole
# number of coconuts, then the number we're trying can't be right and
# we should try the next one. If all 7 pirates are able to divide the
# coconut pile without creating fractions, then we've found the
# answer.

# Since the operation of each night is (x*7/6)+1, if our current try
# isn't divisible by 6, it's not going to work. Additionally, the
# final number needs to be divisible by 7, so the final number of
# coconuts needs to be a multiple of 42 (7*6)

my $verbose = 0;
my $try = 42;
my $flag;

while (1) {
    $flag = 1;
    $current = $try;
    print "Trying $current:" if ($verbose);
    for my $i (1..7) {
	print "\tSubTry: $current" if ($verbose);
	unless (($current % 6) == 0) {
	    $flag = 0;
	    last;
	}
	print " $i" if ($verbose);
	$current = ($current * 7 / 6) + 1;
    }
    print "\n" if ($verbose);
    if ($flag) {
	print "$current\n";;
	last;
    }
    $try += 42;
}
