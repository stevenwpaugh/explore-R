#!/bin/bash

#. /etc/bashrc.modules 

#module load R/64-bit/2.14.0

R CMD BATCH --no-save --args --$1 --$2 --$3 --$4 --$5 --$6 boxplot/boxplotbyCN.R ../Rlogs/boxplotbyCN.Rout

