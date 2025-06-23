#!/bin/bash

path=/home/isabelle/METS/updatedQC/
plink --bfile ${path}QC0.02/missingness_hwe_steps/05filtered_HWE --check-sex --out ${path}METS_sex-check

#problem samples are the same as those in 04_check_w_quality.html
#grep PROBLEM ${path}METS_sex-check.sexcheck |sort -k2

#remove these samples for now--tell Candice sexes didn't match
grep PROBLEM ${path}METS_sex-check.sexcheck > ${path}METS_sex_mismatches
plink --bfile ${path}QC0.02/missingness_hwe_steps/05filtered_HWE --remove ${path}METS_sex_mismatches \
  --out ${path}bfiles/METS_rm-sex --make-bed
