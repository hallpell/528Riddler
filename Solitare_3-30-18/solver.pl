#!/usr/bin/perl

sub solver {
#    print "Called: @_\n";
    my $card = shift;
    my $deck = shift;
    my @ourCards = @_;
    my $sum = 0;

    #[0-11] = 2-K (alternating colors)
    #[12-23] = 2-K (other alternating colors)

    if ($card >= 7) { # we've drawn all the flop, now just compute the 8 cards from the deck
	if ($card > 7) {
	    print "What's happening? $card, $deck, @_\n";

	}
	return $justDeck[$deck];
    }

    if ($card >= 7) {
	print "Return is weird\n";
    }
    
    for my $i (0,12) { # for each 2
	if ($ourCards[$i]) { # if there are 2s to grab
#	    print "In $i\n" if ($card == 0);
	    @holder = @ourCards; 
	    $holder[$i+1] = 0; # we can't draw 3s in the future
	    $thisNum = $holder[$i]--; # and we can't redraw this 2
	    $sum += $thisNum * solver($card+1, $deck-1, @holder); # and recurse
	}
    }

    for my $i (11,23) { # for each K
	if ($ourCards[$i]) { # if there are Ks to grab
#	    print "In $i\n" if ($card == 0);
	    @holder = @ourCards;
	    $hold = $holder[$i-1];
	    $holder[$i-1] = 0; # we can't draw Qs in the future
	    $thisNum = $holder[$i]--; # and we can't redraw this K
	    $sum += $thisNum * solver($card+1, $deck-$hold-1, @holder); # and recurse
	}
    }

    for my $i (1..10, 13..22) {
	if ($ourCards[$i]) { # if there are some of this to grab
#	    print "In $i: $card, $deck, @ourCards\n"  if ($card == 0);
	    @holder = @ourCards;
	    $hold = $holder[$i-1]; # keep track of how many more cards can't be drawn by the deck
	    $holder[$i-1] = 0; # we can't draw either the above or below card in the future
	    $holder[$i+1] = 0;
	    $thisNum = $holder[$i]--; # we can't redraw this card
	    $sum += $thisNum * solver($card+1, $deck-$hold-1, @holder);
	}
    }
    return $sum;
}

for (my $j = 0; $j < 52; $j++) {
    my $num = $j;
    my $prod = 1;
    for (my $i = 0; $i <= 7; $i++) {
	$prod = $prod * $num;
	$num--;
    }
    $justDeck[$j] = $prod;
}

#$stuff = solver(6, 36, 0,0,0,0,2,2,2,2,2,2,2,2,0,0,2,2,2,2,2,2,2,2,2,2);
$stuff = solver(0, 48, 2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2);
#print "@justDeck\n";
print "$stuff games with no moves.\n";

$newProd = 1;
for my $i (38..52) {
    $newProd *= $i;
}

print "$newProd arrangements of 15/52 cards.\n";
$odds = $stuff/$newProd;
print "Odds of nightmare game: $odds\n";
