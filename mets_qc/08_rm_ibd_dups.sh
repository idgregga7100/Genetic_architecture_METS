#!/bin/bash

#remove one of duplicates and cases with non-dupliate METS IDs, but PI_HAT~1
#confirmation of identical twins or individual with more than one METS ID could a few samples back in

path=/home/isabelle/METS/updatedQC
plink --bfile ${path}/bfiles/METS_rm-sex --remove ${path}/QC0.02/plots_stats/METS_dups_and_pihat1_list.txt --make-bed --out ${path}/bfiles/METS_rm-dups
