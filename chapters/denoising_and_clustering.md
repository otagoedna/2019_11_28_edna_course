# Denoising and clustering

Now that the initial sequences are processed, we will create representative sequences from them, where each sequence will represent multiple replicates and similar sequences. The [**Qiime2 overview**](https://docs.qiime2.org/2019.10/tutorials/overview/#denoising-and-clustering) tutorial has a good description of the two main processes, which will try here. 

## Denoising

```
qiime dada2 denoise-single \
  --i-demultiplexed-seqs {DEMUX_SEQS}.qza \
  --p-trim-left 0 \
  --p-trunc-len 120 \
  --o-representative-sequences {REP-SEQS}.qza \
  --o-table {FREQ-TABLE}.qza \
  --o-denoising-stats {DENOISING-STATS}.qza
```

<br>

```
qiime metadata tabulate \
  --m-input-file {DENOISING-STATS}.qza \
  --o-visualization {DENOISING-STATS_VIZ}.qza
```

<br>

```
qiime feature-table summarize \
  --i-table {FREQ-TABLE}.qza \
  --o-visualization {FREQ-TABLE_VIZ}.qzv \
  --m-sample-metadata-file sample_metadata.tsv
```

<br>

```
qiime feature-table tabulate-seqs \
  --i-data {REP-SEQS}.qza \
  --o-visualization {REP-SEQS_VIZ}.qzv
```

<br><br>

## Clustering with vsearch

Qiime2 provides a [**vsearch clustering tutorial**](https://docs.qiime2.org/2019.10/tutorials/otu-clustering/), an example from which we are doing here.

To cluster with vsearch first, dereplicate the sequences

```
qiime vsearch dereplicate-sequences \
  --i-sequences {DEMUX_SEQS}.qza \
  --o-dereplicated-table {FREQ-TABLE-DEREP}.qza \
  --o-dereplicated-sequences {DEREP-SEQS}.qza
```

```
qiime vsearch cluster-features-de-novo \
  --i-table {FREQ-TABLE-DEREP}.qza \
  --i-sequences {DEREP-SEQS}.qza \
  --p-perc-identity 0.99 \
  --o-clustered-table {FREQ-TABLE}.qza \
  --o-clustered-sequences {REP-SEQS}.qza
```

tabulate and summarise

```
qiime feature-table summarize \
  --i-table {FREQ-TABLE}.qza \
  --o-visualization {TABLE-SUMMARIZE-VIZ}.qzv \
  --m-sample-metadata-file sample_metadata.tsv
```

```
time qiime feature-table tabulate-seqs \
  --i-data {REP-SEQS}.qza \
  --o-visualization {REP-SEQS_VIZ}.qzv
```


```
qiime tools view {TABLE-SUMMARIZE-VIZ}.qzv
```

```
qiime tools view {REP-SEQS_VIZ}.qzv
```

questions: what kind of differences do you observe between the two 



