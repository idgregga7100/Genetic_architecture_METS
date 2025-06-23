library(data.table)
library(dplyr)
library(stringr)
"%&%" = function(a,b) paste(a,b,sep="")

GHfreq<-fread('allele_freq/METS735_rsid_snpfiltered_GH_allchrs.afreq')
hist(GHfreq$ALT_FREQS)

METfreq<-fread('allele_freq/METS735_rsid_snpfiltered_allchrs.afreq')
hist(METfreq$ALT_FREQS)

USfreq<-fread('allele_freq/METS735_rsid_snpfiltered_US_allchrs.afreq')
hist(USfreq$ALT_FREQS)

JAfreq<-fread('allele_freq/METS735_rsid_snpfiltered_JA_allchrs.afreq')
hist(JAfreq$ALT_FREQS)

SAfreq<-fread('allele_freq/METS735_rsid_snpfiltered_SA_allchrs.afreq')
hist(SAfreq$ALT_FREQS)

afr<-fread('/home/isabelle/PRSCSx/prscsx_out_allAoU_METS756_bim/AoU_scaled_bmi_AFR_pst_eff_a1_b0.5_phi1e-06_chr1.txt')
colnames(afr)<-c('chr','snp','pos','a1','a2','afr')
for(i in 2:22){
  model<-fread('/home/isabelle/PRSCSx/prscsx_out_allAoU_METS756_bim/AoU_scaled_bmi_AFR_pst_eff_a1_b0.5_phi1e-06_chr'%&%i%&%'.txt')
  colnames(model)<-c('chr','snp','pos','a1','a2','afr')
  afr<-rbind(afr,model)
}

amr<-fread('/home/isabelle/PRSCSx/prscsx_out_allAoU_METS756_bim/AoU_scaled_bmi_AMR_pst_eff_a1_b0.5_phi1e-06_chr1.txt')
colnames(amr)<-c('chr','snp','pos','a1','a2','amr')
for(i in 2:22){
  model<-fread('/home/isabelle/PRSCSx/prscsx_out_allAoU_METS756_bim/AoU_scaled_bmi_AMR_pst_eff_a1_b0.5_phi1e-06_chr'%&%i%&%'.txt')
  colnames(model)<-c('chr','snp','pos','a1','a2','amr')
  amr<-rbind(amr,model)
}

eur<-fread('/home/isabelle/PRSCSx/prscsx_out_allAoU_METS756_bim/AoU_scaled_bmi_EUR_pst_eff_a1_b0.5_phi1e-06_chr1.txt')
colnames(eur)<-c('chr','snp','pos','a1','a2','eur')
for(i in 2:22){
  model<-fread('/home/isabelle/PRSCSx/prscsx_out_allAoU_METS756_bim/AoU_scaled_bmi_EUR_pst_eff_a1_b0.5_phi1e-06_chr'%&%i%&%'.txt')
  colnames(model)<-c('chr','snp','pos','a1','a2','eur')
  eur<-rbind(eur,model)
}

models<-full_join(afr,amr)%>%full_join(eur)
GHfreq<-full_join(GHfreq,models,by=c('ID'='snp','#CHROM'='chr'))
JAfreq<-full_join(JAfreq,models,by=c('ID'='snp','#CHROM'='chr'))
SAfreq<-full_join(SAfreq,models,by=c('ID'='snp','#CHROM'='chr'))
USfreq<-full_join(USfreq,models,by=c('ID'='snp','#CHROM'='chr'))

largeGH<-filter(GHfreq,afr>0.01|afr<(-0.01))
plot(largeGH$ALT_FREQS,largeGH$afr)
hist(largeGH$ALT_FREQS)

largeUS<-filter(USfreq,afr>0.01|afr<(-0.01))
plot(largeUS$ALT_FREQS,largeUS$afr)
hist(largeUS$ALT_FREQS)
