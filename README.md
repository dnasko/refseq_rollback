# RefSeq Rollback

A collection of scripts to create historical RefSeq versions.

### Downloading the necessary files

The two files you'll need to rollback to a desired RefSeq version are:

1. The current bacterial RefSeq FASTA file
2. The catalog file associated with the version you want to rollback to.

Two scripts are provided to help you download these files:

```bash
./download_latest_bacterial_refseq.sh

./download_refseq_catalog.sh 80
```

[download_latest_bacterial_refseq.sh](./scripts/download_latest_bacterial_refseq.sh) will create a directory and download the latest bacterial RefSeq FASTA files, concatenate them and delete the pieces. [download_refseq_catalog.sh](./scripts/download_refseq_catalog.sh) will download the catalog file you want to rollback to, in the example we chose 80, though any version can be selected.

### Rolling back to a desired RefSeq version

If you want to use these files to roll back to version 80, you would do the following:

```bash
./refseq_rollback.pl -catalog RefSeq-release80.catalog.gz \
		     -fasta RefSeq-release88.fasta.gz \
		     -out RefSeq-release80.fasta
```

### Diversity calculations

In the MetaDB manuscript we present diversity metrics for bacterial RefSeq over time. The script used to create the OTU table in the analysis is [create_otu_table.pl](./scripts/create_otu_table.pl).

*Rev DJN 10Jul2018*
