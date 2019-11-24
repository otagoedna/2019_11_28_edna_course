# Qiime2R tutorial

setwd('/PATH/TO/DATA/FOLDER/')
setwd('/Users/hughcross/Analysis/DEVELOPMENT/metabarcoding_course/sample_data_qiime/movingPictures/full_sequences/')
## Load libraries
library("tidyverse")
library('qiime2R')
library('MicrobeR')
library("phyloseq")

## Importing artifacts

metadata <- read_tsv("sample_metadata.tsv")
metadata
View(metadata)

SVs <- read_qza("mp_sub50k_VStable-dn-99.qza")
SVs
SVs$data[1:5,1:5]
View(SVs$data)

## Plotting Alpha Diversity

shannon<-read_qza("core_metric_results/shannon_vector.qza")
shannon

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

## Plotting Beta Diversity

pco <- read_qza("core_metric_results/unweighted_unifrac_pcoa_results.qza")

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



