#!/bin/bash

# Create folder for error and output files

# set current directory to the folder where the script is located
working_dir=/lustre/scratch123/hgi/teams/parts/kl11/cell2state_tf_activation/data/


## Input folder
data_folder=/lustre/scratch125/ids/team117/npg/srl/kl11

## Output folder

# set path for output files
output_folder=${working_dir}/barcode_output/
mkdir -p $output_folder

#run the script
bsub -G team227 -q long -M20000 -R "select[mem>20000] rusage[mem=20000] span[hosts=1]" \
	-n 16 -oo ${output_folder}/barcodes.stdout -eo ${output_folder}/barcodes.stderr \
    python parse_barcodes.py \
    --bam ${data_folder}/cellranger710_count_Barcode-3P1_Crispra_custom_ref/possorted_genome_bam.bam \
    --seq ${working_dir}/cloned_gRNA_constructs_w_barcode_processed.csv \
    --csv ${output_folder}/barcode_counts.csv