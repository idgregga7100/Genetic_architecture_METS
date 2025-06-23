#26.5: just the part to make the combined data file for use in 27

library(data.table)
library(tidyverse)
library(dplyr)
#paste function to concatenate filenames/paths
"%&%" = function(a,b) paste(a,b,sep="")

#read in prs, phenotypes, covariates (file made in 25_compare_AoU_PRS_to_observed_mets735_post-imp.Rmd)
mets = fread("/home/isabelle/METS/PRS_tests/METS735_post-imp_PRSCSx_1e+00_AoU_scaled_bmi_scores_and_covariates.txt")
#read in mets PCs
pcs = fread("/home/isabelle/METS/METS735_rsid_snpfiltered_PCAIR_wpops.txt",header=T)
mets = inner_join(mets,pcs,by=join_by('FID'))
table(mets$country_abbr)
dim(mets)

#isa: this is just checking data for outliers
#plot PCs
ggplot(mets,aes(x=PC1,y=PC2,col=country_abbr)) + geom_point() + scale_color_viridis_d()+ theme_bw(16)
ggplot(mets,aes(x=PC3,y=PC4,col=country_abbr)) + geom_point() + scale_color_viridis_d()+ theme_bw(16) #rm outliers?
#plot age distribution by site
ggplot(mets,aes(x=age,fill=country_abbr)) + geom_histogram() + scale_fill_viridis_d() + facet_wrap(~sex)

#filter out PC3>0.25 and PC3< -0.25
#filter out PC4>0.25 and PC4< -0.25
#filter out age>120
mets_rm_outliers = filter(mets,PC3>(-0.25) & PC3<0.25,PC4>(-0.25) & PC4<0.25,age<120 )
ggplot(mets_rm_outliers,aes(x=PC1,y=PC2,col=country_abbr)) + geom_point() + scale_color_viridis_d()+ theme_bw(16)
ggplot(mets_rm_outliers,aes(x=PC3,y=PC4,col=country_abbr)) + geom_point() + scale_color_viridis_d()+ theme_bw(16)
#plot age distribution by site
ggplot(mets_rm_outliers,aes(x=age,fill=country_abbr)) + geom_histogram() + scale_fill_viridis_d() + facet_wrap(~sex)

#test with the outliers and missing age removed
mets = mets_rm_outliers
dim(mets)

#make matrix for new ensemble scores
n=717 #mets sample size (outliers and no-age removed)
p=4 #four AoU validation pops
ens_prs = matrix(nrow=n,ncol=p)

#AoU_scaled_bmi_phi1e-02_popweights_6-3-24.txt
#AoU_validation_popweights_1e-4_6-17-24.txt
#AoU_scaled_bmi_phi1e-06_validation_out_8-24.txt
#AoU_scaled_bmi_phi1e+00_validation_out_8-24.txt
for(i in 1:4){
  #need 1x3 matrix of AoU weights
  
  aou = fread("/home/isabelle/METS/PRS_tests/AoU_scaled_bmi_phi1e+00_validation_out_8-24.txt")
  aou_mat=as.matrix(aou[,-1])
  aou_weights = t(as.matrix(aou_mat[,i])) 
  
  #need 3x714 matrix of mets PRS's for matrix multiplication
  mets_scores = t(as.matrix(select(mets,AFR,AMR,EUR)))
  #multiply each mets PRS by the AoU weight and take the sum 
  # %*% does this via matrix multiplication, makes 1x714 matrix
  new_score = aou_weights %*% mets_scores 
  ens_prs[,i] = new_score
}
colnames(ens_prs) = colnames(aou_mat)
rownames(ens_prs) = mets$FID
head(ens_prs)
#make df to join with mets
ens_prs_df = as.data.frame(ens_prs) |> rownames_to_column("FID")
#make FID character in mets
mets = mutate(mets,FID=as.character(FID))
all_mets = left_join(ens_prs_df,mets,by="FID")

fwrite(all_mets,'/home/isabelle/METS/PRS_tests/newpcair_1e+00_all_mets_data_for_modeling.txt',sep='\t',quote=F,row.names=F)

###
#for indiv pops!!!
###

#read in prs, phenotypes, covariates (file made in 25_compare_AoU_PRS_to_observed_mets735_post-imp.Rmd)
mets = fread("/home/isabelle/METS/PRS_tests/METS735_post-imp_PRSCSx_1e+00_AoU_scaled_bmi_scores_and_covariates.txt")
#read in mets PCs
pcs = fread("/home/isabelle/METS/METS735_rsid_snpfiltered_PCAIR_GH-norel.txt",header=T)
idlist<-fread('/home/isabelle/METS/GH_idlist.txt')
pcs<-inner_join(pcs,idlist,by=c('id'='IID'))
cols<-c("id","PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8","PC9","PC10","PC11","PC12","PC13","PC14","PC15","PC16","PC17","PC18","PC19","PC20","PC21","PC22","PC23","PC24","PC25","PC26","PC27","PC28","PC29","PC30","PC31","PC32","related","FID","SEX")
colnames(pcs)<-cols
mets = inner_join(mets,pcs,by=join_by('FID'))
table(mets$country_abbr)
dim(mets)

#isa: this is just checking data for outliers
#isa again! for indiv pops we're not bothering with outliers
#plot PCs
#ggplot(mets,aes(x=PC1,y=PC2,col=country_abbr)) + geom_point() + scale_color_viridis_d()+ theme_bw(16)
#ggplot(mets,aes(x=PC3,y=PC4,col=country_abbr)) + geom_point() + scale_color_viridis_d()+ theme_bw(16) #rm outliers?
#plot age distribution by site
#ggplot(mets,aes(x=age,fill=country_abbr)) + geom_histogram() + scale_fill_viridis_d() + facet_wrap(~sex)

#GH: PC2>-0.5, PC3>-0.5, age<120
#JA: PC1<-0.3, PC2<-0.3 & >0.3, PC3>-0.5, PC4<0.3
#SA: PC1<0.2, PC2 -2&2, PC3 -2.5&2.5, PC4 -2.5&2.5
#US: PC4 0.3, PC3 -2&2
#filter out PC3>0.25 and PC3< -0.25
#filter out PC4>0.25 and PC4< -0.25
#filter out age>120
mets_rm_outliers = filter(mets,age<120 )
#mets_rm_outliers = filter(mets,PC2>(-0.5),PC3>(-0.5),age<120)
#mets_rm_outliers = filter(mets,PC1>(-0.3),PC2>(-0.3)&PC2<0.3,PC3>(-0.5),PC4<0.3,age<120)
#mets_rm_outliers = filter(mets,PC1<0.2,PC2>(-0.2)&PC2<0.2,PC3>(-0.25)&PC3<0.25,PC4>(-0.25)&PC4<0.25,age<120)
#mets_rm_outliers = filter(mets,PC3>(-0.2)&PC3<0.2,PC4<0.3,age<120)
#ggplot(mets_rm_outliers,aes(x=PC1,y=PC2,col=country_abbr)) + geom_point() + scale_color_viridis_d()+ theme_bw(16)
#ggplot(mets_rm_outliers,aes(x=PC3,y=PC4,col=country_abbr)) + geom_point() + scale_color_viridis_d()+ theme_bw(16)
#plot age distribution by site
#ggplot(mets_rm_outliers,aes(x=age,fill=country_abbr)) + geom_histogram() + scale_fill_viridis_d() + facet_wrap(~sex)

#test with the outliers and missing age removed
mets = mets_rm_outliers
dim(mets)

#make matrix for new ensemble scores
n=141 #mets sample size (outliers and no-age removed)
p=4 #four AoU validation pops
ens_prs = matrix(nrow=n,ncol=p)

#AoU_scaled_bmi_phi1e-02_popweights_6-3-24.txt
#AoU_validation_popweights_1e-4_6-17-24.txt
#AoU_scaled_bmi_phi1e-06_validation_out_8-24.txt
#AoU_scaled_bmi_phi1e+00_validation_out_8-24.txt
for(i in 1:4){
  #need 1x3 matrix of AoU weights
  
  aou = fread("/home/isabelle/METS/PRS_tests/AoU_scaled_bmi_phi1e+00_validation_out_8-24.txt")
  aou_mat=as.matrix(aou[,-1])
  aou_weights = t(as.matrix(aou_mat[,i])) 
  
  #need 3x714 matrix of mets PRS's for matrix multiplication
  mets_scores = t(as.matrix(select(mets,AFR,AMR,EUR)))
  #multiply each mets PRS by the AoU weight and take the sum 
  # %*% does this via matrix multiplication, makes 1x714 matrix
  new_score = aou_weights %*% mets_scores 
  ens_prs[,i] = new_score
}
colnames(ens_prs) = colnames(aou_mat)
rownames(ens_prs) = mets$FID
head(ens_prs)
#make df to join with mets
ens_prs_df = as.data.frame(ens_prs) |> rownames_to_column("FID")
#make FID character in mets
mets = mutate(mets,FID=as.character(FID))
all_mets = left_join(ens_prs_df,mets,by="FID")

fwrite(all_mets,'/home/isabelle/METS/PRS_tests/newpcairGH_1e+00_all_mets_data_for_modeling-norel.txt',sep='\t',quote=F,row.names=F)

gh<-fread('/home/isabelle/METS/PRS_tests/newpcairGH_1e+00_all_mets_data_for_modeling-norel.txt')
ja<-fread('/home/isabelle/METS/PRS_tests/newpcairJA_1e+00_all_mets_data_for_modeling.txt')
sa<-fread('/home/isabelle/METS/PRS_tests/newpcairSA_1e+00_all_mets_data_for_modeling.txt')
us<-fread('/home/isabelle/METS/PRS_tests/newpcairUS_1e+00_all_mets_data_for_modeling.txt')

gh<-gh%>%mutate(country='GH')
ja<-ja%>%mutate(country='JA')
sa<-sa%>%mutate(country='SA')
us<-us%>%mutate(country='US')
pops<-rbind(gh,ja)%>%rbind(sa)%>%rbind(us)

fwrite(pops,'/home/isabelle/METS/PRS_tests/newpcairALL_1e+00_all_mets_data_for_modeling-noghrel.txt',sep='\t',quote=F,row.names=F)

#ggplot(pops,aes(x=PC1,y=PC2,col=country)) + geom_point() + scale_color_viridis_d()+ theme_bw(16)
#ggplot(pops,aes(x=PC3,y=PC4,col=country)) + geom_point() + scale_color_viridis_d()+ theme_bw(16)
#okay nevermind this actually is useless to look at bcuz it's not the pops relative to each other it just looks like mardi gras sprinkles
