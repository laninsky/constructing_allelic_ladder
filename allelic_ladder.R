working_dir <- "C:/Users/Alana/Downloads"
tabdelim_file <- "Sperm_whale_DNA_profile_sample_name_loci.txt"
allelic_ladder_samples <- "NZsamplenames.txt"


allelic_ladder <- function(working_dir,tabdelim_file,allelic_ladder_samples) {
 # Setting directory and reading in files
 setwd(working_dir)
 genotypes <- read.table(tabdelim_file,header=FALSE,stringsAsFactors=FALSE,sep="\t")
 ladder <- read.table(allelic_ladder_samples,header=FALSE,stringsAsFactors=FALSE,sep="\t")
 # Setting up the total_allele_list object which record which alleles are represented for each locus
 total_allele_list <- vector("list", (dim(genotypes)[2]-1)/2)
 k <- dim(ladder)[1]
 # Filling total_allele_list, including allele frequencies for the total dataset (as we tweak the ref sample numbers, we'll
 # only be changing the ref_allele_counts row
 for (i in seq(2,((dim(genotypes)[2])-1),2)) {
   tempallele <- rbind(matrix(genotypes[,i],ncol=1),matrix(genotypes[,(i+1)],ncol=1))
   allele <- unique(tempallele)
   allele <- allele[(which(allele[,1]!=0)),1]
   allele <- sort(allele)
   allele_counts <- rep(NA,length(allele))
   ref_allele_counts <- rep(NA,length(allele))
   for (j in 1:length(allele_counts)) {
    allele_counts[j] <- sum(genotypes[,i:(i+1)]==allele[j])
    ref_allele_counts[j] <- sum(genotypes[(which(genotypes[,1] %in% ladder[,1])),i:(i+1)]==allele[j])
   }
   total_allele_list[[i/2]] <- rbind(allele,allele_counts, ref_allele_counts)
   }

for (i in 1:length(total_allele_list)) {
    for (j in 1:(dim(total_allele_list[[i]])[2])) {
    total_allele_list[[i]][3,j] <- sum(genotypes[(which(genotypes[,1] %in% ladder[,1])),(i*2):((i*2)+1)]==total_allele_list[[i]][1,j])
   }
} 
 
 
 
  while (k > 1) { 
    
    cat(paste("Using ",k," ref samples (",paste(ladder[,1],collapse=","),"), the following alleles are represented:",sep=""),"\n",file="allelic_ladder_by_number_of_ref_samples.txt",append=TRUE,sep='')
    for (i in 1:length(total_allele_list)) {
     cat(paste("Locus ",i,sep=""),"\n",file="allelic_ladder_by_number_of_ref_samples.txt",append=TRUE,sep='')
     write.table(total_allele_list[[i]],"allelic_ladder_by_number_of_ref_samples.txt",append=TRUE,col.names=FALSE)
    }
    cat("\n",file="allelic_ladder_by_number_of_ref_samples.txt",append=TRUE,sep='')
   
    old_num_samples <- dim(ladder)[1]
    del_position <- NULL 
    
    i <- 1
    while (i <= dim(ladder)[1]) {
     for (j in 1:length(total_allele_list)) {
       protected_alleles
