library(data.table)
library(dplyr)
library(ggplot2)

files<-c('PBMC_AFA_GHspearmancor.txt','PBMC_AFA_USspearmancor.txt','PBMC_AFA-EN_GHspearmancor.txt','PBMC_AFA-EN_USspearmancor.txt','PBMC_AFA_spearmancor.txt','PBMC_EUR_spearmancor.txt','PBMC_AFA-EN_spearmancor.txt','PBMC_EUR-EN_spearmancor.txt','PBMC_EUR_GHspearmancor.txt','PBMC_EUR_USspearmancor.txt','PBMC_EUR-EN_GHspearmancor.txt','PBMC_EUR-EN_USspearmancor.txt')

#identity line would be one gene's predicted with its observed

quantiles<-matrix(ncol=6)
for(file in files){
  cor<-fread(file)
  identity<-c()
  list<-colnames(cor)
  for (gene in list){
    #for WHATEVER REASON it won't let me just en[i,i] so we're doing this
    index<-which(list==gene)
    row<-cor[index,]
    value<-pull(row,gene)
    identity<-append(identity,value)
  }
  q<-quantile(identity,na.rm=T)%>%as.data.frame()%>%t()
  q$file<-file
  quantiles<-rbind(quantiles,q)
}

quantiles<-as.data.frame(quantiles)
quantiles<-quantiles[2:nrow(quantiles),]
colnames(quantiles)<-c('0%','25%','middle','75%','max','file')

model_pop<-c()
model_type<-c()
country<-c()
for(file in quantiles$file){
if (str_detect(file,pattern='EUR')){
  model_pop<-append(model_pop,'EUR')
}else{
  model_pop<-append(model_pop,'AFA')
}

if (str_detect(file,pattern='EN')){
  model_type<-append(model_type,'EN')
}else{
  model_type<-append(model_type,'mashr')
}

if (str_detect(file,pattern='GH')){
  country<-append(country,'GH')
}else if (str_detect(file,pattern='US')){
  country<-append(country,'US')
}else{
  country<-append(country,'all')
}
}

quantiles$model_pop<-model_pop%>%as.character()
quantiles$model_type<-model_type%>%as.character()
quantiles$country<-country%>%as.character()

#fwrite(quantiles,'correlation_quantiles.txt',quote=F,row.names=F)
#hist(identity,breaks=100,main='AFA mashr model, US',xlab='correlation')

quantiles$middle<-as.numeric(quantiles$middle)
quantiles$max<-as.numeric(quantiles$max)
ggplot(filter(quantiles,country=='US'),aes(y=max,x=model_type,fill=model_pop),ylab='middle correlation score',main='spearman for combined countries')+geom_col(position='dodge')+expand_limits(y=1.0)

       