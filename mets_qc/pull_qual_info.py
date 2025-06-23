#!/usr/bin/python3
'''retrieve R2 and ER2 (if present) for variants
in a VCF file'''

import gzip
import sys

infile=sys.argv[1]
outfile=sys.argv[2]
print(infile)
print(outfile)

out=open(outfile,"wb")
out.write(b"ID\tR2\tER2\n")

with gzip.open(infile) as f:
    for line in f:
        arr = line.strip().split(b"\t") #split on tabs
        if arr[0].startswith(b"#"):
            continue
        id = arr[2]
        info = arr[7]
        infolist = info.split(b";")
        r2 = infolist[2]
        er2 = infolist[3]
        r2num = r2.split(b"=")[1]
        if er2.startswith(b'ER2'):
            er2num = er2.split(b"=")[1]
        else:
            er2num = b"NA"
        out.write(id + b'\t' + r2num + b'\t' + er2num + b'\n')

out.close()
