#!/usr/bin/perl -w
use strict;

my $names_file = $ARGV[0];
my $nodes_file = $ARGV[1];
my $infile = $ARGV[2];

my %Count;
my $max_org;
my $max_count = 0;
my $total = 0;

my %Names;
my %Parent; ## $Parent{$child} = $parent;
my %Type;   ## $Type{123} = 'species';

open(IN,"<$names_file") || die "\n Cannot open the file: $names_file\n";
while(<IN>) {
    chomp;
    my @a = split(/\t/, $_);
    $Names{$a[0]} = $a[1];
}
close(IN);

open(IN,"<$nodes_file") || die "\n Cannot open the file: $nodes_file\n";
while(<IN>) {
    chomp;
    my @a = split(/\t/, $_);
    my $child  = $a[0];
    my $parent = $a[2];
    my $type   = $a[4];
    $Parent{$child} = $parent;
    $Type{$child} = $type;
}
close(IN);

open(IN,"gunzip -c $infile|") || die "\n Cannot open the file: $infile\n";
while(<IN>) {
    chomp;
    my @a = split(/\t/, $_);
    if ($a[4] =~ m/microbial/ || $a[4] =~ m/bacteria/) {
	my $species = get_species($a[0]);
	$Count{$species}++;
	$total++;
    }
}
close(IN);


foreach my $species (keys %Count) {
    if ($max_count < $Count{$species}) {
	$max_count = $Count{$species};
	$max_org = $species;
    }
}

my $frac = $max_count / $total;
print $max_org . "\t" . $frac . "\n";

exit 0;

sub get_species
{
    my $s = $_[0];
    my $species = "none";
    if (exists $Type{$s}) {
	my $type = $Type{$s};
	while($type ne "species" && $type ne 'genus' && $type ne 'family' && $type ne 'order'  && $type ne 'class'  && $type ne 'phylum'  && $type ne 'kingdom'  && $type ne 'superkingdom' ) {
	    $s = $Parent{$s};
	    $type = $Type{$s};
	}
	$species = $Names{$s};
    }
    return $species;
}
