#!/usr/bin/perl
use Getopt::Long;

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
#
# Adding generalization on top of this via command line arguments:
#   --pirates is an integer >= 2, defaults to 7
#   --nights is an integer >= 1, defaults to 7
#   --verbose is a flag for more output

my $verbose = '';
my $nights = 7;
my $pirates = 7;
GetOptions ("pirates=i" => \$pirates,
	    "nights=i" => \$nights,
	    "verbose" => \$verbose)
    or die("Error in command line arguments");

my $try = $pirates * ($pirates - 1);

my $flag;

while (1) {
    $flag = 1;
    $current = $try;
    print "Trying $current:" if ($verbose);
    for my $i (1..$nights) {
	print ";SubTry: $current" if ($verbose);
	unless (($current % ($pirates-1)) == 0) {
	    $flag = 0;
	    last;
	}

	print " $i" if ($verbose);
	$current = ($current * $pirates / ($pirates - 1)) + 1;
    }
    print "\n" if ($verbose);
    if ($flag) {
	print "$current\n";;
	last;
    }
    $try += $pirates * ($pirates-1);
}
