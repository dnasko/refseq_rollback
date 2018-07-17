#!/usr/bin/perl
use strict;
use warnings;

## Usage: ./pick_random_reads.pl /Path/to/input.fastq.gz > output.fastq

my $fastq = $ARGV[0];
my $total_reads = 26347788; ## You need to update this by hand. Sets upper-limit for random number generation
my $samples = 10000; ## Number of reads you want to pick out of the file
my $count=1;
my $l=0;
my $print_flag = 0;

my %Numbers; ## Dictionary of the random numbers

## Pick $samples random numbers
while(keys %Numbers < $samples) { ## while the dictionary isn't full
    my $random = int(rand($total_reads)) + 1;
    $Numbers{$random} = 1;
}

open(IN,"gunzip -c $fastq|") || die "\n Cannot open: $fastq\n"; ## Open up the GZIP'd FASTQ file
while(<IN>) {
    chomp;
    if ($l==0) {
	$print_flag = 0; ## Turn this flag off everytime we hit a header line
	$l=-4;
	if (exists $Numbers{$count}) { ## If this sequence is one of the random ones
	    print $_ . "\n";           ## print it and the next 3 lines
	    $print_flag = 1;
	}
	$count++;
    }
    elsif ( $print_flag == 1 ) {
	print $_ . "\n";
    }
    $l++;    
}
close(IN);

exit 0;
