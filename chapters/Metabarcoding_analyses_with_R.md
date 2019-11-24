# Metabarcoding analyses with R

In the previous tutorials we have generated representive sequences, taxonomy assigments, and a plethora of community ecology outputs. The corresponding Qiime visuals allow for extensive interaction with the results. However, for going beyond these analyses, it is useful to convert the Qiime *artifacts* into files that can be used by other programs. The simple Qiime export command facilitates this, but for downstream analyses in R, there is a package called [**Qiime2R**]() that provides tools for easy import of Qiime artifacts directly into R objects for further analyses. This is especially useful for generating publication-quality graphs using R graphic tools such as ggplot. 

<br>

## Importing into R

We will use RStudio for 