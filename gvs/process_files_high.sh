#!/bin/bash


project="spaugh"
timestamp=`date +%Y%m%d%H%M%S%N`
currdate=`date +%Y%m%d_%H%M%S`
queue="priority"
mkdir -p log

echo $timestamp

while read file
do

filename=$(basename "$file")
extension="${filename##*.}"
filename="${filename%.*}"

    bsub -P $project -q ${queue} -J ${timestamp}_${filename} -oo "log/${timestamp}_${filename}.o" -R "rusage[mem=8000]" ./hitvarprephigh.sh ${file}  

done < $1

