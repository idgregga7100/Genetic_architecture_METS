---
title: "demog_pies"
author: "Isabelle"
date: "2025-06-12"
output: html_document
---

```{r}
library(data.table)
library(dplyr)
library(knitr)
library(ggplot2)
library(wesanderson)
#Darjeeling2 = c("#ECCBAE", "#046C9A", "#D69C4E", "#ABDDDE", "#000000")
```
```{r}
gh<-data.frame(diabetic=c('yes','no'),value=c(8,207))
ja<-data.frame(diabetic=c('yes','no'),value=c(12,160))
sa<-data.frame(diabetic=c('yes','no'),value=c(10,137))
us<-data.frame(diabetic=c('yes','no'),value=c(33,147))

```
```{r}
ggplot(gh,aes(x='',y=value,fill=diabetic))+geom_bar(stat='identity',width=1)+coord_polar('y',start=0)+
  theme_void()+scale_fill_manual(values=c('#faf2ea',"#ECCBAE"))

ggplot(us,aes(x='',y=value,fill=diabetic))+geom_bar(stat='identity',width=1)+coord_polar('y',start=0)+
  theme_void()+scale_fill_manual(values=c('#cdeffe',"#046C9A"))

ggplot(sa,aes(x='',y=value,fill=diabetic))+geom_bar(stat='identity',width=1)+coord_polar('y',start=0)+
  theme_void()+scale_fill_manual(values=c('#faf3ea',"#D69C4E"))

ggplot(ja,aes(x='',y=value,fill=diabetic))+geom_bar(stat='identity',width=1)+coord_polar('y',start=0)+
  theme_void()+scale_fill_manual(values=c('#edf8f8',"#ABDDDE"))
```

```{r}
gh<-data.frame(hypertension=c('yes','no'),value=c(63,152))
ja<-data.frame(hypertension=c('yes','no'),value=c(84,88))
sa<-data.frame(hypertension=c('yes','no'),value=c(76,71))
us<-data.frame(hypertension=c('yes','no'),value=c(117,63))
```
```{r}
ggplot(gh,aes(x='',y=value,fill=hypertension))+geom_bar(stat='identity',width=1)+coord_polar('y',start=0)+
  theme_void()+scale_fill_manual(values=c('#faf2ea',"#ECCBAE"))

ggplot(us,aes(x='',y=value,fill=hypertension))+geom_bar(stat='identity',width=1)+coord_polar('y',start=0)+
  theme_void()+scale_fill_manual(values=c('#cdeffe',"#046C9A"))

ggplot(sa,aes(x='',y=value,fill=hypertension))+geom_bar(stat='identity',width=1)+coord_polar('y',start=0)+
  theme_void()+scale_fill_manual(values=c('#faf3ea',"#D69C4E"))

ggplot(ja,aes(x='',y=value,fill=hypertension))+geom_bar(stat='identity',width=1)+coord_polar('y',start=0)+
  theme_void()+scale_fill_manual(values=c('#edf8f8',"#ABDDDE"))
```

```{r}
gh<-data.frame(obese=c('yes','no'),value=c(62,153))
ja<-data.frame(obese=c('yes','no'),value=c(81,91))
sa<-data.frame(obese=c('yes','no'),value=c(49,98))
us<-data.frame(obese=c('yes','no'),value=c(119,61))
```
```{r}
ggplot(gh,aes(x='',y=value,fill=obese))+geom_bar(stat='identity',width=1)+coord_polar('y',start=0)+
  theme_void()+scale_fill_manual(values=c('#faf2ea',"#ECCBAE"))

ggplot(us,aes(x='',y=value,fill=obese))+geom_bar(stat='identity',width=1)+coord_polar('y',start=0)+
  theme_void()+scale_fill_manual(values=c('#cdeffe',"#046C9A"))

ggplot(sa,aes(x='',y=value,fill=obese))+geom_bar(stat='identity',width=1)+coord_polar('y',start=0)+
  theme_void()+scale_fill_manual(values=c('#faf3ea',"#D69C4E"))

ggplot(ja,aes(x='',y=value,fill=obese))+geom_bar(stat='identity',width=1)+coord_polar('y',start=0)+
  theme_void()+scale_fill_manual(values=c('#edf8f8',"#ABDDDE"))
```

```{r}
age<-data.frame(country=c('GH','JA','SA','US'),sample_size=c(215,172,147,180))

ggplot(age,aes(x='',y=sample_size,fill=country))+geom_bar(stat='identity',width=1)+coord_polar('y',start=0)+
  theme_void()+scale_fill_manual(values=c("#ECCBAE","#ABDDDE","#D69C4E","#046C9A"))
```

```{r}
hdi<-data.frame(country=c('GH','US','SA','JA'),HDI_2010=c(0.571,0.916,0.675,0.711),HDI_2022=c(0.602,0.927,0.717,0.706))

ggplot(hdi,aes(x=country,y=HDI_2010,fill=country))+geom_bar(stat='identity')+
  scale_fill_manual(values=c("#ECCBAE","#ABDDDE","#D69C4E","#046C9A"))+
  labs(title='METS HDI in 2010')+theme_bw(16)

ggplot(hdi,aes(x=country,y=HDI_2022,fill=country))+geom_bar(stat='identity')+
  scale_fill_manual(values=c("#ECCBAE","#ABDDDE","#D69C4E","#046C9A"))+
  labs(title='METS HDI in 2022 (current)')+theme_bw(16)
```

```{r}
hwbmi<-data.frame(country=c('GH','GH','GH','JA','JA','JA','SA','SA','SA','US','US','US'),
                  demographic=c('height','weight','bmi','height','weight','bmi','height','weight','bmi','height','weight','bmi'),
                  mean=c(162,71.2,27.2, 167.4,75.5,28.2, 164.7,75.7,28.2, 166.9,99.1,35.4),
                  std=c(7.62,14.8,5.81, 8.7,19.5,7.04, 8.59,23.2,9.41, 7.35,26.6,9.39))

ggplot(hwbmi,aes(x=demographic,y=mean,fill=country))+geom_bar(stat='identity',position='dodge')+
  geom_errorbar(aes(ymin=mean-std, ymax=mean+std),position=position_dodge(.9),width=.2)+
  scale_fill_manual(values=c("#ECCBAE","#ABDDDE","#D69C4E","#046C9A"))+theme_bw(16)+
  labs(title='METS height (cm), weight (kg), and BMI')
```

```{r}
aou<-data.frame(population=c('eur','amr','afr'),value=c(117545,29574,42982))

ggplot(aou,aes(x='',y=value,fill=population))+geom_bar(stat='identity',width=1)+coord_polar('y',start=0)+
  theme_void()
```

