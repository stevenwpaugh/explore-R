#!/bin/bash

grep SNP ${1} > ${1}.small
awk '{print $2,$3,$4,$9,$10,$12}' ${1}.small > ${1}.process

tail -q -n+2 "${1}.process" >> "${1}.final"

