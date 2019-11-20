## Importing OTUs and tables from other programs

You can see that the two main components that you need to run the diversity analyses is a frequency table and representative sequences. This means we should be able to import results from other other programs, such as OBITools, into Qiime2 to run the statistics. We will try this using the table and ZOTUs from the previous workshop. The only other file you will need is a sample metadata file, which can be as simple or complicated as you need.

The program biom, which comes bundled with the Qiime2 installation, is used to convert to its format:

### Import frequency table

```
biom convert -i zotutab_10_changed.txt -o belarus.biom --to-hdf5 
```

The table in biom format can then be imported into Qiime2:

```
qiime tools import \
  --input-path belarus.biom \
  --type 'FeatureTable[Frequency]' \
  --input-format BIOMV210Format \
  --output-path belarus_feature-table.qza
```

### Import Rep seqs (ZOTUs)

```
qiime tools import \
  --type 'FeatureData[Sequence]' \
  --input-path zotus_10.fasta  \
  --output-path belarus_zotu_rep_seqs.qza
```

### Generate table stats so you can determine --p-sampling-depth

```
qiime feature-table summarize \
  --i-table belarus_feature-table.qza \
  --o-visualization belarus_feat-table.qzv \
  --m-sample-metadata-file fish_samples.tsv

qiime feature-table tabulate-seqs \
  --i-data belarus_zotu_rep_seqs.qza \
  --o-visualization belarus_zotu_rep-seqs.qzv
```

from examining feature table vis, interactive sample detail, can set minimum to 20000

### Run core-metrics on samples

You could run the core-metrics-phylogenetics in order to use diversity (depends on the gene used), but for the sake of this example, the regular core-metrics will suffice.

```
qiime diversity core-metrics \
  --i-table belarus_feature-table.qza \
  --p-sampling-depth 20000 \
  --m-metadata-file fish_samples.tsv \
  --output-dir belarus-core-metrics-results
```