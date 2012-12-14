#!/bin/bash


project="spaugh"
timestamp=`date +%Y%m%d%H%M%S%N`
currdate=`date +%Y%m%d_%H%M%S`
queue="priority"
mkdir -p log
wd=${1}

echo $timestamp

files=`ls ${wd}/*_G_bam.final | sed -e 's/_G_bam.final//'`

for file in "${files[@]}"
do

file1=${file}_G_bam.final
file2=${file}_bam_high_20.final
file3=${file}.merge
file4=${file}.uniq
 

echo bsub -P $project -q ${queue} -J ${timestamp}_${filename} -oo "log/${timestamp}_${filename}.o" -R "rusage[mem=8000]" sort -m $file1 $file2> $file3 | uniq > $file4

done