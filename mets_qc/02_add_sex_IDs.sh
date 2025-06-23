#!/bin/bash

path=/home/isabelle/METS/updatedQC/bfiles/
#first merge files
plink --bfile ${path}pltsA1A2B1B2-384s-230721 --bmerge ${path}platesC123456-Aug07.bed ${path}platesC123456-Aug07.bim ${path}platesC123456-Aug07.fam --make-bed --out ${path}METS_merge

#then update FID IID to mets_id plate_id, and remove empty id
plink --bfile ${path}METS_merge --keep /home/wheelerlab3/2023-08-14_METS_genotype_QC/FID_IID_METS_id.txt --make-bed --out ${path}METS_mergekeep
plink --bfile ${path}METS_mergekeep --update-ids /home/wheelerlab3/2023-08-14_METS_genotype_QC/FID_IID_METS_id.txt --make-bed --out ${path}METS_mergeid

#then add sex if available, see make_pheno_file.R
#got updated sexes from Candice on 2023-08-22, made new phenophile by hand in excel, use now
plink --bfile ${path}METS_mergeid --update-sex /home/wheelerlab3/2023-08-14_METS_genotype_QC/METS_phenofile_2023-08-22.txt 5 --make-bed --out ${path}METS_all

