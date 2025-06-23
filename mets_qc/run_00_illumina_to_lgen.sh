#!/bin/bash

#mydir=/home/wheelerlab3/Data/METS/2023-07-26_Genotypes_UChicago/HWheeler-CCK-GSA24v3-platesA1A2B1B2/Excel_Files/
#Rscript 00_illumina_to_lgen.R --illumina ${mydir}HWheeler-GSA24v3-pltsA1A2B1B2-384s-230721_FinalReport.txt --o HWheeler-GSA24v3-pltsA1A2B1B2-384s-230721

#Error: cons memory exhausted (limit reached?)
#The Rscript didn't work with the 515 samples in the second file, so I wrote a python script:

#mydir=/home/wheelerlab3/Data/METS/2023-07-26_Genotypes_UChicago/HWheeler-CCK-GSA24v3-platesC123456/Excel_Data/
#time python 00_illumina_to_lgen.py --illumina ${mydir}HWheeler-CCK-GSA24v3-platesC123456-Aug07_FinalReport.txt --o HWheeler-CCK-GSA24v3-platesC123456-Aug07

#python only took 13 minutes! rerun first set with python script for consistency:

#mydir=/home/wheelerlab3/Data/METS/2023-07-26_Genotypes_UChicago/HWheeler-CCK-GSA24v3-platesA1A2B1B2/Excel_Files/
#/usr/bin/time -v python 00_illumina_to_lgen.py -i ${mydir}HWheeler-CCK-GSA24v3-pltsA1A2B1B2-384s-230721_FinalReport.txt -o HWheeler-GSA24v3-pltsA1A2B1B2-384s-230721
#10 min, only 121MB RAM

#isa note: not timing this so i can see errors

mydir=/home/wheelerlab3/Data/METS/2023-07-26_Genotypes_UChicago/HWheeler-CCK-GSA24v3-platesA1A2B1B2/Excel_Files/
python 00_illumina_to_lgen.py -i ${mydir}HWheeler-GSA24v3-pltsA1A2B1B2-384s-230721_FinalReport.txt -o /home/isabelle/METS/updatedQC/pltsA1A2B1B2-384s-230721

#mydir=/home/wheelerlab3/Data/METS/2023-07-26_Genotypes_UChicago/HWheeler-CCK-GSA24v3-platesC123456/Excel_Data/
#python 00_illumina_to_lgen.py -i ${mydir}HWheeler-CCK-GSA24v3-platesC123456-Aug07_FinalReport.txt -o /home/isabelle/METS/updatedQC/platesC123456-Aug07
