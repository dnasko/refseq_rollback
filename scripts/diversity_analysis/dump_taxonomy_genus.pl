#!/usr/bin/perl -w
use strict;

## Usage: ./dump_taxonomy_genus.pl /Path/to/names.dmp /Path/to/nodes.dmp /Path/to/RefSeq_catalog_version.txt.gz > RefSeq_version.dump

## Will dump *genus* names for each RefSeq sequence in the catalog file.
## Does so by using the NCBI taxonomy names.dmp and nodes.dmp files to 
## build the taxonomic tree in memory and report just genus

my $names_file = $ARGV[0];
my $nodes_file = $ARGV[1];
my $infile = $ARGV[2];

my %Count;
my $max_org;
my $max_count = 0;
my $total = 0;

my %Names;  ## $Names{$taxid} = $scientific_name;
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
	my $genus = get_genus($a[0]);
	print $genus . "\n";
    }
}
close(IN);

exit 0;

sub get_genus
{
    my $s = $_[0]; ## NCBI taxonomy ID
    my $species = "none"; ## set this to none by default. Rarely, but sometimes, a TaxID will not be in the taxonomy files.
    if (exists $Type{$s}) {
	my $type = $Type{$s};
	while($type ne 'genus' && $type ne 'family' && $type ne 'order'  && $type ne 'class'  && $type ne 'phylum'  && $type ne 'kingdom'  && $type ne 'superkingdom' ) { ## while the type is something *below* genus...
	    $s = $Parent{$s};
	    $type = $Type{$s};
	}
	$species = $Names{$s};
    }
    return $species;
}
