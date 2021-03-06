allelic_ladder <- function(working_dir,tabdelim_file,allelic_ladder_samples,end_allele_weight) {
 #e.g. allelic_ladder("Dropbox","Spermwhale_global_genotypes.txt","NZsamples.txt",5)
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
   savethissample <- "NO"
   for (j in 1:length(total_allele_list)) {
    protected_alleles <- total_allele_list[[j]][1,(which(total_allele_list[[j]][3,]<=1))]
    if (any(genotypes[(which(genotypes[,1] %in% ladder[i,1])),(j*2):((j*2)+1)] %in% protected_alleles)) {
      savethissample <- "YES"      
    }  
   }
   if (genotypes[(which(genotypes[,1] %in% ladder[i,1])),(j*2)] == genotypes[(which(genotypes[,1] %in% ladder[i,1])),((j*2)+1)]) {
    if (genotypes[(which(genotypes[,1] %in% ladder[i,1])),(j*2)] !=0 ) {
     if(total_allele_list[[j]][3,(which(total_allele_list[[j]][1,]==genotypes[(which(genotypes[,1] %in% ladder[i,1])),(j*2)]))]==2) {
      savethissample <- "YES" 
     } 
    }
   } 
   if (savethissample=="YES") {
    i <- i + 1
   } else { 
    # Recalculating total_allele_list
    print(paste("Removing",ladder[i,1]))
    ladder <- matrix(ladder[-i,],ncol=1)
    k <- dim(ladder)[1]

    for (a in 1:length(total_allele_list)) {
     for (m in 1:(dim(total_allele_list[[a]])[2])) {
      total_allele_list[[a]][3,m] <- sum(genotypes[(which(genotypes[,1] %in% ladder[,1])),(a*2):((a*2)+1)]==total_allele_list[[a]][1,m])
     } 
    }
   }
  }
  if ( old_num_samples==dim(ladder)[1] ) { #1A
   sample_specific_weight <- rep(0,dim(ladder)[1])
   protected_alleles <- vector("list", length(total_allele_list))
   for (j in 1:length(total_allele_list)) { #2A
    ref_only_allele <-  total_allele_list[[j]][1,(which(total_allele_list[[j]][3,]>=1))]
    protected_alleles[[j]] <- c(ref_only_allele[1],ref_only_allele[(length(ref_only_allele))])
   }    
   for ( i in 1:(dim(ladder)[1])) { #3A
     for (j in 1:length(total_allele_list)) { #4A
      if (genotypes[(which(genotypes[,1] %in% ladder[i,1])),(j*2)] %in% protected_alleles[[j]]) { #5A
       sample_specific_weight[i] <- sample_specific_weight[i]+end_allele_weight
      } else { #5AB
       if ( genotypes[(which(genotypes[,1] %in% ladder[i,1])),(j*2)]!=0 ) { #6A
        sample_specific_weight[i] <- sample_specific_weight[i]+total_allele_list[[j]][2,(which(total_allele_list[[j]][1,]==genotypes[(which(genotypes[,1] %in% ladder[i,1])),(j*2)]))]/sum(total_allele_list[[j]][2,])
       } #6B
      } #5B
      if (genotypes[(which(genotypes[,1] %in% ladder[i,1])),(j*2)] != genotypes[(which(genotypes[,1] %in% ladder[i,1])),((j*2)+1)]) { #7A
       if (genotypes[(which(genotypes[,1] %in% ladder[i,1])),((j*2)+1)] %in% protected_alleles[[j]]) { #8A
        sample_specific_weight[i] <- sample_specific_weight[i]+end_allele_weight
       } else { #8AB
        if ( genotypes[(which(genotypes[,1] %in% ladder[i,1])),((j*2)+1)]!=0 ) { #9A
         sample_specific_weight[i] <- sample_specific_weight[i]+total_allele_list[[j]][2,(which(total_allele_list[[j]][1,]==genotypes[(which(genotypes[,1] %in% ladder[i,1])),((j*2)+1)]))]/sum(total_allele_list[[j]][2,])
        } #9B
       } #8B
      } #7B  
     } #4B        
   } #3B
   cat(paste("Removing following sample: ",ladder[(which(sample_specific_weight==min(sample_specific_weight))),1],sep=""),"\n",file="allelic_ladder_by_number_of_ref_samples.txt",append=TRUE,sep='')
   if (k == 2) {
    if (sample_specific_weight[1] == sample_specific_weight[2]) {
     ladder <-  matrix(ladder[-1,],ncol=1)
    } else { 
     ladder <-  matrix(ladder[-(which(sample_specific_weight==min(sample_specific_weight))),],ncol=1)
    }
   } else {
    ladder <-  matrix(ladder[-(which(sample_specific_weight==min(sample_specific_weight))),],ncol=1)
   } 
   old_total_allele_list <- total_allele_list
   for (a in 1:length(total_allele_list)) {
     for (m in 1:(dim(total_allele_list[[a]])[2])) {
      total_allele_list[[a]][3,m] <- sum(genotypes[(which(genotypes[,1] %in% ladder[,1])),(a*2):((a*2)+1)]==total_allele_list[[a]][1,m])
      if (old_total_allele_list[[a]][3,m] > 0 & total_allele_list[[a]][3,m]==0) {
        cat(paste("Locus ",a,sep=""),"\n",file="allelic_ladder_by_number_of_ref_samples.txt",append=TRUE,sep='')
        cat(paste("Allele ",old_total_allele_list[[a]][1,m],sep=""),"\n",file="allelic_ladder_by_number_of_ref_samples.txt",append=TRUE,sep='')
        cat(paste("With a global frequency of ",old_total_allele_list[[a]][2,m]/sum(old_total_allele_list[[a]][2,])," has been removed from the allelic ladder with removal of this sample",sep=""),"\n",file="allelic_ladder_by_number_of_ref_samples.txt",append=TRUE,sep='')
      }     
     }
   }
   k <- dim(ladder)[1]
  } #1B
 } #while loop
} #formula
