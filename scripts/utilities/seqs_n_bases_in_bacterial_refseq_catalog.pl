#!/usr/bin/perl
use strict;

my $infile = $ARGV[0];

my ($seqs,$bases) = (0,0); ## initialize seq and base count, set to 0

open(IN,"gunzip -c $infile|") || die "\n Cannot open the file: $infile\n";
while(<IN>) {
    my @a = split(/\t/, $_);
    if ($a[4] =~ m/microbial/ || $a[4] =~ m/bacteria/ || $a[3] =~ m/bacteria/) { ## Just want *bacterial* RefSeq. At various versions they use 'microbial' or 'bacteria', and they switch fields too.
	$bases += $a[-1]; ## the size of each sequence is the last field of each line
	$seqs++;
    }
}
close(IN);

print join("\t", $seqs,$bases) . "\n";

exit 0;
