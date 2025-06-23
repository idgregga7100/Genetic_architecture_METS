#!/bin/bash
#reran on 2023-08-22 with sex info for all samples
#isa note: replicating on 9/1/23
path=/home/isabelle/METS/updatedQC/
~/gwasqc_pipeline/shellscripts/01MissingnessFiltering -b ${path}bfiles/METS_all \
  --geno 0.01 --hwe 1e-6 -o ${path}QC

#Ryan's script is useful for generating callRateDistributions.pdf plots, 
#but will need to filter out indiviuals with a lot of missing data first

#"We recommend to first filter SNPs and individuals based on a relaxed threshold (0.2; >20%), 
#as this will filter out SNPs and individuals with very high levels of missingness. 
#Then a filter with a more stringent threshold can be applied (0.02)."
#from https://onlinelibrary.wiley.com/doi/10.1002/mpr.1608

plink --bfile ${path}bfiles/METS_all --mind 0.2 --geno 0.2 --make-bed --out ${path}bfiles/METS_mind0.2_geno0.2
#keep individuals with >95% called snps
plink --bfile ${path}bfiles/METS_mind0.2_geno0.2 --mind 0.05 --make-bed --out ${path}bfiles/METS_mind0.05

#Ryan's script also filters out maf<0.05, which we want to keep, can change with --maf
#b/c there could be SNPs with maf>0.01 in one pop, but not all 5 AFR pops.
#I used --maf 0.0001 (filters out monomorphic snps) and --geno 0.02 (>98% called per SNP)
~/gwasqc_pipeline/shellscripts/01MissingnessFiltering -b ${path}bfiles/METS_mind0.05 \
  --geno 0.02 --hwe 1e-6 --maf 0.0001 -o ${path}QC0.02
#n=838 people n=507,000 SNPs (lost 60 people) --> Next: check if these were the poor quality samples
