# constructing_allelic_ladder
Given a list of samples that can be used to construct the allelic ladder, this script will give a selection of samples that cover alleles found in the greater population 

Two files are needed:

-- A tab-delimited file with sample names in the first column, followed by two columns (allele A and B) for each genotyped locus. There should be no column headers.
e.g.
```

```
-- A text file with the samples availables to act as an allelic ladder, each sample on a new name. The names should be identical to how they appear in the original tab-delimited file with all the genotypes e.g.
```

```
To run the Rscript, paste it into your R console and then execute by:
```
allelic_ladder(working_dir,tabdelim_file,allelic_ladder_samples)
# e.g. allelic_ladder("C:/Users/Alana/Downloads","Sperm_whale_DNA_profile_sample_name_loci.txt","NZsamplenames.txt")
```
