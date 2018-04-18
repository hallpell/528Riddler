#!/usr/bin/perl

my @twoDiceProbs = (0, 0, 1/36, 2/36, 3/36, 4/36, 5/36, 6/36, 5/36, 4/36, 3/36, 2/36, 1/36);
my %memoization;

sub solver { # returns the probability of winning from this state
    #    print "Called: @_\n";
    my $rolled = shift;
    my @openBoxes = @_;
    if (exists($memoization{"$rolled\t@openBoxes"})) {
	return $memoization{"$rolled\t@openBoxes"};
    }

    if ($#openBoxes == -1) { # if all the boxes are closed, we win with 100%
	return 1;
    }
    
    my $result = napsack($rolled, @openBoxes); # compute all the possible 
    if ($result == -1) { # if there are no boxes that add up to the roll, we've lost
	return 0;
    }

    my $oneDie = 1; # figure out if rolling a single dice is allowed
    for (@openBoxes) {
	$oneDie = 0 if ($_ > 6);
    }

    # keep track of the best choice we can make at this juncture
    my $bestProb = 0;
    my $bestBoxes = [];
    for my $boxes (@{$result}) { # for each possible combo of boxes to shut
	# find the one that maximizes win %
	
	# compute the remaining open boxes that we would be recursing on
	my @remainingOpenBoxes = subtractArray($boxes, @openBoxes);

	# if we're allowed to roll one dice, see what the win% is for that
	my $oneSum = 0;
	if ($oneDie) {
	    for my $i (1..6) {
		$oneSum += (solver ($i, @remainingOpenBoxes)/6);
	    }
	}

	# we're always allowed to roll 2 dice
	my $twoSum = 0;
	for my $i (2..12) {
	    $twoSum += (solver ($i, @remainingOpenBoxes)*$twoDiceProbs[$i]);
	}

	if ($oneSum > $twoSum) {
	    if ($oneSum > $bestProb) {
		$bestProb = $oneSum;
		$bestBoxes = $boxes;
	    }
	} else {
	    if ($twoSum > $bestProb) {
		$bestProb = $twoSum;
		$bestBoxes = $boxes;
	    }
	}
	
    } # for each possible combo of boxes to shut
    print "Rolled: $rolled\tBoxesLeft: '@openBoxes'\tBoxesClosed: '@{$bestBoxes}'\tProb: $bestProb\n" if ($#{$bestBoxes}+1);
    $memoization{"$rolled\t@openBoxes"} = $bestProb;
    return $bestProb;
}


sub subtractArray {
    my $subtractors = shift;
    my @openBoxes = @_;
    my @results;
    for my $toGo (@openBoxes) {
	my $flag = 1;
	for my $gone (@{$subtractors}) {
	    if ($toGo == $gone) {
		$flag = 0;
	    }
	}
	if ($flag) {
	    push @results, $toGo;
	}
    }
    return @results;
}

# returns -1 if there are no valid combinations
# returns a reference to a list of lists, where the inner lists are solutions
sub napsack {
#    print "@_\n";
    my $remaining = shift;
    my @items = @_;
    my $valid = [];

    if ($remaining == 0) {
	return [$valid];
    }

    for my $i (0..$#items) { # for each possible item
	if (($remaining - $items[$i]) >= 0) { # check if it fits
	    $result = napsack($remaining - $items[$i], @items[0..$i-1,$i+1..$#items]); # check if there's a valid combo after putting this in
	    unless ($result == -1) { # if there is, add it to all results
		for (@{$result}) { # for each list in our LoL
#		    print "'@{$_}'\n";
		    push @{$_}, $items[$i];
		    push @{$valid}, $_;
		}
	    }
	}
    }

    return myUniq($valid);
}

sub myUniq {
    my $ref = shift;
#    for (@{$ref}) {
#	print "@{$_}\n";
#    }
    my $safe = [];
    for my $lst (@{$ref}) {
	my @hold = sort @{$lst};
	my $flag = 1;
	for (@{$safe}) {
	    if (same(\@hold, $_)) {
		$flag = 0;
		last;
	    }
	}
	push @{$safe}, \@hold if ($flag);	    
    }
    return $safe;
}

sub same {
    $lst1 = shift;
    $lst2 = shift;
#    print "Called '@{$lst1}'\t'@{$lst2}'\n";
    for (0..$#{$lst1}) {
	if (${$lst1}[$_] != ${$lst2}[$_]) {
	    return 0;
	}
    }
    return 1;
}

#$hold = napsack(12, 1..9);
#$hold2 = myUniq($hold);
#for (@{$hold}) {
#    print "'@{$_}'\n";
#}

my $sum = 0;
for my $i (2..12) {
    $sum += solver($i, 1..9) * $twoDiceProbs[$i];
}

# Smaller, more intuitive test (sanity check)
#for my $i (1..6) {
#    $sum += solver($i,1..3) / 6;
#}

print "$sum\n";
