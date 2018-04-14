working_dir <- "C:/Users/Alana/Downloads"
tabdelim_file <- "Sperm_whale_DNA_profile_sample_name_loci.txt"
allelic_ladder_samples <- "NZsamplenames.txt"


allelic_ladder <- function(working_dir,tabdelim_file,allelic_ladder_samples) {
 setwd(working_dir)
 genotypes <- read.table(tabdelim_file,header=FALSE,stringsAsFactors=FALSE,sep="\t")
 ladder <- read.table(allelic_ladder_samples,header=FALSE,stringsAsFactors=FALSE,sep="\t")
 total_allele_list <- vector("list", (dim(genotypes)[2]-1)/2)
 
  for (k in (dim(ladder)[1]):1) { 
   i <- 2
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
  
   for (i in seq(4,((dim(genotypes)[2])-1),2)) {
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
    
    file <- file("allelic_ladder_by_number_of_ref_samples.txt")
    writeLines(paste("Using ",k," ref samples (",paste(ladder[,1],collapse=","),"), the following alleles are represented:",sep=""))
    writeLines(total_allele_list, file)
    close(file)
