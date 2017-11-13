#!/bin/bash
set -e

VERSION=$1

echo "Version: ${VERSION}"

wget "http://ftp.ncbi.nlm.nih.gov/refseq/release/release-catalog/archive/RefSeq-release${VERSION}.catalog.gz"

exit 0;
