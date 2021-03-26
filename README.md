# tfprofile
This repo contains scripts for generating profile datasets for TF ChIP seq data, analyzing them and training models.

bw_to_tfr.sh script takes basenji and basset sample files and makes a dataset of tfrecords for the dataset using chromosome 8 and 9 as validation and test set.

fr_bw_to_tfr.sh runs this for cases when the basset preprocessed file (with bed ranges) is already present (which is the case when creating datasets from subsampled data).
