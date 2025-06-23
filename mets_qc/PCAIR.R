#The following code allows you to run the PC-AiR tool on the latest build from 1000 Human Genomes project \
#This data has been thinned to 100,000 SNPs to reduce the data file sizes. 
#In order to run, download the test-data, that contains the plink files hg38_thinned. \
#Once you download the files, update the necessary paths, replacing "/path/to/" 
#Reference your PC-AiR plot results with the results provided in the git repository. 

#Install GENESIS packages
#if (!require("BiocManager", quietly = TRUE))
#  install.packages("BiocManager")

# The following initializes usage of Bioc devel
#BiocManager::install(version='devel')

#BiocManager::install("GENESIS")


#Open necessary libraries for the code 
library(GENESIS)
library(SNPRelate)
library(GWASTools)
library(dplyr)
library(tibble)
library(data.table)

#Convert PLINK files to GDS object. Outputs a GDS file to the written path folder. 
snpgdsBED2GDS(bed.fn = "/home/isabelle/METS/METS735_rsid_snpfiltered.bed", 
              bim.fn = "/home/isabelle/METS/METS735_rsid_snpfiltered.bim", 
              fam.fn = "/home/isabelle/METS/METS735_rsid_snpfiltered.fam", 
              out.gdsfn = "/home/isabelle/METS/METS735_rsid_snpfiltered.gds")

#Clear any previous opened GDS files
##Not needed for the first run through, but good practice. 
showfile.gds(closeall=TRUE)

#Open GDS file that you created above
gdsfile <- "/home/isabelle/METS/METS735_rsid_snpfiltered.gds"
gds <- snpgdsOpen(gdsfile)

#LD Pruning - creates a list of high linkage disequilibrium SNPs to exclude while running pcair 
snpset <- snpgdsLDpruning(gds, method="corr", slide.max.bp=10e6,
                          ld.threshold=sqrt(0.1), verbose=FALSE)
pruned <- unlist(snpset, use.names=FALSE)

#Save the list as an RDS file for future reference (if needed), outputs the RDS file to the written path folder. 
saveRDS(pruned,"/home/isabelle/METS/METS735_rsid_snpfiltered_pruned_set.RDS")

#Calculate the kinship coefficients 
king <- snpgdsIBDKING(gds)

#Saves kinship column to new dataframe to use for pcair function. Also adds necessary column and row names to run.
kingMat <- king$kinship 
colnames(kingMat)<-king$sample.id
row.names(kingMat)<-king$sample.id

#Save king RDS file for future reference (if needed), outputs the RDS file to the written path folder.
saveRDS(king, file = "/home/isabelle/METS/METS735_rsid_snpfiltered_King_matrix.RDS")

#Close all previously opened GDS files
showfile.gds(closeall=TRUE)

#Create genotype object needed for pcair function
geno <- GdsGenotypeReader(filename = "/home/isabelle/METS/METS735_rsid_snpfiltered.gds") 
genoData <- GenotypeData(geno)

#Run PCAIR with the necessary objects created above. 
mypcair <- pcair(genoData, kinobj = kingMat, divobj = kingMat, snp.include = pruned)

# plot top 2 PCs
png('METS735_rsid_snpfiltered_PC1-2.png')
plot(mypcair)
dev.off()
# plot PCs 2 and 3
png('METS735_rsid_snpfiltered_PC2-3.png')
plot(mypcair, vx = 2, vy = 3)
dev.off()
# plot PCs 3 and 4
plot(mypcair, vx = 3, vy = 4)

pcs<-mypcair$vectors
ids<-mypcair$sample.id%>%as.data.frame()
pcair<-cbind(ids,pcs)

rel<-mypcair$rels%>%as.data.frame()%>%mutate(related='yes')
unrel<-mypcair$unrels%>%as.data.frame()%>%mutate(related='no')
relatedyn<-rbind(rel,unrel)

pcairrel<-inner_join(pcair,relatedyn)
colnames<-colnames(pcairrel)
colnames[1]<-'id'
colnames(pcairrel)<-colnames

fwrite(pcairrel,'/home/isabelle/METS/METS735_rsid_snpfiltered_PCAIR.txt',sep='\t',quote=F,row.names=F)
