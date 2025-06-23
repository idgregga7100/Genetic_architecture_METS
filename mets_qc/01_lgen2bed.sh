#!/bin/bash

#convert lgen to ped/map
#plink --lfile HWheeler-GSA24v3-pltsA1A2B1B2-384s-230721 --recode --out METS_384
path=/home/isabelle/METS/updatedQC/
plink --lfile /home/isabelle/METS/updatedQC/pltsA1A2B1B2-384s-230721 --recode --out ${path}pltsA1A2B1B2-384s-230721
#plink --lfile /home/isabelle/METS/updatedQC/platesC123456-Aug07 --recode --out ${path}platesC123456-Aug07

#convert ped/map to bed/bim/fam
plink --file ${path}pltsA1A2B1B2-384s-230721 --make-bed --out ${path}bfiles/pltsA1A2B1B2-384s-230721
#plink --file ${path}platesC123456-Aug07 --make-bed --out ${path}bfiles/platesC123456-Aug07
