# constructing_allelic_ladder
Given a list of samples that can be used to construct the allelic ladder, this script will give a selection of samples that cover alleles found in the greater population 

Two files are needed:

-- A tab-delimited file with sample names in the first column, followed by two columns (allele A and B) for each genotyped locus. There should be no column headers.
e.g.
```
COC20020503-0012	120	130	158	158	201	205	79	79	131	135	183	187	140	143	182	182	134	156	221	221	147	147	121	121	96	129
COC20020504-0023	120	130	158	158	201	205	79	79	131	135	183	187	140	143	182	182	134	156	221	221	147	147	121	121	96	129
COC20020504-0013	120	120	154	158	201	203	79	79	131	131	177	183	140	145	182	186	160	160	224	235	145	147	119	119	125	131
COC20020504-0025	120	120	154	158	201	203	79	79	131	131	177	183	140	145	182	186	160	160	224	235	145	147	119	119	125	131
COC20020504-0015	120	120	154	156	201	203	79	81	131	137	183	185	140	143	182	182	160	160	211	233	145	147	117	121	120	120
```
-- A text file with the samples availables to act as an allelic ladder, each sample on a new name. The names should be identical to how they appear in the original tab-delimited file with all the genotypes e.g.
```
PmaNZ010
PmaNZ011
PmaNZ058
PmaNZ060
PmaNZ_U07-099
```
To run the Rscript, paste it into your R console and then execute by:
```
allelic_ladder(working_dir,tabdelim_file,allelic_ladder_samples)
# e.g. allelic_ladder("C:/Users/Alana/Downloads","Sperm_whale_DNA_profile_sample_name_loci.txt","NZsamplenames.txt")
```
