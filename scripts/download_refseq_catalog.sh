#!/bin/bash
set -e

## Usage: ./download_refseq_catalog.sh 1
## Where '1' can be any number corresponding to a version of RefSeq (1..88).

VERSION=$1

echo "Version: ${VERSION}"

wget "http://ftp.ncbi.nlm.nih.gov/refseq/release/release-catalog/archive/RefSeq-release${VERSION}.catalog.gz"

exit 0;
