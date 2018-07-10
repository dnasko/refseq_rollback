#!/bin/sh
set -e

## Download the latest RefSeq Bacteria release and cat it into
## one common file.

DATE="$(date +%F)" ## Get the date
mkdir "bacterial_refseq_${DATE}" ## Create a directory with the date
cd "bacterial_refseq_${DATE}"

## RefSeq releases are saved in a FTP directory in many files.
## This bit of code fins out how many files there are in this release
wget -o wget.log "https://ftp.ncbi.nlm.nih.gov/refseq/release/bacteria/"
MAX="$(grep ".genomic.gbff.gz" index.html | sed 's/.genomic.gbff.gz.*//' | sed 's/.*bacteria.//' | sort -nr | head -n1)"

## Download all of the FASTA files from 1 to the "MAX" (a.k.a. last) FASTA file
for i in $(seq "$MAX"); do
    wget -o wget.log "http://ftp.ncbi.nlm.nih.gov/refseq/release/bacteria/bacteria.${i}.1.genomic.fna.gz"
    zcat bacteria.${i}.1.genomic.fna.gz >> bacterial_refseq_${DATE}.fna
    rm bacteria.${i}.1.genomic.fna.gz
done;

exit 0;
