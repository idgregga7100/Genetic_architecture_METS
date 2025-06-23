#first of all need to get identity line for each, then take only the intersection of the model genes
library(dplyr)
library(stringr)
library(data.table)
"%&%" = function(a,b) paste(a,b,sep="")

files<-c('PBMC_AFA_GHspearmancor.txt','PBMC_AFA_USspearmancor.txt','PBMC_AFA-EN_GHspearmancor.txt',
         'PBMC_AFA-EN_USspearmancor.txt','PBMC_AFA_spearmancor.txt','PBMC_EUR_spearmancor.txt',
         'PBMC_AFA-EN_spearmancor.txt','PBMC_EUR-EN_spearmancor.txt','PBMC_EUR_GHspearmancor.txt',
         'PBMC_EUR_USspearmancor.txt','PBMC_EUR-EN_GHspearmancor.txt','PBMC_EUR-EN_USspearmancor.txt')

gianttable<-data.frame(matrix(ncol=5))
colnames(gianttable)<-c('identity','gene','model_pop','model_type','country')
for(file in files){
  cor<-fread('raw_cor/'%&%file)
  identity<-c()
  list<-colnames(cor)
  for (gene in list){
    #for WHATEVER REASON it won't let me just en[i,i] so we're doing this
    index<-which(list==gene)
    row<-cor[index,]
    value<-pull(row,gene)
    identity<-append(identity,value)
  }
  identity<-as.data.frame(identity)
  identity$gene<-list
  fwrite(identity,'list-'%&%file)
  
  if (str_detect(file,pattern='EUR')){
    identity$model_pop<-rep_len('EUR',nrow(identity))
  }else{
    identity$model_pop<-rep_len('AFA',nrow(identity))
  }
  
  if (str_detect(file,pattern='EN')){
    identity$model_type<-rep_len('EN',nrow(identity))
  }else{
    identity$model_type<-rep_len('mashr',nrow(identity))
  }
  
  if (str_detect(file,pattern='GH')){
    identity$country<-rep_len('GH',nrow(identity))
  }else if (str_detect(file,pattern='US')){
    identity$country<-rep_len('US',nrow(identity))
  }else{
    identity$country<-rep_len('all',nrow(identity))
  }
  gianttable<-rbind(gianttable,identity)
}
fwrite(gianttable,'combined_spearmancor.txt',quote=F,row.names=F)  

eur<-filter(gianttable,model_pop=='EUR')%>%select(gene)%>%unique()
afa<-filter(gianttable,model_pop=='AFA')%>%select(gene)%>%unique()
afaeurlist<-inner_join(eur,afa)

en<-filter(gianttable,model_type=='EN')%>%select(gene)%>%unique()
mashr<-filter(gianttable,model_type=='mashr')%>%select(gene)%>%unique()
enmashrlist<-inner_join(en,mashr)

finallist<-inner_join(afaeurlist,enmashrlist)%>%pull(gene)

filteredtable<-filter(gianttable,gene%in%finallist)
fwrite(filteredtable,'combined_spearmancor_sharedgenes.txt',quote=F,row.names=F)
