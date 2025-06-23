library(dplyr)
library(ggplot2)
library(data.table)
library(wesanderson)
"%&%" = function(a,b) paste(a,b,sep="")

data<-fread('combined_spearmancor_sharedgenes.txt')

#a<-filter(data,country=='all',model_type=='mashr',model_pop=='EUR')%>%select(identity,gene)
#b<-filter(data,country=='all',model_type=='EN',model_pop=='EUR')%>%select(identity,gene)
#xyset<-inner_join(a,b,by='gene')

#ggplot(xyset,aes(x=identity.x,y=identity.y))+geom_point()+geom_abline(slope=1,intercept=0,colour='red')+
#labs(x='mashr',y='EN',title='EUR Model, US+GH')+stat_smooth(method = "lm",formula = y ~ x,geom = "smooth")

#everything all at once
ggplot(data,aes(x=country,y=identity,fill=model_pop))+geom_violin(draw_quantiles = .5)+
  facet_wrap(factor(vars(model_type)))+scale_fill_manual(values=wes_palette('FantasticFox1',2,type='discrete'))+
  labs(y='correlation')+theme_bw()
  #scale_fill_viridis_d()

#without combined group
data1<-filter(data,country!='all')
ggplot(data1,aes(x=country,y=identity,fill=model_pop))+geom_violin(draw_quantiles = .5)+
  facet_wrap(vars(model_type))+scale_fill_manual(values=wes_palette('Darjeeling2',2,type='discrete'))+
  labs(y='correlation')+theme_bw(16)

##mashr only
data2<-filter(data1,model_type=='mashr')
ggplot(data2,aes(x=country,y=identity,fill=model_pop))+geom_violin(draw_quantiles = .5)+
  scale_fill_manual(values=wes_palette('Darjeeling2',2,type='discrete'))+
  labs(y='correlation',title='Gene expression prediction vs observed \n correlations, mashr models',fill='model\npopulation')+
  theme_bw(16)

##en only
data3<-filter(data1,model_type=='EN')
ggplot(data3,aes(x=country,y=identity,fill=model_pop))+geom_violin(draw_quantiles = .5)+
  scale_fill_manual(values=wes_palette('Darjeeling2',2,type='discrete'))+
  labs(y='correlation',title='Gene expression prediction vs observed \n correlations, EN models',fill='model\npopulation')+
  theme_bw(16)

##afa model, mashr only
data4<-filter(data1,model_pop=='AFA',model_type=='mashr')
ggplot(data4,aes(x=country,y=identity,fill=country))+geom_violin(draw_quantiles = .5)+
  scale_fill_manual(values=wes_palette('Darjeeling2',2,type='discrete'))+
  labs(y='correlation',title='Gene expression prediction vs observed \n correlations, AFA-mashr model')+theme_bw(16)

##afa model, en only
data5<-filter(data1,model_pop=='AFA',model_type=='EN')
ggplot(data5,aes(x=country,y=identity,fill=country))+geom_violin(draw_quantiles = .5)+
  scale_fill_manual(values=wes_palette('Darjeeling2',2,type='discrete'))+
  labs(y='correlation',title='Gene expression prediction vs observed \n correlations, AFA-EN model')+theme_bw(16)

#ttests, difference between means
#for mashr-only plot, gh, eur/afa
afaghmashr<-filter(data2,model_pop=='AFA',country=='GH')%>%pull(identity)
eurghmashr<-filter(data2,model_pop=='EUR',country=='GH')%>%pull(identity)
t.test(afaghmashr,eurghmashr,mu=0)
#for mashr-only, us, eur/afa
afausmashr<-filter(data2,model_pop=='AFA',country=='US')%>%pull(identity)
eurusmashr<-filter(data2,model_pop=='EUR',country=='US')%>%pull(identity)
t.test(afaghmashr,eurghmashr,mu=0)

#for en-only plot, gh, eur/afa
afaghen<-filter(data3,model_pop=='AFA',country=='GH')%>%pull(identity)
eurghen<-filter(data3,model_pop=='EUR',country=='GH')%>%pull(identity)
t.test(afaghmashr,eurghmashr,mu=0)
#for en-only, us, eur/afa
afausen<-filter(data3,model_pop=='AFA',country=='US')%>%pull(identity)
eurusen<-filter(data3,model_pop=='EUR',country=='US')%>%pull(identity)
t.test(afaghmashr,eurghmashr,mu=0)

#for afa mashr only, gh/us
afamashrgh<-filter(data4,country=='GH')%>%pull(identity)
afamashrus<-filter(data4,country=='US')%>%pull(identity)
t.test(afamashrgh,afamashrus,mu=0)

#for afa en only, gh/us
afamashrgh<-filter(data5,country=='GH')%>%pull(identity)
afamashrus<-filter(data5,country=='US')%>%pull(identity)
t.test(afamashrgh,afamashrus,mu=0)

#for eur mashr only gh/us
data6<-filter(data1,model_pop=='EUR',model_type=='mashr')
ggplot(data6,aes(x=country,y=identity,fill=country))+geom_violin(draw_quantiles = .5)+
  scale_fill_manual(values=wes_palette('Darjeeling2',2,type='discrete'))+
  labs(y='correlation')+theme_bw(16)
eurmashrgh<-filter(data6,country=='GH')%>%pull(identity)
eurmashrus<-filter(data6,country=='US')%>%pull(identity)
t.test(eurmashrgh,eurmashrus,mu=0)

#for eur en only gh/us
data7<-filter(data1,model_pop=='EUR',model_type=='EN')
ggplot(data7,aes(x=country,y=identity,fill=country))+geom_violin(draw_quantiles = .5)+
  scale_fill_manual(values=wes_palette('Darjeeling2',2,type='discrete'))+
  labs(y='correlation')+theme_bw(16)
eurengh<-filter(data7,country=='GH')%>%pull(identity)
eurenus<-filter(data7,country=='US')%>%pull(identity)
t.test(eurengh,eurenus,mu=0)


##within afa, does afa en outperform afa mashr, for gh and for us?
data8<-filter(data,model_pop=='AFA',country=='US')
en<-filter(data8,model_type=='EN')%>%pull(identity)
mashr<-filter(data8,model_type=='mashr')%>%pull(identity)
t.test(en,mashr,mu=0)

data9<-filter(data,model_pop=='AFA',country=='GH')
en<-filter(data9,model_type=='EN')%>%pull(identity)
mashr<-filter(data9,model_type=='mashr')%>%pull(identity)
t.test(en,mashr,mu=0)

dataafa<-filter(data,model_pop=='AFA',country!='all')
ggplot(dataafa,aes(x=country,y=identity,fill=model_type))+geom_violin(draw_quantiles = .5)+
  scale_fill_manual(values=wes_palette('Darjeeling2',2,type='discrete'))+
  labs(y='correlation',title='Gene expression performance comparing \nAFA-EN vs AFA-mashr',fill='model\ntype')+theme_bw(16)
