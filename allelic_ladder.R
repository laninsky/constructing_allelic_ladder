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
 
 # Going to pare down our reference samples, trying to give priority to the smallest and largest alleles for each locus, and reasonably even representation across the range
 # The first run through is removing samples that do not have a unique allele for any loci
 while (k > 1) { 
  # Printing out the ref samples and alleles they represent
  cat(paste("Using ",k," ref samples (",paste(ladder[,1],collapse=","),"), the following alleles are represented:",sep=""),"\n",file="allelic_ladder_by_number_of_ref_samples.txt",append=TRUE,sep='')
  for (i in 1:length(total_allele_list)) {
    cat(paste("Locus ",i,sep=""),"\n",file="allelic_ladder_by_number_of_ref_samples.txt",append=TRUE,sep='')
    write.table(total_allele_list[[i]],"allelic_ladder_by_number_of_ref_samples.txt",append=TRUE,col.names=FALSE)
  }
  cat("\n",file="allelic_ladder_by_number_of_ref_samples.txt",append=TRUE,sep='')
  
  # Recording how many ref samples were in the previous iteration
  old_num_samples <- dim(ladder)[1]    
  i <- 1
    # Need to do a while loop, because dimensions of ladder will change if samples removed 
  while (i <= dim(ladder)[1]) {
   for (j in 1:length(total_allele_list)) {
    protected_alleles <- total_allele_list[[j]][1,(which(total_allele_list[[j]][3,]<=1))]
    if (any(genotypes[(which(genotypes[,1] %in% ladder[i,1])),(j*2):((j*2)+1)] %in% protected_alleles)) {
      i <- i + 1
      break
    }  
   }
   # Recalculating total_allele_list
   for (a in 1:length(total_allele_list)) {
    for (m in 1:(dim(total_allele_list[[a]])[2])) {
     total_allele_list[[a]][3,m] <- sum(genotypes[(which(genotypes[,1] %in% ladder[,1])),(a*2):((a*2)+1)]==total_allele_list[[a]][1,m])
    }
   } 
   ladder <- matrix(ladder[-i,],ncol=1) 
  }
