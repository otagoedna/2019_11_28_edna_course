# Metabarcoding analyses with R

In the previous tutorials we have generated representive sequences, taxonomy assigments, and a plethora of community ecology outputs. The corresponding Qiime visuals allow for extensive interaction with the results. However, for going beyond these analyses, it is useful to convert the Qiime *artifacts* into files that can be used by other programs. The simple Qiime export command facilitates this, but for downstream analyses in R, there is a package called [**Qiime2R**]() that provides tools for easy import of Qiime artifacts directly into R objects for further analyses. This is especially useful for generating publication-quality graphs using R graphic tools such as ggplot. 

<br>

## Importing into R

We will use RStudio for this. Open RStudio and create a R script document (File > New File > R Script) to keep track of your work.

First set the path to the folder with your Qiime artifacts:

```
setwd('/PATH/TO/DATA/FOLDER')
```

Then load the libraries needed:

```
library("tidyverse")
library('qiime2R')
library('MicrobeR')
```

We will first import some Qiime files

```
metadata <- read_tsv("sample_metadata.tsv")
metadata
View(metadata)
```

```
SVs <- read_qza("{FEATURE-TABLE}.qza")

SVs

SVs$data[1:5,1:5]

View(SVs$data)
```

<br>

## Plotting Beta Diversity

First we will import and plot one of the outputs from the beta diversity analyses

```
pco <- read_qza("{CORE-METRICS-RESULTS}/unweighted_unifrac_pcoa_results.qza")
```

Then we have to convert the data

```
pcoConvert <- pco$data$Vectors %>%
  rename("sample-id"=SampleID) %>% #rename to match the metadata table
  left_join(metadata) %>%
  left_join(shannon$data %>% rownames_to_column("sample-id"))
```

And create a graph object:

```
pcoPlot <-   ggplot(pcoConvert, aes(x=PC1, y=PC2, 
  shape=subject, color=body_site, size=shannon)) +
  geom_point() + 
  xlab(paste("PC1: ", round(100*pco$data$ProportionExplained[1]), "%")) +
  ylab(paste("PC2: ", round(100*pco$data$ProportionExplained[2]), "%")) +
  theme_bw() +
  ggtitle("Unweighted UniFrac")
```

Then to view

```
pcoPlot
```

<br><br>

## Plotting Alpha Diversity

Now we will plot one of the outputs from the alpha diversity analyses

import the artifact

```
shannon <- read_qza("{CORE-METRICS-RESULTS}/shannon_vector.qza")
```

Then we have to convert the data

```
shannonData <- shannon$data %>%
  as.data.frame() %>%
  rownames_to_column("sample-id") %>%
  left_join(metadata) %>%
  mutate(DaysSinceExperimentStart=as.numeric(days_since_experiment_start))
```

Now we will create a graph

```
shannonPlot <- ggplot(shannonData, aes(x=DaysSinceExperimentStart,
  y=shannon, group=subject, 
  color=body_site, 
  shape=reported_antibiotic_usage)) +
  geom_point(size=4) +
  geom_line() +
  facet_grid(body_site~subject) + 
  theme_bw() +
  xlab('Time (days)') +
  ylab("Shannon Diversity") +
  ggtitle("Shannon diversity across time")
```

and to view

```
shannonPlot
```



<br><br>

## Plotting Taxonomy

For plotting taxonomy, we will be using a combination of qiime2R and MicrobeR, which will require us to import some of the data a little differently.

First, we will import metadata as a simple table

```
sampleMetadata <- read.table("sample_metadata.tsv", sep='\t', header=T, row.names=1, comment="")

View(sampleMetadata)
```

Now we will import the frequency table


```
freqs <- read_qza("mp_full_table-dada2.qza")

View(freqs$data)
```

Import taxonomy

```
taxonomy <- read_qza("mp_full_rep-seqs-dada2_NB_taxonomy.qza")

View(taxonomy)
```

Now we have to convert the taxonomy table for use with MicrobeR

```
tax_table<-do.call(rbind, strsplit(as.character(taxonomy$data$Taxon), "; "))

colnames(tax_table)<-c("Kingdom","Phylum","Class","Order","Family","Genus","Species")

rownames(tax_table)<-taxonomy$data$Feature.ID
```

Plot with MicrobeR, using body_site category

```
Microbiome.Barplot(Summarize.Taxa(freqs$data, 
  as.data.frame(tax_table))$Family, sampleMetadata, CATEGORY="body_site")
```

Try with a different category

```
Microbiome.Barplot(Summarize.Taxa(freqs$data, 
  as.data.frame(tax_table))$Family, sampleMetadata, CATEGORY="year")
```

Plot more features (default is 10)

```
Microbiome.Barplot(Summarize.Taxa(freqs$data, 
  as.data.frame(tax_table))$Family, sampleMetadata, 15, CATEGORY="body_site")
```









