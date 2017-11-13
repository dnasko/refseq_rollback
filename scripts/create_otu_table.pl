#!/usr/bin/perl
use strict;
use warnings;

if (scalar(@ARGV) < 1) {
    die "\n Usaage: ./create_otu_table.pl /Path/to/catalog_files/*.gz > output_otu_table.txt\n\n";
}

my @Versions;
my %Hash;

foreach my $infile (@ARGV) {
    my $version = $infile;
    $version =~ s/.*RefSeq-release//;
    $version =~ s/\.catalog\.gz//;
    push(@Versions, $version);
    print STDERR " $version started ... ";
    open(IN,"gunzip -c $infile|") || die "\n Cannot open the file: $infile\n";
    while(<IN>) {
	chomp;
	my @a = split(/\t/, $_);
	$Hash{$a[0]}{$version}++;
    }
    close(IN);
    print STDERR " [DONE]\n";
}

my $otu=1;
print STDOUT "Org" . "\t" . "OTU" . "\t" . join("\t", @Versions) . "\n";
foreach my $i (sort keys %Hash) {
    my $l = $i;
    print STDOUT $i . "\t" . "OTU_" . $otu;
    $otu++;
    foreach my $j (@Versions) {
	if (exists $Hash{$i}{$j}) { print STDOUT "\t" . $Hash{$i}{$j}; }
	else { print STDOUT "\t" . "0"; }
    }
    print STDOUT "\n";
}


exit 0;
