# Getting started with Qiime2


## First step: importing your data


```
qiime tools import --help
```

```
qiime tools import --show-importable-types
```

```
qiime tools import \
  --type MultiplexedSingleEndBarcodeInSequence \
  --input-path {SEQUENCES}.fastq.gz \
  --output-path {SEQUENCES}.qza
```

In cases where you have to demultiplex the sequences separately beforehand (e.g. dual-index barcoded sequences), Qiime can import demultiplexed fastq sequences. To run this see [**importing_options**](). For other importing options, see the [***Qiime2 importing data tutorial***](https://docs.qiime2.org/2019.10/tutorials/importing/).

## Demultiplexing with cutadapt

We will now demultiplex the sequences (sort them by sample)

```
qiime cutadapt demux-single \
 --i-seqs {SEQUENCES}.qza \
 --m-barcodes-file sample_metadata.tsv \
 --m-barcodes-column barcode_sequence \
 --p-minimum-length 120 \
 --o-per-sample-sequences {DEMUX_SEQS}.qza \
 --o-untrimmed-sequences {UNMATCHED_SEQS}.qza
```

Note that the output is a single file; it has not been split into multiple sample sequence qiime artifacts. Because the Qiime artifact is essentially a zipped folder, it can hold multiple files. We can export this from the Qiime format to see how it looks. 

First make a folder to put the files

```
mkdir demux_files
```

Now export the artifact:

```
qiime tools export --input-path {DEMUX_SEQS}.qza --output-path demux_files
```


Qiime has a function to summarise the demultiplexed sequences. 

```
qiime demux summarize \
  --i-data {DEMUX_SEQS}.qza \
  --o-visualization {DEMUX_SEQS-VIZ}.qzv
```

For viewing Qiime visualisation artifacts (.qzv), you use the qiime view tool:

```
qiime tools view {DEMUX_SEQS-VIZ}.qzv
```

You can also use the [**Qiime View**](https://view.qiime2.org/) webpage to open any visualisation.  














