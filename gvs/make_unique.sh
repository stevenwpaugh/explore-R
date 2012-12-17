#!/bin/bash


project="spaugh"
timestamp=`date +%Y%m%d%H%M%S%N`
currdate=`date +%Y%m%d_%H%M%S`
queue="priority"
mkdir -p log
wd=${1}

echo $timestamp

#files=`

#echo ${files}

for file in `ls ${wd}/*_G_bam.final | sed -e 's/_G_bam.final//'`
do

file1=${file}_G_bam.final
file2=${file}_bam_high_20.final
file3=${file}.uniq
log=`echo ${file} | sed -e 's/\.\///'`

#echo ${file1}
#echo ${file2}
#echo ${file3}

bsub -P $project -q ${queue} -J ${timestamp}_${log} -oo "log/${timestamp}_${log}.o" -R "rusage[mem=8000]" ./sorter.sh $file1 $file2 $file3

done
