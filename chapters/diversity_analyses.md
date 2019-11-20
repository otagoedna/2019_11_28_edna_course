# Diversity Analyses

We will go through some of the statistical analyses that Qiime2 can perform on the data.

## Generate tree for phylogenetic diversity analysis

```
qiime phylogeny align-to-tree-mafft-fasttree \
  --i-sequences {REP-SEQS}.qza \
  --o-alignment {ALIGNED-REP-SEQS}.qza \
  --o-masked-alignment {MASKED-ALIGNED-REP-SEQS}.qza \
  --o-tree {UNROOTED-TREE}.qza \
  --o-rooted-tree {ROOTED-TREE}.qza
```

## Alpha and beta diversity analyses

A more detailed description of the following statistical tests can be found on the [**Moving Pictures tutorial page**](https://docs.qiime2.org/2019.7/tutorials/moving-pictures/#alpha-and-beta-diversity-analysis)

### Determine appropriate sampling depth

It is necessary to set the rarefaction or sampling depth for the analyses (see [**here**](https://docs.qiime2.org/2019.7/tutorials/moving-pictures/#alpha-and-beta-diversity-analysis) for an explanation). This is set with the `--p-sampling-depth` parameter in the core-metrics plugin. You can look at the feature table summary to examine the number of reads for each sample to help set the sampling depth:

```
qiime tools view {FEATURE-TABLE-VIZ}.qzv
```

### Run core metrics 

Now we will run the core-metrics-phylogenetic pipeline, which runs a range of alpha and beta diversity tests on the data. This utilises the tree produced in the previous step in order to measure diversity based on phylogenetic distance.

```
qiime diversity core-metrics-phylogenetic \
  --i-phylogeny {ROOTED-TREE}.qza \
  --i-table {FEATURE-TABLE}.qza \
  --p-sampling-depth {NUMBER} \
  --m-metadata-file sample_metadata.tsv \
  --output-dir {CORE-METRICS-RESULTS}
```

Several statistical and visual outputs are produced, including PCOA plots. Here is one:

```
qiime tools view {CORE-METRICS-RESULTS}/bray_curtis_emperor.qzv
```

### Alpha diversity (within samples)

We will now test for associations between categories in the sample metadata file and alpha diversity data.

```
qiime diversity alpha-group-significance \
  --i-alpha-diversity {CORE-METRICS-RESULTS}/faith_pd_vector.qza \
  --m-metadata-file sample_metadata.tsv \
  --o-visualization {CORE-METRICS-RESULTS}/faith-pd-group-significance.qzv

qiime diversity alpha-group-significance \
  --i-alpha-diversity {CORE-METRICS-RESULTS}/evenness_vector.qza \
  --m-metadata-file sample_metadata.tsv \
  --o-visualization {CORE-METRICS-RESULTS}/evenness-group-significance.qzv
```

Then we can visualise the output from evenness group significance:

```
qiime tools view {CORE-METRICS-RESULTS}/evenness-group-significance.qzv
```

### Beta diversity (between samples)

Now we will test whether the distances between samples within a group are more similar to each other than they are to samples from other groups. The 'group' you will get from the sample metadata categories. You can examine the PCoA produced in the core-metrics analyses above to determine what will likely give a significant result. 

```
qiime diversity beta-group-significance \
  --i-distance-matrix {CORE-METRICS-RESULTS}/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file sample_metadata.tsv \
  --m-metadata-column {METADATA-CATEGORY} \
  --o-visualization {CORE-METRICS-RESULTS}/unweighted-unifrac-{METADATA-CATEGORY}-significance.qzv \
  --p-pairwise
```

We can visualise our permanova result:

```
qiime tools view {CORE-METRICS-RESULTS}/unweighted-unifrac-{METADATA-CATEGORY}-significance.qzv
```

### Alpha rarefaction plotting

```
qiime diversity alpha-rarefaction \
  --i-table {FEATURE-TABLE}.qza \
  --i-phylogeny {ROOTED-TREE}.qza \
  --p-max-depth {number} \
  --m-metadata-file sample_metadata.tsv \
  --o-visualization {alpha-rarefaction-VIZ}.qzv
```

### Further analyses

There are many kinds of analyses you can run on the data, such as [**time series**](https://docs.qiime2.org/2019.10/tutorials/longitudinal/), and [**Mantel distance**](https://docs.qiime2.org/2019.10/plugins/available/diversity/mantel/). See the [**Diversity plugin page**](https://docs.qiime2.org/2019.10/plugins/available/diversity/) for more information.










