#!/bin/sh
set -e

DATE="$(date +%F)"
mkdir "bacterial_refseq_${DATE}"
cd "bacterial_refseq_${DATE}"

wget -o wget.log "https://ftp.ncbi.nlm.nih.gov/refseq/release/bacteria/"
MAX="$(grep ".genomic.gbff.gz" index.html | sed 's/.genomic.gbff.gz.*//' | sed 's/.*bacteria.//' | sort -nr | head -n1)"

for i in $(seq "$MAX"); do
    wget -o wget.log "http://ftp.ncbi.nlm.nih.gov/refseq/release/bacteria/bacteria.${i}.1.genomic.fna.gz"
    zcat bacteria.${i}.1.genomic.fna.gz >> bacterial_refseq_${DATE}.fna
    rm bacteria.${i}.1.genomic.fna.gz
done;

exit 0;
