#!/usr/bin/perl

@daysInMonth = qw(31 28 31 30 31 30 31 31 30 31 30 31);

my $attacks = 0;

for my $year (1..99) {
    my $yearlyAttacks = 0;
    for my $month (1..12) {
	for my $day (1..$daysInMonth[$month-1]) {
	    if ($month * $day == $year) {
		$yearlyAttacks++;
		if ($year == 84) {
		    print "$month\t$day\n";
		}
	    }
	}
	if ($year % 4 == 0) {
	    $yearlyAttacks++ if (2 * 29 == $year);
	}
	# if leap year
    }
    $attacks += $yearlyAttacks;
    push @attacks, $yearlyAttacks;
}

for my $i (1..99) {
    $year = 2000+$i;
    $hold = $attacks[$i-1];
    print "$year: $hold\n";
}

print "$attacks\n";
