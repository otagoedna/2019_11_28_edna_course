# Filtering tables


It is possible to filter the feature tables to remove samples or features. There is a [full tutorial](https://docs.qiime2.org/2019.7/tutorials/filtering/) showing many examples. Here we will go over just one.

From the FMT full table, we observe that there are many taxa in the phylum Firmicutes across all samples. If we want to explore this group in more depth, we can create a new table with just these taxa.

```
qiime taxa filter-table \
  --i-table {TABLE}.qza \
  --i-taxonomy {TAXONOMY}.qza \
  --p-include "k__Bacteria; p__Firmicutes" \
  --o-filtered-table {FIRMICUTES-TABLE}.qza
```

You could also collapse the OTUs in the table by taxonomic rank. Choosing the `--p-level` of 6 will collapse around genus.

```
qiime taxa collapse \
 --i-table {FIRMICUTES-TABLE}.qza \
 --i-taxonomy {TAXONOMY}.qza \
 --p-level 6 \
 --o-collapsed-table {FIRMICUTES-TABLE-AT-GENUS}.qza
```

You can then produce a barplot of your filtered table, to focus on taxa or grouped features

```
qiime taxa barplot \
  --i-table {FIRMICUTES-TABLE-AT-GENUS}.qza \
  --i-taxonomy {TAXONOMY}.qza \
  --m-metadata-file sample_metadata.tsv \
  --o-visualization {FIRMICUTES-GENUS-TAXA-BAR-PLOTS_VIZ}.qzv
```

<br><br>

## Grouping tables by feature

Another handy plug-in allows you to group samples in an analysis by a feature. In the FMT taxonomy, there are many samples, and it might be better to look at them as a group. For example, we can group by week to see how the taxonomic composition changes 

```
qiime feature-table group \
  --i-table {TABLE}.qza \
  --p-axis sample \
  --m-metadata-file sample-metadata.tsv \
  --m-metadata-column week \
  --p-mode sum \
  --o-grouped-table {GROUP_BY_WEEK_TABLE}.qza
```

The only thing is that because the samples are now a feature, a new metadata file is needed to create the bar plots. I have made a very simple one for this example.

```
qiime taxa barplot \
  --i-table {GROUP_BY_WEEK_TABLE}.qza \
  --i-taxonomy {TAXONOMY}.qza \
  --m-metadata-file week_metadata.tsv \
  --o-visualization {GRP_BY_WEEK_TAXA-BAR-PLOTS}.qzv
```
