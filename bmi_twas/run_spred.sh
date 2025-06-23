#!/bin/bash

for m in EN mashr
do
for p1 in afr eur amr ALL
do
for p in AFA EUR ALL HIS
do
  python3 /usr/local/bin/MetaXcan_software/SPrediXcan.py \
  --model_db_path /home/daniel/mashr/final_models/PBMC_${p}_${m}_baseline.db \
  --covariance /home/daniel/mashr/final_models/PBMC_${p}_${m}_baseline_covariances.txt.gz \
  --gwas_file /home/isabelle/summary_stats/GWAS_AoU_BMI_${p1}_scaled_bmi.sumstats_snpfixed.txt \
  --snp_column chrpos \
  --effect_allele_column A1 \
  --non_effect_allele_column A2 \
  --beta_column BETA \
  --se_column SE \
  --pvalue_column P \
  --output_file /home/isabelle/summary_stats/aou_bmi_spred/AoU-${p1}-scaled-bmi_${p}-PBMC-${m}-baseline.csv \
  --keep_non_rsid
done
done
done

