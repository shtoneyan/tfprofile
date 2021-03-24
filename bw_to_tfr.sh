#!/bin/bash

# ARGUMENTS

basenji_samplefile=$1
basset_samplefile=$2 #/home/shush/profile/basenji/data/w32_l1024/sample_files/basset_sample_beds_top25.txt
profile_subdir=$3
output_dir=$4 #/home/shush/profile/tfprofile/datasets/top25
prefix=$5
o_prefix=$output_dir/$prefix
mkdir -p $output_dir


d=1 #take all without downsampling
input_size=1024
pool_window=32
genome_size=/home/shush/genomes/GRCh38_EBV.chrom.sizes.tsv
genome=/home/shush/genomes/hg38.fa
unmap=datasets/GRCh38_unmap.bed

# samplefile_dir=data/sample_files
# samplefile_dir=data/w32_l1024/sample_files

# label=${biosample}_${filetype}
# samplefile_dir="$outdir_data/sample_files"

# out_label_dir="${outdir_data}/$label"
# in_label_dir="${data}/${label}"
# in_label_dir="${data}/${filetype}"
# create samplefile for basset AND basenji using existing data folder
# bin/create_samplefile.py "$data" $summary_file_path $label_for_samplefiles $filetype $samplefile_dir

# select best bed from basset preprocessing

/home/shush/codebase/src/preprocess_features.py -y -m 200 -s $input_size \
                                                -o $o_prefix -c $genome_size \
                                                $basset_samplefile

bedfile=$o_prefix.bed

sorted_bedfile="sorted_samplefile.bed"
sorted_genome="sorted_genome.bed"
bedfile="$o_prefix.bed"
sorted_bedfile="$sorted_bedfile.bed"
sorted_genome="$sorted_genome.bed"
sort -k1,1 -k2,2n $bedfile > $sorted_bedfile # sort best bed
sort -k1,1 -k2,2n $genome_size > $sorted_genome # sort genome
# get the complement of the sorted bed and the genome to get which parts to avoid
bedtools complement -i $sorted_bedfile -g $sorted_genome > nonpeaks.bed
# complete the avoid regions by adding unmappable
cat nonpeaks.bed $unmap > avoid_regions.bed
sort -k1,1 -k2,2n avoid_regions.bed > sorted_avoid_regions.bed
bedtools merge -i sorted_avoid_regions.bed > merged_avoid_regions.bed

rm nonpeaks.bed
rm avoid_regions.bed
rm sorted_avoid_regions.bed
rm $sorted_genome
rm $sorted_bedfile


# preprocess data using GRCh38, and using the bed file to select regions

bin/basenji_data.py $genome \
                    $basenji_samplefile \
                    -g merged_avoid_regions.bed \
                    -l $input_size -o $output_dir/$profile_subdir -t .1 -v .1 \
                    -w $pool_window --local -d $d
# #
scp merged_avoid_regions.bed "$output_dir/$profile_subdir/"
rm merged_avoid_regions.bed

#top 25 input args
