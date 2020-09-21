# More on importing DNA sequences

## Importing demultiplexed sequences

In many cases, such as dual-index barcodes, it is not possible to use Qiime for demultiplexing. In this example we will use sequence files that have already been demultiplexed.

To import a group of files, we need to create a *manifest* file. This is a simple tab-delimited file with the sample ID and path of each file:

```
sample-id     absolute-filepath
sample-1      $PWD/some/filepath/sample1_R1.fastq
sample-2      $PWD/some/filepath/sample2_R1.fastq
```

See the Qiime2 [**Importing Data Tutorial**](https://docs.qiime2.org/2020.8/tutorials/importing/) for more details, including importing paired end sequences. 

Once you have a manifest file, you can import the sequence files into a Qiime2 Artifact. We will start with the FMT run 2 sequences, as it is smaller and will go a little quicker. There is already a manifest file in your main folder called *run_2_manifest.txt*. Change the --input-path parameter in the following command, as well as the name of the output file (--output-path)

```
qiime tools import \
  --type 'SampleData[SequencesWithQuality]' \
  --input-path {MANIFEST_FILE} \
  --output-path {QIIME_DEMUX}.qza \
  --input-format SingleEndFastqManifestPhred33V2
```

<br><br>

## Importing OTUs and tables from other programs

You can see that the two main components that you need to run the diversity analyses is a frequency table and representative sequences. This means we should be able to import results from other other programs, such as OBITools, into Qiime2 to run the statistics. We will try this using the table and ZOTUs from the previous workshop. The only other file you will need is a sample metadata file, which can be as simple or complicated as you need.

<br>

### Import frequency table

The program biom, which comes bundled with the Qiime2 installation, is used to convert to its format

```
biom convert -i zotutab_converted.txt -o fish.biom --to-hdf5
```

The table in biom format can then be imported into Qiime2:

```
qiime tools import \
  --input-path fish.biom \
  --type 'FeatureTable[Frequency]' \
  --input-format BIOMV210Format \
  --output-path fish_feature-table.qza
```

### Import Rep seqs (ZOTUs)

```
qiime tools import \
  --type 'FeatureData[Sequence]' \
  --input-path zotus.fasta  \
  --output-path zotu_rep_seqs.qza
```

### Generate table stats so you can determine --p-sampling-depth

```
qiime feature-table summarize \
  --i-table fish_feature-table.qza \
  --o-visualization fish_feat-table.qzv \
  --m-sample-metadata-file fish_samples.tsv

qiime feature-table tabulate-seqs \
  --i-data fish_zotu_rep_seqs.qza \
  --o-visualization fish_zotu_rep-seqs.qzv
```

from examining feature table vis, interactive sample detail, can set minimum to 20000

### Run core-metrics on samples

You could run the core-metrics-phylogenetics in order to use diversity (depends on the gene used), but for the sake of this example, the regular core-metrics will suffice.

```
qiime diversity core-metrics \
  --i-table fish_feature-table.qza \
  --p-sampling-depth 20000 \
  --m-metadata-file fish_samples.tsv \
  --output-dir fish-core-metrics-results
```

