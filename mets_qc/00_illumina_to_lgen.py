#!/usr/bin/python3
'''converts Illumina format (METS 2023 genotypes) to .lgen, .map, and .fam
files for use in plink, use this one, much more efficient than R'''

import gzip
import re
import sys
import argparse
import os

#looking at positions in HWheeler-GSA24v3-pltsA1A2B1B2-384s-230721_SNP_Map.txt
#the Name column (1:103380393) is GRCh37/hg19 assembly or the rsid or other id (PGx, exm, etc.)
#the Chromosome (1) and Position (102914837) columns are GRCh38/hg38 assembly
#look up rs577266494 in http://genome.ucsc.edu/cgi-bin/hgGateway for example

def check_arg(args=None):
    parser = argparse.ArgumentParser(description='converts Illumina FinalReport.txt to .lgen/.map/.fam')
    parser.add_argument('-i', '--illumina',
                        help='file path of the illumina FinalReport.txt',
                        required='True'
                        )
    parser.add_argument('-o', '--output',
                        help='output file prefix',
                        required='True'
                        )
    parser.add_argument('-s', '--skip',
                        help='number of lines that preceed the first SNP in input file. Default is 10',
                        type=int,
                        default=10
                        )
    return parser.parse_args(args)

#retrieve command line arguments

args = check_arg(sys.argv[1:])
infile = args.illumina
outfile = args.output
skip = args.skip

#open output files
lgen = open(outfile + ".lgen", "w")
map = open(outfile + ".map", "w")
fam = open(outfile + ".fam", "w")

#store ids in dictionary (ordered) to rm dups
mapdict = dict()
famdict = dict()

with open(infile) as f:
    #skip first 10 rows
    for _ in range(skip):
        next(f)
    for line in f:
        arr = line.strip().split("\t") #split on tabs
        snpname = arr[0]
        sampleid = arr[1]
        a1fwd = arr[10]
        a2fwd = arr[11]
        chr = arr[18]
        pos = arr[19]
        if a1fwd == "-" or a2fwd == "-":
            continue
        lgen.write(sampleid + "\t" + sampleid + "\t" + snpname + "\t" + a1fwd + "\t" + a2fwd + "\n")
        famdict[sampleid] = ""
        mapdict[snpname] = chr + "\t" + snpname + "\t0\t" + pos + "\n"

lgen.close()

for snp in mapdict.keys():
    map.write(mapdict[snp])

for id in famdict.keys():
    fam.write(id + "\t" + id + "\t0\t0\t0\t0\n")
fam.close()
## Note: I'll need to add sex to .fam after making bed/bim/fam
## Also, replace IID plate number with the METS sample ID in the plate map
