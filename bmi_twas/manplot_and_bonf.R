library(data.table)
library(dplyr)
library(stringr)
library(qqman)
"%&%" = function(a,b) paste(a,b,sep="")

files <- list.files('/home/isabelle/summary_stats/aou_bmi_spred', pattern='AoU-', recursive = T, full.names=T)

for(file in files){
if (str_detect(file,'ALL')){
  aoupop='all'
}else if(str_detect(file,'afr')){
  aoupop='afr'
}else if(str_detect(file,'amr')){
  aoupop='amr'
}else if(str_detect(file,'eur')){
  aoupop='eur'
}

if (str_detect(file,'AFA')){
  modelpop='AFA'
}else if(str_detect(file,'EUR')){
  modelpop='EUR'
}else if(str_detect(file,'CHN')){
  modelpop='CHN'
}else if(str_detect(file,'HIS')){
  modelpop='HIS'
}

if (str_detect(file,'EN')){
  modeltype='EN'
}else if(str_detect(file,'mashr')){
  modeltype='mashr'
}else{next}

gwas<-fread(file)
bp_chrom<-fread('BP_Chrom.csv')

bp_chrom$gene<-str_sub(bp_chrom$gene,end=15)
bp_chrom$chr<-str_sub(bp_chrom$chr,start=4)

gwas_bpchr<-left_join(gwas,bp_chrom)
gwas_bpchr<-filter(gwas_bpchr,!is.na(gwas_bpchr$chr))
gwas_bpchr<-filter(gwas_bpchr,!is.na(gwas_bpchr$pvalue))
gwas_bpchr$chr<-as.numeric(gwas_bpchr$chr)
gwas_bpchr$BP<-as.numeric(gwas_bpchr$BP)

bonf=0.05/(nrow(gwas))
bonfsig<-filter(gwas,pvalue<bonf)
fwrite(bonfsig,'bonfsig_BMI_AoU_'%&%aoupop%&%'_MESA_'%&%modelpop%&%'_'%&%modeltype%&%'.txt')

png('manplot_BMI_AoU_'%&%aoupop%&%'_MESA_'%&%modelpop%&%'_'%&%modeltype%&%'.png')
manhattan(gwas_bpchr,chr='chr',snp='gene',p='pvalue',bp='BP',suggestiveline = -log10(bonf),title='AoU '%&%aoupop%&%', MESA '%&%modelpop%&%' '%&%modeltype)
dev.off()
}