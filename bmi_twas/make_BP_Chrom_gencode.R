#read gencode .gtf file, extract attributes, make BP Chrom file
library(data.table)
library(dplyr)
genes<- fread("/home/isabelle/snp_conversions/gencode.v38.annotation.gtf")
colnames(genes)<-c('seqname','source','feature','start','end','score','strand','frame','attributes')
genes<-genes%>%filter(feature=='gene')

#function to deal with the attributes field
extract_attributes <- function(gtf_attributes, att_of_interest){
  att <- unlist(strsplit(gtf_attributes, " "))
  if(att_of_interest %in% att){
    return(gsub("\"|;","", att[which(att %in% att_of_interest)+1]))
  }else{
    return(NA)}
}

genes$gene_id <- unlist(lapply(genes$attributes, extract_attributes, "gene_id"))
genes$gene_name <- unlist(lapply(genes$attributes, extract_attributes, "gene_name"))

#BP Chrom files are gene gene_name chr BP
#using start as the BP because idk what else i'd do
bp_chrom<-genes%>%select(gene_id, gene_name, seqname, start)
colnames(bp_chrom)<-c("gene","gene_name","chr","BP")
write.csv(bp_chrom, "/home/isabelle/summary_stats/aou_bmi_spred/BP_Chrom.csv",quote=F,row.names=F)

#output file format
#gene,gene_name,chr,BP
#ENSG00000223972.5,DDX11L1,chr1,11869