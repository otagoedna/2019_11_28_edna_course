# Build a reference database

## Using ecoPCR

One way to build the reference database is to use the [**ecoPCR**](https://pythonhosted.org/OBITools/scripts/ecoPCR.html) program to simulate a PCR and to extract all sequences from the EMBL that may be amplified in silico by the two primers (TTAGATACCCCACTATGC and TAGAACAGGCTCCTCTAG in this example) used for PCR amplification.

The full list of steps for building this reference database would then be:

1.	Download the whole set of EMBL sequences (available from: [ftp://ftp.ebi.ac.uk/pub/databases/embl/release/](ftp://ftp.ebi.ac.uk/pub/databases/embl/release/))

2.	Download the NCBI taxonomy (available from: [ftp://ftp.ncbi.nih.gov/pub/taxonomy/taxdump.tar.gz](ftp://ftp.ncbi.nih.gov/pub/taxonomy/taxdump.tar.gz))


3.	Format them into the ecoPCR format (see [**obiconvert**](https://pythonhosted.org/OBITools/scripts/obiconvert.html) for how you can produce ecoPCR compatible files)

4.	Use ecoPCR to simulate amplification and build a reference database based on putatively amplified barcodes together with their recorded taxonomic information

As step 1 and step 3 can be really time-consuming (about one day), we already provide the reference database produced by the following commands so that you can skip its construction. Note that as the EMBL database and taxonomic data can evolve daily, if you run the following commands you may end up with quite different results.

Any utility allowing file downloading from a ftp site can be used. In the following commands, we use the commonly used wget Unix command.

<br>

### Download the sequences

```
mkdir EMBL

cd EMBL

wget -nH --cut-dirs=4 -Arel_std_\*.dat.gz -m ftp://ftp.ebi.ac.uk/pub/databases/embl/release/

cd ..
```

<br>

### Download the taxonomy

```
mkdir TAXO

cd TAXO

wget ftp://ftp.ncbi.nih.gov/pub/taxonomy/taxdump.tar.gz

tar -zxvf taxdump.tar.gz

cd ..
```

<br>

### Format the data

```
obiconvert --embl -t ./TAXO --ecopcrDB-output=embl_last ./EMBL/*.dat
```

<br>

### Use ecoPCR to simulate an in silico\` PCR


```
ecoPCR -d ./ECODB/embl_last -e 3 -l 50 -L 150 \
  TTAGATACCCCACTATGC TAGAACAGGCTCCTCTAG > v05.ecopcr
```

Note that the primers must be in the same order both in wolf_diet_ngsfilter.txt and in the ecoPCR command.

<br>

### Clean the database

1. filter sequences so that they have a good taxonomic description at the species, genus, and family levels (**obigrep** command below).

2. remove redundant sequences (**obiuniq** command below).

3. ensure that the dereplicated sequences have a taxid at the family level (**obigrep** command below).

4. ensure that sequences each have a unique identification (obiannotate command below)

```
obigrep -d embl_last --require-rank=species \
  --require-rank=genus --require-rank=family v05.ecopcr > v05_clean.fasta
```

<br>

```
obiuniq -d embl_last \
  v05_clean.fasta > v05_clean_uniq.fasta
```

<br>

```
obigrep -d embl_last --require-rank=family \
  v05_clean_uniq.fasta > v05_clean_uniq_clean.fasta
```

<br>

```
obiannotate --uniq-id v05_clean_uniq_clean.fasta > db_v05.fasta
```
