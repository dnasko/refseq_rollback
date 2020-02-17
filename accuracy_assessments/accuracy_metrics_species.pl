#!/usr/bin/perl -w
use strict;

my $nodes_file = $ARGV[0];
my $names_file = $ARGV[1];
my $labels_file = $ARGV[2];
my $divide_by = 10000;

## Hash of valid species names. Need this because
##  you can't get this from the *.labels Kraken files
my %Nodes;
my %Species;

open(IN,"<$nodes_file") || die "\n Cannot open the file: $nodes_file\n";
while(<IN>) {
    chomp;
    my @a = split(/\t/, $_);
    my $id = $a[0];
    my $rank = $a[4];
    if ($rank eq "species") {
	$Nodes{$id} = 1;
    }
}
close(IN);

open(IN,"<$names_file") || die "\n Cannot open the file: $names_file\n";
while(<IN>) {
    chomp;
    my @a = split(/\t/, $_);
    my $id = $a[0];
    my $name = $a[2];
    my $type = $a[6];
    if ($type eq "scientific name") {
	if (exists $Nodes{$id}) {
	    $Species{$name} = $id;
	}
    }
}
close(IN);

## Great, now to process the labels file...
## Hash with labels and knowns from our dataset
my %Truth;
my %Valid;
populate_hash();
my %Counts;

my ($tp,$misclass,$notclass,$unclass) = (0,0,0,0);

open(IN,"<$labels_file") || die "\n Cannot open the file: $labels_file\n";
while(<IN>) {
    chomp;
    my @a = split(/\t/, $_);
    my $bug = parse_bug($a[0]);
    my $species = get_species($a[1]);
    # print join("\t", $bug, $species) . "\n";;
    if ($Truth{$bug} eq $species) {
    	$tp++;
    }
    elsif ($species eq "unclassified") {
	$notclass++;
    }
    else {
    	$misclass++;
    }
}
close(IN);

$unclass = 10000 - ($tp + $misclass + $notclass);

$tp /= $divide_by;
$misclass /= $divide_by;
$notclass /= $divide_by;
$unclass  /= $divide_by;

print join("\t", 'tp', 'misclass', 'notclass', 'unclass') . "\n";
print join("\t", $tp, $misclass, $notclass, $unclass) . "\n";

exit 0;

sub parse_bug
{
    my $s = $_[0];
    $s =~ s/_HiSeq.*//;
    return $s;
}

sub get_species
{
    my ($species) = ("unclassified");
    my @t = split(/;/, $_[0]);
    foreach my $i (@t) {
	if (exists $Species{$i}) {
	    $species = $i;
	}
    }
    return ($species);
}

sub populate_hash
{
    $Truth{"A_hydrophila"} = "Aeromonas hydrophila";
    $Truth{"B_cereus"}     = "Bacillus cereus";
    $Truth{"B_fragilis"}   = "Bacteroides fragilis";
    $Truth{"M_abscessus"}  = "Mycobacterium abscessus";
    $Truth{"P_fermentans"} = "Pelosinus fermentans";
    $Truth{"R_sphaeroides"} = "Rhodobacter sphaeroides";
    $Truth{"S_aureus"}     = "Staphylococcus aureus";
    $Truth{"S_pneumoniae"} = "Streptococcus pneumoniae";
    $Truth{"V_cholerae"}   = "Vibrio cholerae";
    $Truth{"X_axonopodis"} = "Xanthomonas axonopodis";
}
