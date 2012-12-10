#!/bin/bash


project="spaugh"
timestamp=`date +%Y%m%d%H%M%S%N`
currdate=`date +%Y%m%d_%H%M%S`
queue="normal"
mkdir log

echo $timestamp

while read file
do
        bsub -P $project -q ${queue} -J ${timestamp}_${file} -oo "log/${timestamp}_${file}.o" -R "rusage[mem=8000]" ./hitvarprep.sh ${file}  

done < files.tsv

