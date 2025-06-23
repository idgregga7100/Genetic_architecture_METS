#!/bin/bash

#runs Predict.py from metaxcan to predict expression levels, will compare to measured rna data
types='Mono PBMC'
pops='AFA EUR'

for type in $types
do
for pop in $pops
do
echo $type $pop
python3 /usr/local/bin/MetaXcan_software/Predict.py \
--model_db_snp_key varID \
--model_db_path /home/isabelle/METS/MESA_predixcan/${type}_${pop}_EN_baseline.db \
--vcf_genotypes /home/wheelerlab3/2023-08-14_METS_genotype_QC/2023-08-24_merge_w_METS-2018/vcfs/post-imp_METS77_chr*_maf001_r2_8.vcf.gz \
--vcf_mode imputed \
--prediction_output /home/isabelle/METS/MESA_predixcan/predict_out/${type}_${pop}_EN_baseline_METS77_predict.txt \
--prediction_summary_output /home/isabelle/METS/MESA_predixcan/predict_out/${type}_${pop}_EN_baseline_METS77_summary.txt 
done
done
