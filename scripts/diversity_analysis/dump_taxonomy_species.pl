#!/usr/bin/perl -w
use strict;

## Convert a version of RefSeq into an OTU table
## Usage:
## ./dump_taxonomy_species.pl ./taxonomy/names.txt ./taxonomy/nodes.dmp ./catalogs/RefSeq-release1.catalog.gz > release_1.tax

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
    if ($a[4] =~ m/microbial/ || $a[4] =~ m/bacteria/ || $a[3] =~ m/bacteria/) {
	my $species = get_species($a[0]);
	print $species . "\n";
    }
}
close(IN);

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
