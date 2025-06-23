#!/bin/bash

for i in {1..22}
do
plink2 --freq --pfile METS735_rsid_snpfiltered_chr${i} --out METS735_rsid_snpfiltered_chr${i}
done

for pop in GH US JA SA
do
for i in {1..22}
do
plink2 --freq --pfile METS735_rsid_snpfiltered_${pop}_chr${i} --out METS735_rsid_snpfiltered_${pop}_chr${i}
done
done
