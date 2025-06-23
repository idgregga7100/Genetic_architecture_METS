#!/bin/bash

##filter imputed VCFs and check accuracy plots
vcfdir=/home/wheelerlab3/Data/METS/2023-07-26_Genotypes_UChicago/METS_TOPMed_imputation/METS733_2023/
for i in {1..22}
do
    ## use vcftools to remove variants with MAF<0.001, keep INFO (code from
    ## https://github.com/hwheeler01/ThePlatinumStudy/blob/master/GWAS/09_UMich_imputation.sh)
#    vcftools --gzvcf ${vcfdir}chr${i}.dose.vcf.gz --remove-indels --maf 0.001 --recode --recode-INFO-all --stdout | gzip -c > vcfs/post-imp_chr${i}.dose_maf0.001_rm.indel.recode.vcf.gz
    #pull data of interest (rewrote perl in python)
    python pull_qual_info.py vcfs/post-imp_chr${i}.dose_maf0.001_rm.indel.recode.vcf.gz vcfs/chr${i}.r2
done

#vcftools --gzvcf ${vcfdir}chrX.dose.vcf.gz --remove-indels --maf 0.001 --recode --recode-INFO-all --stdout | gzip -c > vcfs/post-imp_chrX.dose_maf0.001_rm.indel.recode.vcf.gz
python pull_qual_info.py vcfs/post-imp_chrX.dose_maf0.001_rm.indel.recode.vcf.gz vcfs/chrX.r2

##plot R2 "Estimated Imputation Accuracy" and ER2 (concordance) "Empirical (Leave-One-Out) R-square (available only for genotyped variants)"
R --vanilla < plot_impute_R2_ER2.r
