# Denoising and clustering

## Denoising

```
qiime dada2 denoise-single \
  --i-demultiplexed-seqs demux01.qza \
  --p-trim-left 0 \
  --p-trunc-len 120 \
  --o-representative-sequences rep-seqs01-dada2.qza \
  --o-table table01-dada2.qza \
  --o-denoising-stats stats01-dada2.qza
```

```
qiime metadata tabulate \
  --m-input-file stats01-dada2.qza \
  --o-visualization stats01-dada2.qzv
```

```
qiime feature-table summarize \
  --i-table table01-dada2.qza \
  --o-visualization table01.qzv \
  --m-sample-metadata-file sample_metadata.tsv
```

```
qiime feature-table tabulate-seqs \
  --i-data rep-seqs01-dada2.qza \
  --o-visualization rep-seqs01-dada2_VZ.qzv
```

## Clustering with vsearch

First, dereplicate the sequences

```
qiime vsearch dereplicate-sequences \
  --i-sequences mp_sub50k_demux.qza \
  --o-dereplicated-table mp_sub50k_VStable.qza \
  --o-dereplicated-sequences mp_sub50k_VSrep-seqs.qza
```

```
qiime vsearch cluster-features-de-novo \
  --i-table mp_sub50k_VStable.qza \
  --i-sequences mp_sub50k_VSrep-seqs.qza \
  --p-perc-identity 0.99 \
  --o-clustered-table mp_sub50k_VStable-dn-99.qza \
  --o-clustered-sequences mp_sub50k_VSrep-seqs-dn-99.qza
```

tabulate and summarise

```
time qiime feature-table tabulate-seqs \
  --i-data mp_sub50k_VSrep-seqs-dn-99.qza \
  --o-visualization mp_sub50k_VSrep-seqs-dn-99_Viz.qzv
```

```
qiime feature-table summarize \
  --i-table mp_sub50k_VStable-dn-99.qza \
  --o-visualization mp_sub50k_VStable-dn-99_Viz.qzv \
  --m-sample-metadata-file ../sample_metadata.tsv
```

```
qiime tools view table.qzv
```

```
qiime tools view seqs.qzv
```

questions: what are the differences between the two 



