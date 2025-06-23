#doesn't work with >384 samples, too much memory (>300GB) required, rewrite in Python.

library(dplyr)
library(tidyr)
library(argparse)
library(data.table)

parser <- ArgumentParser()
parser$add_argument("--illumina", help="file path of the illumina FinalReport.txt")
parser$add_argument("-o", "--out", help="Use as in plink. Out is output prefix including full path and no file type extensions.")
parser$add_argument("--skip", help="number of lines that preceed the header in input file. Default is 9", type="integer", default=9)
args <- parser$parse_args()

#Process the final report.txt. Assumes that there are 9 header lines
Finalreport<-as.data.frame(fread(file=args$illumina, sep='\t', skip = args$skip, header = T))
#Finalreport<-as.data.frame(fread(file="test_FinalReport.txt", sep='\t', skip = 9, header = T)) #for testing 
Finalreport<-filter(Finalreport, `Allele1 - Forward` != 'I')
Finalreport["empty"]="0" #place holder for cM column in .map file
Finalreport['fid']<-Finalreport$`Sample ID`

#looking at positions in HWheeler-GSA24v3-pltsA1A2B1B2-384s-230721_SNP_Map.txt
#the Name column (1:103380393) is GRCh37/hg19 assembly or the rsid or other id (PGx, exm, etc.)
#the Chromosome (1) and Position (102914837) columns are GRCh38/hg38 assembly
#look up rs577266494 in http://genome.ucsc.edu/cgi-bin/hgGateway for example

#create map df
map<-select(Finalreport, Chr, `SNP Name`, empty, Position)
map<-map[!duplicated(map),]
map<-map[complete.cases(map),]

#create lgen df
lgen<-select(Finalreport, fid, `Sample ID`, `SNP Name`, `Allele1 - Forward`, `Allele2 - Forward`)
lgen<-lgen[!duplicated(lgen),]
lgen<-lgen[complete.cases(lgen),]
lgen<-filter(lgen, `Allele1 - Forward` != "-" & `Allele2 - Forward` != "-")

#create fam df
## Note: I'll need to add sex after making bed/bim/fam
## Also, replace `Sample ID` plate number with the METS sample ID in the plate map
fam<-select(Finalreport, fid, `Sample ID`, empty)
fam<-mutate(fam,mid=empty,sex=empty,pheno=empty)
fam<-fam[!duplicated(fam),] #only list each person once in .fam


#write to file
fwrite(map, file = paste(args$out, ".map",sep=""), sep = "\t", col.names = F, row.names = F, quote = F)
fwrite(fam, file = paste(args$out, ".fam",sep=""), sep = "\t", col.names = F, row.names = F, quote = F)
fwrite(lgen, file = paste(args$out,".lgen",sep=""), sep = "\t", col.names = F, row.names = F, quote = F)
