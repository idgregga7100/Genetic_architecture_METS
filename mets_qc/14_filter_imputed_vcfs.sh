#!/bin/bash

for i in {1..22}
do
    ## use bcftools to remove variants with R2<=0.8
    bcftools view -i 'R2>0.8' vcfs/post-imp_chr${i}.dose_maf0.001_rm.indel.recode.vcf.gz |bgzip -c >vcfs/post-imp_METS733_chr${i}_maf001_r2_8.vcf.gz
done

bcftools view -i 'R2>0.8' vcfs/post-imp_chrX.dose_maf0.001_rm.indel.recode.vcf.gz |bgzip -c >vcfs/post-imp_METS733_chrX_maf001_r2_8.vcf.gz
