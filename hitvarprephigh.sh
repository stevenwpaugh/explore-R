#!/bin/bash

filename=$(basename "$1")
extension="${filename##*.}"
filename="${filename%.*}"

grep SNP ${1} > ${filename}.small
awk '{print $3,$4,$5,$10,$11,$13}' ${filename}.small > ${filename}.process

tail -q -n+2 "${filename}.process" >> "${filename}.final"

rm ${filename}.small
rm ${filename}.process
