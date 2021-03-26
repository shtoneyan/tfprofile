#!/bin/bash

declare -a arr=("0.2" "0.4" "0.6")

## now loop through the above array
for i in "${arr[@]}"
do
   echo "$i"
   ./fr_bw_to_tfr.sh /home/shush/profile/basenji/data/w32_l1024/sample_files/basenji_sample_top25_fold.txt /home/shush/codebase/preprocess/top25/fr${i}/fr_${i}_top25.bed datasets/top25/${i}_fold

done
