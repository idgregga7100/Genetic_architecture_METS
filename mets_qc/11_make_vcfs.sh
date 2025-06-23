#!/bin/bash

#From https://imputation.biodatacatalyst.nhlbi.nih.gov/#!run/imputationserver%401.7.3
#If your input data is GRCh38hg38 please ensure chromosomes are encoded with prefix 'chr' (e.g. chr20).  

#https://imputationserver.readthedocs.io/en/latest/prepare-your-data/
#Michigan Imputation Server accepts VCF files compressed with bgzip. Please make sure the following requirements are met:

#Create a separate vcf.gz file for each chromosome.
#Variations must be sorted by genomic position.
#GRCh37 or GRCh38 coordinates are required.

plink2 --bfile METS_rm-dups --chr 1-22,X --output-chr chrM --make-bed --out METS_chr1-22_X
#Note: the vcfs still have 1 rather than chr1, above step didn't help.
#But, if you add --output-chr chrM to the --recode vcf command, get correct format for hg38
for i in {1..22}
do
  plink --bfile METS_chr1-22_X --recode vcf --chr $i --output-chr chrM --out vcfs/METS_733_chr${i}
  bgzip vcfs/METS_733_chr${i}.vcf
done

plink --bfile METS_chr1-22_X --recode vcf --chr X --output-chr chrM --out vcfs/METS_733_chrX
bgzip vcfs/METS_733_chrX.vcf

#I tried QC on the topmed imputation server, but got the following error:
#Error: More than 10000 obvious strand flips have been detected. Please check strand. Imputation cannot be started!

#downloaded files on Results tab in vcfs/
wget https://imputation.biodatacatalyst.nhlbi.nih.gov/share/results/b1f49d24d92f0e04a16360276552cefc920c7c770ea1f0870381d26e6e1f2e7f/chunks-excluded.txt
wget https://imputation.biodatacatalyst.nhlbi.nih.gov/share/results/67a44ce40f37bf4f5420f7d9860ec246f729c34e5a720bcc3700d2279a081ebc/snps-excluded.txt
wget https://imputation.biodatacatalyst.nhlbi.nih.gov/share/results/62df920ab0eacecefba4111c176d71c52d2c6767048f6ce0caf693e2ae802d14/typed-only.txt

#make a list of strand flips to fix
grep 'Strand flip' vcfs/snps-excluded.txt | cut -f 1 > strand_flips
#make a list of duplicates to remove
grep Duplicate vcfs/snps-excluded.txt | cut -f 1 > duplicates

#recode plink snp IDs as chr:pos:ref:alt, then rm dup snps, flip alleles and regenerate vcfs
plink2 --bfile METS_chr1-22_X --set-all-var-ids 'chr'@:#:\$r:\$a --make-bed --out METS_chr1-22_X_chr.pos.ref.alt
plink --bfile METS_chr1-22_X_chr.pos.ref.alt --exclude duplicates --make-bed --out METS_chr1-22_X_chr.pos.ref.alt_rm-dupsnps
#flip alleles (--snps-only just-acgt removes a few in-dels, including duplicate indels
plink --bfile METS_chr1-22_X_chr.pos.ref.alt_rm-dupsnps --flip strand_flips --make-bed --out METS_chr1-22_X_fix-flips --snps-only just-acgt
#remake vcfs
rm vcfs/*vcf*
for i in {1..22}
do
  plink --bfile METS_chr1-22_X_fix-flips --recode vcf --chr $i --output-chr chrM --out vcfs/METS_733_chr${i}
  bgzip vcfs/METS_733_chr${i}.vcf
done

plink --bfile METS_chr1-22_X_fix-flips --recode vcf --chr X --output-chr chrM --out vcfs/METS_733_chrX
bgzip vcfs/METS_733_chrX.vcf

#I uploaded the *vcf.gz files to the TOPMed server and QC was sucessful with one warning:
Excluded sites in total: 1,643
Remaining sites in total: 486,468
See snps-excluded.txt for details
Typed only sites: 15,906
See typed-only.txt for details

Warning: 1 Chunk(s) excluded: reference overlap < 50.0% (see chunks-excluded.txt for details).
Remaining chunk(s): 307


Quality Control (Report)
Execution successful.

#NEXT: move foward with phasing and imputation.
