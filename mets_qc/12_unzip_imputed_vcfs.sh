#!/bin/bash

## first download imputed files using wget paths on Results tab on TOPMed Imputation Server
## Note: I downloaded in /home/wheelerlab3/Data/METS/2023-07-26_Genotypes_UChicago/METS_TOPMed_imputation/METS733_2023/
#wget https://imputation.biodatacatalyst.nhlbi.nih.gov/share/results/1cadcff1707bb017b54f133297c93a4587d0eecdb8038a27f21ffc1d99e0dad8/chr_1.zip
#wget https://imputation.biodatacatalyst.nhlbi.nih.gov/share/results/82bef0d0ded0fdc3bebba41ad063e273668c4b791c43e17f46fa7da80478be60/chr_10.zip
#wget https://imputation.biodatacatalyst.nhlbi.nih.gov/share/results/2aed8288b84f5b5f45e0f3fc82e48dc1357c419e4d36a64bd8f2f19571f96165/chr_11.zip
#wget https://imputation.biodatacatalyst.nhlbi.nih.gov/share/results/2ca29265bbb9ebc52ada46ef82487960c0a432308172288ffd4b15aacb2dd524/chr_12.zip
#wget https://imputation.biodatacatalyst.nhlbi.nih.gov/share/results/5f4f74f2fea7505c9a3ed7cfaa2a471c19f6a1272ee7efd36cc31fe8c295095c/chr_13.zip
#wget https://imputation.biodatacatalyst.nhlbi.nih.gov/share/results/7b850ac30d8fc0826288a886cb8760160a0c4437bd6eb9632b9039e42e22b709/chr_14.zip
#wget https://imputation.biodatacatalyst.nhlbi.nih.gov/share/results/99a11cba7c2e93db23a074ee68be68b425fd06880f2148bfdcc89dbf3b880b1b/chr_15.zip
#wget https://imputation.biodatacatalyst.nhlbi.nih.gov/share/results/47161f65b81b4d88e35bccb35368508321ea8ee8034306e10d999eb906108d7f/chr_16.zip
#wget https://imputation.biodatacatalyst.nhlbi.nih.gov/share/results/39a7974ab09cd6ca50d06484344538de5ce72ad1e8447acc209607ce60f6d7a9/chr_17.zip
#wget https://imputation.biodatacatalyst.nhlbi.nih.gov/share/results/4238ceb3f484cbcb9ebb758538c283f4412da91fab47108272a7da2647c83296/chr_18.zip
#wget https://imputation.biodatacatalyst.nhlbi.nih.gov/share/results/c7df40d953a838288b43f4d7f6dcf9a7de82b046fd36c8501f240d24d422580a/chr_19.zip
#wget https://imputation.biodatacatalyst.nhlbi.nih.gov/share/results/46bc6fcf5f6a79adb3f6f64f2a952402d51a371b4e81b2b7605d1641b89c6d05/chr_2.zip
#wget https://imputation.biodatacatalyst.nhlbi.nih.gov/share/results/6ff9d1ce40c575c449d5e8a654a4ce5b9403eca571c46c4a9c0cb80fff650a56/chr_20.zip
#wget https://imputation.biodatacatalyst.nhlbi.nih.gov/share/results/96ac3457265900c1dc1643af4dde0264943a81768199b04d69185572b6bd7afe/chr_21.zip
#wget https://imputation.biodatacatalyst.nhlbi.nih.gov/share/results/9cbc0f0f92865ee575fa679e5c137b0f8e2fd5052b17ba392b9d73f2bdfa91e5/chr_22.zip
#wget https://imputation.biodatacatalyst.nhlbi.nih.gov/share/results/23b5f0648668f12b32a8570c78d1d195ebe08d1a00fb430846147f9e0f71f338/chr_3.zip
#wget https://imputation.biodatacatalyst.nhlbi.nih.gov/share/results/44accac9edeccc739ed3ab393f41f2cc169766737d03bcd067aab76900025990/chr_4.zip
#wget https://imputation.biodatacatalyst.nhlbi.nih.gov/share/results/c00737ddf5645f4876dbb2ee95274acee0a46a4eb076c3dd3bf0ce099c57670c/chr_5.zip
#wget https://imputation.biodatacatalyst.nhlbi.nih.gov/share/results/bc561ea2cc756d7c1444d0ded81e3c37dd5b41fc741515bcdb1b73f1890dceb4/chr_6.zip
#wget https://imputation.biodatacatalyst.nhlbi.nih.gov/share/results/cda6e1a85f22d6ed5860ca21633a7de85107f2acc82bb39d459849e663e265ed/chr_7.zip
#wget https://imputation.biodatacatalyst.nhlbi.nih.gov/share/results/7e78a4d923feac833fbdb97ab75c0859df425181c784be8e1163f1f2af7fbba1/chr_8.zip
#wget https://imputation.biodatacatalyst.nhlbi.nih.gov/share/results/f8d68a2fea12665ad221a0b1ffb68290d3b79b904098991310fdddc58a752715/chr_9.zip
#wget https://imputation.biodatacatalyst.nhlbi.nih.gov/share/results/cc2b5e70765f056aa70d12094759778cdb7d6b05a18a2ec4582a62c0f816ff8b/chr_X.zip
#wget https://imputation.biodatacatalyst.nhlbi.nih.gov/share/results/a0f1cd0bd3d84e9d643c8df8dd3e81042707c1b247f7432e9ff2ce70f42e440c/results.md5

## check files downloaded completely
#md5sum -c results.md5

## unzip files using password sent in job completion email from imputation server
datadir=/home/wheelerlab3/Data/METS/2023-07-26_Genotypes_UChicago/METS_TOPMed_imputation/METS733_2023/
for i in {1..22}
do
  unzip -P Al2Rfw]kzMUB5 ${datadir}chr_${i}.zip
done

unzip -P Al2Rfw]kzMUB5 ${datadir}chr_X.zip

#check everything extracted, then rm *zip for space
rm *zip
rm results.md5
