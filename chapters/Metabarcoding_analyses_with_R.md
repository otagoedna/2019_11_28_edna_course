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

## Plotting Alpha Diversity

Now we will plot one of the outputs from the alpha diversity analyses

import the artifact

```
shannon <- read_qza("{CORE-METRICS-RESULTS}/shannon_vector.qza")
```

Now we will create a graph

```
shannon$data %>%
  as.data.frame() %>%
  rownames_to_column("sample-id") %>%
  left_join(metadata) %>%
  mutate(DaysSinceExperimentStart=as.numeric(days_since_experiment_start)) %>% #coerce this to be stored as number
  ggplot(aes(x=DaysSinceExperimentStart, y=shannon, group=subject, color=body_site, shape=reported_antibiotic_usage)) +
  geom_point(size=4) +
  geom_line() +
  facet_grid(body_site~subject) + #plot body sites across rows and subjects across columns
  theme_bw() +
  xlab("Time (days)") +
  ylab("Shannon Diversity") +
  ggtitle("Shannon diversity across time")
```

<br><br>

## Plotting Beta Diversity

Next we will import and plot one of the outputs from the beta diversity analyses

```
pco <- read_qza("{CORE-METRICS-RESULTS}/unweighted_unifrac_pcoa_results.qza")
```

And graph:

```
pco$data$Vectors %>%
  rename("sample-id"=SampleID) %>% #rename to match the metadata table
  left_join(metadata) %>%
  left_join(shannon$data %>% rownames_to_column("sample-id")) %>%
  ggplot(aes(x=PC1, y=PC2, shape=subject, color=body_site, size=shannon)) +
  geom_point() +
  xlab(paste("PC1: ", round(100*pco$data$ProportionExplained[1]), "%")) +
  ylab(paste("PC2: ", round(100*pco$data$ProportionExplained[2]), "%")) +
  theme_bw() +
  ggtitle("Unweighted UniFrac")
```














