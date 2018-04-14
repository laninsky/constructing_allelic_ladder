working_dir <- "C:/Users/Alana/Downloads"
tabdelim_file <- "Sperm_whale_DNA_profile_sample_name_loci.txt"
allelic_ladder_samples <- "NZsamplenames.txt"


allelic_ladder <- function(working_dir,tabdelim_file,allelic_ladder_samples) {
 setwd(working_dir)
 genotypes <- read.table(tabdelim_file,header=FALSE,stringsAsFactors=FALSE,sep="\t")
 ladder <- read.table(allelic_ladder_samples,header=FALSE,stringsAsFactors=FALSE,sep="\t")
 allele_list <- NULL
 
 for (i in seq(2,(dim(genotypes)[2]),2)) {
  
  
