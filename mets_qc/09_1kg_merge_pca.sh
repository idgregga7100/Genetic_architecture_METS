#!/bin/bash

path=/home/isabelle/METS/updatedQC
#make SNP ids chr:pos:ref:alt to match 1kg structure
plink2 --bfile ${path}/bfiles/METS_rm-dups --set-all-var-ids @:#:\$r:\$a --make-bed --out ${path}/bfiles/METS_chr.pos.ref.alt

#try merge
plink \
  --bfile ${path}/bfiles/METS_chr.pos.ref.alt \
  --bmerge /home/wheelerlab3/Data/1000g_phase3_hg38_plink/hg38_unrelated \
  --make-bed \
  --out ${path}/bfiles/test_bmerge

#merge worked, only want to keep SNPs present in both METS and 1kg
plink --bfile ${path}/bfiles/test_bmerge --geno 0.02 --make-bed --out ${path}/bfiles/METS_1kg_merge

#then remove HLA and other high LD regions and LD prune for PCA
# https://genome.sph.umich.edu/wiki/Regions_of_high_linkage_disequilibrium_(LD)
#isa note: high-ld-hg38.txt gotten from DrW
plink --bfile ${path}/bfiles/METS_1kg_merge --make-set /home/wheelerlab3/2023-08-14_METS_genotype_QC/high-ld-hg38.txt --write-set --out ${path}/hi-ld
plink --bfile ${path}/bfiles/METS_1kg_merge --exclude ${path}/hi-ld.set --make-bed --out ${path}/bfiles/METS_1kg_rm-hi-ld

#ld prune
plink --bfile ${path}/bfiles/METS_1kg_rm-hi-ld --indep-pairwise 500 50 0.1 --out ${path}/METS_1kg --chr 1-22
plink --bfile ${path}/bfiles/METS_1kg_rm-hi-ld --extract ${path}/METS_1kg.prune.in --make-bed --out ${path}/bfiles/METS_1kg_ld-pruned

#run pca (will need to do with PCAir later, this is just for pop QC)
plink --bfile ${path}/bfiles/METS_1kg_ld-pruned --pca 10 header --out ${path}/METS_1kg_PCA10

#also run PCA in non-merged METS
plink --bfile ${path}/bfiles/METS_rm-dups --make-set /home/wheelerlab3/2023-08-14_METS_genotype_QC/high-ld-hg38.txt --write-set --out ${path}/hi-ld-mets-only
plink --bfile ${path}/bfiles/METS_rm-dups --exclude ${path}/hi-ld-mets-only.set --make-bed --out ${path}/bfiles/METS_rm-hi-ld
plink --bfile ${path}/bfiles/METS_rm-hi-ld --indep-pairwise 500 50 0.1 --out ${path}/METS-only --chr 1-22
plink --bfile ${path}/bfiles/METS_rm-hi-ld --extract ${path}/METS-only.prune.in --make-bed --out ${path}/bfiles/METS_ld-pruned
plink --bfile ${path}/bfiles/METS_ld-pruned --pca 10 header --out ${path}/METS_PCA10

#also run with just AFR pops from 1kg
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
#Next: plot PCs in 10_plot_pca.Rmd
