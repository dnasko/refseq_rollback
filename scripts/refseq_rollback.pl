#!/usr/bin/perl

# MANUAL FOR refseq_rollback.pl

=pod

=head1 NAME

refseq_rollback.pl -- produce a version of refseq you want

=head1 SYNOPSIS

 refseq_rollback.pl --catalog=/Path/to/RefSeq-release10.catalog.gz --fasta=/Path/to/latest_refseq.fasta --out=/Path/to/output.fasta
                     [--help] [--manual]

=head1 DESCRIPTION

 Using the most recent version of RefSeq this script will pull out sequences
 that are in a version of RefSeq you want using the appropriate catalog file.
 
=head1 OPTIONS

=over 3

=item B<-c, --catalog>=FILENAME

Input RefSeq catalog file. (Required) 

=item B<-f, --fasta>=FILENAME

Input current release of RefSeq in FASTA format. (Required) 

=item B<-o, --out>=FILENAME

Output file in FASTA format. (Required) 

=item B<-h, --help>

Displays the usage message.  (Optional) 

=item B<-m, --manual>

Displays full manual.  (Optional) 

=back

=head1 DEPENDENCIES

Requires the following Perl libraries.



=head1 AUTHOR

Written by Daniel Nasko, 
Center for Bioinformatics and Computational Biology, University of Maryland.

=head1 REPORTING BUGS

Report bugs to dnasko@umiacs.umd.edu

=head1 COPYRIGHT

Copyright 2017 Daniel Nasko.  
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>.  
This is free software: you are free to change and redistribute it.  
There is NO WARRANTY, to the extent permitted by law.  

=cut


use strict;
use warnings;
use Getopt::Long;
use File::Basename;
use Pod::Usage;

#ARGUMENTS WITH NO DEFAULT
my($catalog,$refseq,$outfile,$help,$manual);

GetOptions (	
				"c|catalog=s"	=>	\$catalog,
				"r|refseq=s"    =>      \$refseq,
                                "o|out=s"	=>	\$outfile,
				"h|help"	=>	\$help,
				"m|manual"	=>	\$manual);

# VALIDATE ARGS
pod2usage(-verbose => 2)  if ($manual);
pod2usage( {-exitval => 0, -verbose => 2, -output => \*STDERR} )  if ($help);
pod2usage( -msg  => "\n\n ERROR!  Required argument --refseq not found.\n\n", -exitval => 2, -verbose => 1)  if (! $refseq );
pod2usage( -msg  => "\n\n ERROR!  Required argument --catalog not found.\n\n", -exitval => 2, -verbose => 1)  if (! $catalog );
pod2usage( -msg  => "\n\n ERROR!  Required argument --out not found.\n\n", -exitval => 2, -verbose => 1)  if (! $outfile );

if ($catalog =~ m/\.gz$/) { ## if a gzip compressed infile
    open(IN,"gunzip -c $catalog |") || die "\n\n Cannot open the catalog file: $catalog\n\n";
}
else { ## If not gzip comgressed
    open(IN,"<$catalog") || die "\n\n Cannot open the catalog file: $catalog\n\n";
}
while(<IN>) {
    # $_ =~ s/\r[\n]*/\n/gm;  ## takes care of weird return carriages
    chomp;
    
}
close(IN);

exit 0;
