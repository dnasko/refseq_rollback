#!/bin/bash
set -e

## A small BASH script to run Bracken
## Usage: ./run_bracken.sh ##
## Where ## is a ref


RELEASE=$1
cd ${RELEASE}

time kraken --db=${RELEASE} --fasta-input --threads=30 /cbcbhomes/dnasko/projects/metadb/kraken_db/${RELEASE}/library/RefSeq-${RELEASE}.bacteria.fna  > database.kraken

time perl ~/software/Bracken/count-kmer-abundances.pl --threads=30 --db=/cbcbhomes/dnasko/projects/metadb/kraken_db/${RELEASE} --read-length=100 database.kraken  > database100mers.kraken_cnts

time python ~/software/Bracken/generate_kmer_distribution.py -i database100mers.kraken_cnts -o KMER_DISTR.TXT

time python ~/software/Bracken/est_abundance.py -i ${RELEASE}.report -k KMER_DISTR.TXT -l 'S' -t 10 -o output_file.txt

cd ../

exit 0
