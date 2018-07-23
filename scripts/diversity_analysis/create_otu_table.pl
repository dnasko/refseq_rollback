#!/usr/bin/perl
use strict;
use warnings;

## Creat a QIIME-Style OTU table from a set of RefSeq Catalog files
## that have had the taxonomic info dumped already from dump_taxonomy.pl.
## Pass in as many as you want. Each dumped catalog file is treated like a
## sample in the OTU table.

## Depending on the dump_taxonomy.pl script you used (e.g. dump_taxonomy_species.pl,
## dump_taxonomy_genus.pl) will dictate at what level you're measuring
## diversity.

if (scalar(@ARGV) < 1) {
    die "\n Usaage: ./create_otu_table.pl /Path/to/catalog_files/*.gz > output_otu_table.txt\n\n";
}

my @Versions;
my %Hash;

foreach my $infile (@ARGV) { ## for each file passed to the script...
    my $version = $infile;   ## get the version number
    $version =~ s/.*\///;
    $version =~ s/\.tax//;
    push(@Versions, $version); ## add that version to the array
    print STDERR " $version started ... "; ## report what version you're working on

    open(IN,"<$infile") || die "\n Cannot open the file: $infile\n";
    while(<IN>) {
	chomp;
	$Hash{$_}{$version}++; ## Each line is a species parsed by the dump_taxonomy.pl script
    }
    close(IN);
    print STDERR " [DONE]\n";
}

## Begin printing out the results...
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
