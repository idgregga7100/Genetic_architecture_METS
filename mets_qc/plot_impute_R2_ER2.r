cohort = "METS_733"
"%&%" <- function(a, b) paste(a, b, sep="")
date <- Sys.Date()
pdf(file=cohort %&% "_TOPMedImputationserver_" %&% date %&% ".pdf")
for(i in 1:22){
    info <- read.table("vcfs/chr" %&% i %&% ".r2",header=T)
    r2 <- info[,2]
    numsnps <- length(r2)
    goodsnps <- info[info$R2>0.8,]
    numgoodsnps <- dim(goodsnps)[1]
    pctgood <- round(numgoodsnps/numsnps*100,1)
    hist(r2,main=cohort %&% " chr" %&% i %&% " TOPMed Imputationserver MAF>0.001 SNPs\n" %&% numgoodsnps %&% "/" %&% numsnps %&% " (" %&% pctgood %&% "%) SNPs with R2 > 0.8",xlab="R2")
}

    info <- read.table("vcfs/chrX.r2",header=T)
    r2 <- info[,2]
    numsnps <- length(r2)
    goodsnps <- info[info$R2>0.8,]
    numgoodsnps <- dim(goodsnps)[1]
    pctgood <- round(numgoodsnps/numsnps*100,1)
    hist(r2,main=cohort %&% " chrX TOPMed Imputationserver MAF>0.001 SNPs\n" %&% numgoodsnps %&% "/" %&% numsnps %&% " (" %&% pctgood %&% "%) SNPs with R2 > 0.8",xlab="R2")

for(i in 1:22){
    info <- read.table("vcfs/chr" %&% i %&% ".r2",header=T)
    gtsnps <- !is.na(info[,3])
    concord <- info[gtsnps,3]
    numsnps <- length(concord)
    hist(concord,main=cohort %&% " chr" %&% i %&% " concordance of " %&% numsnps %&% " SNPs",xlab="ER2")
}

    info <- read.table("vcfs/chrX.r2",header=T)
    gtsnps <- !is.na(info[,3])
    concord <- info[gtsnps,3]
    numsnps <- length(concord)
    hist(concord,main=cohort %&% " chrX concordance of " %&% numsnps %&% " SNPs",xlab="ER2")
dev.off()
