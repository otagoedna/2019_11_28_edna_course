# Plotting Taxonomy with Qiime2R and MicrobeR

setwd('/PATH/TO/DATA/FOLDER/')

## Load libraries

library('qiime2R')
library('MicrobeR')

## Import metadata as a simple table

sampleMetadata <- read.table("sample_metadata.tsv", sep='\t', header=T, row.names=1, comment="")
View(sampleMetadata)

## Import frequency table

freqs <- read_qza("mp_full_table-dada2.qza")
View(freqs$data)

## Import taxonomy

taxonomy <- read_qza("mp_full_rep-seqs-dada2_NB_taxonomy.qza")

## Convert taxonomy table for use with MicrobeR

tax_table<-do.call(rbind, strsplit(as.character(taxonomy$data$Taxon), "; "))
colnames(tax_table)<-c("Kingdom","Phylum","Class","Order","Family","Genus","Species")
rownames(tax_table)<-taxonomy$data$Feature.ID

## Plot with MicrobeR

Microbiome.Barplot(Summarize.Taxa(freqs$data, 
  as.data.frame(tax_table))$Family, sampleMetadata, CATEGORY="body_site")

## Try with other category

Microbiome.Barplot(Summarize.Taxa(freqs$data, 
  as.data.frame(tax_table))$Family, sampleMetadata, CATEGORY="year")

## Plot more features
Microbiome.Barplot(Summarize.Taxa(freqs$data, 
  as.data.frame(tax_table))$Family, sampleMetadata, 15, CATEGORY="body_site")

## Plot with ggplotly for interactive features
library(plotly)

ggplotly(Microbiome.Barplot(Summarize.Taxa(freqs$data, 
  as.data.frame(tax_table))$Family, sampleMetadata, CATEGORY="body_site"))




