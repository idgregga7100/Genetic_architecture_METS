#!/bin/bash

path=/home/isabelle/METS/updatedQC/
#Run Ryan's 02RelatednessFiltering script, check plots and .genome for expected duplicates
#see https://github.com/WheelerLab/gwasqc_pipeline/wiki/02RelatednessFiltering
~/gwasqc_pipeline/shellscripts/02RelatednessFiltering -b ${path}bfiles/METS_rm-sex -o ${path}QC0.02 
#Note, I fixed paths to Rscripts in 02RelatednessFiltering (replaced ~ with .)
#also, only want common SNPs for IBD calcs, so I added a --maf 0.05 flag to ld-prune plink commands
#this makes the ibd.png plot look much better (no parallel diagonal lines)

#Note: no -rel flag ensures no duplicates are removed yet, need to analyze in 07_check_ibd_dups.Rmd

#I also made a new pi_hat (kinship coefficient) plot, plotting just pi_hat>0.05,
#by editing ./gwasqc_pipeline/Rscripts/ibd.R
#similar to https://pubmed.ncbi.nlm.nih.gov/21234875/#&gid=article-figures&pid=figure-5-uid-4
#possible relationships: https://github.com/WheelerLab/GWAS_QC/blob/master/example_pipelines/QC%20Analysis%20-%20Cox%20Lab%20Projects.pdf

#several relatives, but we want to keep all data for testing PRSs
#will need to use KING for PCA in GWAS, etc.

#Next: check that dups are known dups and check that relatives are from same site

