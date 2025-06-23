#correlation to measure prediction accuracy
#predict.py output, mesa predicted mets
#/home/isabelle/METS/MESA_predixcan/predict_out/PBMC_AFA_mashr_baseline_METS77_predict.txt
#paul's processed mets expression files, 10pcs 10peer
#/home/paul/mets_expression/peer/METS_age_F_only_king_10PCS_QN_RN_expression10_peer_factor_adjusted.txt

library(dplyr)
library(data.table)
library(stringr)

observed<-fread('/home/paul/mets_expression/peer/METS_age_F_only_king_10PCS_QN_RN_expression10_peer_factor_adjusted.txt',header=T)

predicted<-fread('/home/isabelle/METS/MESA_predixcan/predict_out/PBMC_EUR_mashr_baseline_METS77_predict.txt',header=T)
#formatting to match paul's 
flipped<-t(predicted)%>%as.data.frame()
colnames(flipped)<-flipped[1,]
flipped<-flipped[3:nrow(flipped),]
gene_id<-row.names(flipped)%>%as.data.frame()
colnames(gene_id)<-c('gene_id')
predfixed<-cbind(gene_id,flipped)

#by eye i just noticed paul's doesn't have data for id LD4
predfixed<-select(predfixed, -'1310_LD4')
#okay so now all the cols are in the same order and matched up
#sort rows by gene_id
predfixed<-arrange(predfixed,gene_id)
observed<-arrange(observed,gene_id)

#getting rows (genes) matched and in the same order
#splitting off ver no from ensg in paul's file
observed$gene_id<-str_split_fixed(observed$gene_id,'\\.',n=2)[,1]

#filter down observed bcuz way more genes than predicted
genelist<-pull(gene_id)
observedfilt<-filter(observed, gene_id%in%genelist)
#and vice versa i guess
genelist<-pull(observed,gene_id)
predfixed<-filter(predfixed,gene_id%in%genelist)
#okay NOW they match fully, remove geneid col
genekey<-pull(observedfilt, gene_id)
observedfilt<-select(observedfilt, -gene_id)
predfixed<-select(predfixed, -gene_id)
#for ghanian/american individuals
ids<-colnames(predfixed)
gh<-c()
for (id in ids){
  a<-str_sub(id, start=0,end=1)
  if (a=='3'){
    gh<-append(gh,id)
  }
}

predictedgh<-select(predfixed,all_of(gh))
predictedus<-select(predfixed,-all_of(gh))

ghld<-str_split_fixed(gh,pattern='_',n=2)[,2]
ghid<-paste(ghld,ghld,sep='_')

observedgh<-select(observedfilt,all_of(ghid))
observedus<-select(observedfilt,-all_of(ghid))

#correlation for all individuals
observedfilt<-sapply(observedfilt,as.numeric)%>%t()
#testo<-observedfilt[1:10,1:10]%>%t()
predfixed<-sapply(predfixed,as.numeric)%>%t()
#testp<-predfixed[1:10,1:10]%>%t()
#correlation
#spearmantest<-cor(testo,testp, method='spearman')
spearman<-cor(observedfilt,predfixed,method='spearman')
colnames(spearman)<-genekey
rownames(spearman)<-genekey

fwrite(spearman,'/home/isabelle/METS/MESA_predixcan/PBMC_EUR_spearmancor.txt',row.names=F,quote=F,sep='\t')


#correlation for ghanian/american
observedgh<-sapply(observedgh,as.numeric)%>%t()
observedus<-sapply(observedus,as.numeric)%>%t()
predictedus<-sapply(predictedus,as.numeric)%>%t()
predictedgh<-sapply(predictedgh,as.numeric)%>%t()

spearmangh<-cor(observedgh,predictedgh,method='spearman')
colnames(spearmangh)<-genekey
rownames(spearmangh)<-genekey
spearmanus<-cor(observedus,predictedus,method='spearman')
colnames(spearmanus)<-genekey
rownames(spearmanus)<-genekey

fwrite(spearmangh,'/home/isabelle/METS/MESA_predixcan/PBMC_EUR_GHspearmancor.txt',row.names=F,quote=F,sep='\t')
fwrite(spearmanus,'/home/isabelle/METS/MESA_predixcan/PBMC_EUR_USspearmancor.txt',row.names=F,quote=F,sep='\t')
