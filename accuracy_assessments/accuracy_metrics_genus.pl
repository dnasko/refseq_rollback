#!/usr/bin/perl -w
use strict;

my $nodes_file = $ARGV[0];
my $names_file = $ARGV[1];
my $labels_file = $ARGV[2];
my $divide_by = 10000;

## Hash of valid genus names. Need this because
##  you can't get this from the *.labels Kraken files
my %Nodes;
my %Genus;

open(IN,"<$nodes_file") || die "\n Cannot open the file: $nodes_file\n";
while(<IN>) {
    chomp;
    my @a = split(/\t/, $_);
    my $id = $a[0];
    my $rank = $a[4];
    if ($rank eq "genus") {
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
	    $Genus{$name} = $id;
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
    my $genus = get_genus($a[1]);
    # print join("\t", $bug, $genus) . "\n";;
    if ($Truth{$bug} eq $genus) {
    	$tp++;
    }
    elsif ($genus eq "unclassified") {
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
$unclass  /= $divide_by;
$notclass /= $divide_by;

print join("\t", $tp, $misclass, $notclass, $unclass) . "\n";

exit 0;

sub parse_bug
{
    my $s = $_[0];
    $s =~ s/_HiSeq.*//;
    return $s;
}

sub get_genus
{
    my ($genus) = ("unclassified");
    my @t = split(/;/, $_[0]);
    foreach my $i (@t) {
	if (exists $Genus{$i}) {
	    $genus = $i;
	}
    }
    return ($genus);
}

sub populate_hash
{
    $Truth{"A_hydrophila"} = "Aeromonas";
    $Truth{"B_cereus"}     = "Bacillus";
    $Truth{"B_fragilis"}   = "Bacteroides";
    $Truth{"M_abscessus"}  = "Mycobacterium";
    $Truth{"P_fermentans"} = "Pelosinus";
    $Truth{"R_sphaeroides"} = "Rhodobacter";
    $Truth{"S_aureus"}     = "Staphylococcus";
    $Truth{"S_pneumoniae"} = "Streptococcus";
    $Truth{"V_cholerae"}   = "Vibrio";
    $Truth{"X_axonopodis"} = "Xanthomonas";

    $Valid{"Aeromonas hydrophila"} = 1;
    $Valid{"Bacillus cereus"} = 1;
    $Valid{"Bacteroides fragilis"} = 1;
    $Valid{"Mycobacterium abscessus"} = 1;
    $Valid{"Pelosinus fermentans"} = 1;
    $Valid{"Rhodobacter sphaeroides"} = 1;
    $Valid{"Staphylococcus aureus"} = 1;
    $Valid{"Streptococcus pneumoniae"} = 1;
    $Valid{"Vibrio cholerae"} = 1;
    $Valid{"Xanthomonas axonopodis"} = 1;
}
