#!/usr/bin/perl

my %teams, %loser2winners;

while (<>) { # for each line
    chomp;
    s/@//; # we don't care about home vs away
    if (/^\d{4}-\d{2}-\d{2}\s+(.*?)\s+(\d+)\s+(.*?)\s+(\d+)/) {
	$team1 = $1;
	$score1 = $2;
	$team2 = $3;
	$score2 = $4;
    } else {
	print STDERR "Didn't match pattern in $_\n";
    }
    $teams{$team1} = 1; # add both teams to our roster
    $teams{$team2} = 1;
    if ($score1 > $score2) { # find loser and record who beat them
	$loser2winners{$team2} .= "$team1\t";
    } elsif ($score1 < $score2) {
	$loser2winners{$team1} .= "$team2\t";
    } elsif ($score1 == $score2) {
	print STDERR "Tie at $_\n";
    }
}

$winners{"Villanova"} = 1;
$count = 2;

while (1) {
    $size = scalar keys %winners;
    for $team (sort keys %winners) {
	for $transitive (split /\t/, $loser2winners{$team}) {
	    $winners{$transitive} = 1;
	}
    }

    print ("After $count iterations, there are " . (scalar keys %winners) . " transitive champions\n");
    $count++;
#    print "$_\t" for (sort keys %winners);
#    print "\n";
    last if ($size == scalar keys %winners);
}

for (sort keys %teams) {
    print "$_\n" unless (exists $winners{$_});
}

print (scalar keys %teams);
