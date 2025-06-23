#!/bin/bash
#just need to rerun the last chunk from step 09

path=/home/isabelle/METS/updatedQC
#run with just AFR pops from 1kg
grep AFR /home/wheelerlab3/Data/1000g_phase3_hg38_plink/all_hg38.psam > AFR_hg38.psam
#add 0 as FID to first col
awk '{print 0, $1}' < AFR_hg38.psam > AFR_list
cat AFR_list ${path}/bfiles/METS_rm-hi-ld.fam > keeplist
plink --bfile ${path}/bfiles/METS_1kg_ld-pruned --keep keeplist --pca 10 header --out ${path}/METS_AFR1kg_PCA10

#also try with no ASW just for fun
grep -v ASW AFR_hg38.psam > AFR_noASW.psam
awk '{print 0,$1}' < AFR_noASW.psam > AFR_noASW_list
cat AFR_noASW_list ${path}/bfiles/METS_rm-hi-ld.fam > keeplist
plink --bfile ${path}/bfiles/METS_1kg_ld-pruned --keep keeplist --pca 10 header --out ${path}/METS_AFR1kg_noASW_PCA10
