# RefSeq Rollback

A collection of scripts to create historical RefSeq versions.

### Downloading the necessary files

The two files you'll need to rollback to a desired RefSeq version are:

1. The current bacterial RefSeq FASTA file
2. The catalog file associated with the version you want to rollback to.

Two scripts are provided to help you downoad these files:

```bash
download_latest_bacterial_refseq.sh

download_refseq_catalog.sh XX
```

[download_latest_bacterial_refseq.sh](./scripts/download_latest_bacterial_refseq.sh) will create a directory and download the latest bacterial RefSeq FASTA files, concatenate them and delete the pieces. [download_refseq_catalog.sh](./scripts/download_refseq_catalog.sh) will download the catalog file you want to rollback to, just provide the version number where the XX is.

### Rolling back to a desired RefSeq version

Instructions to come...

### Diversity calculations

In the MetaDB manuscript we present diversity metrics for bacterial RefSeq over time. The script used to create the OTU table in the analysis is [create_otu_table.pl](./scripts/create_otu_table.pl).

*Rev DJN 13Nov2017*
