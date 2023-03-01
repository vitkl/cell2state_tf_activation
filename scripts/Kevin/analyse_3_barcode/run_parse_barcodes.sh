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
# create an array with all barcode library names: Barcode-3P1, Barcode-3S, Barcode-3WT
# barcode_array=("08972bb85ef752ca936c888e2872b364" "54549d53a45599c8213eae016199fa4e" "f5a996dd2bce39c438fe8fff985ce824")
barcode_array=("Barcode-3S" "Barcode-3P1" "Barcode-3WT")

#loop through all barcodes and run parse_barcodes.py
for i in "${barcode_array[@]}";
do

    echo "Processing $i"


    # run parse_barcodes.py
    bsub -G team227 -q normal -M5000 -R "select[mem>5000] rusage[mem=5000] span[hosts=1]" \
    -n 32 -oo ${output_folder}/barcodes_$i.stdout -eo ${output_folder}/barcodes_$i.stderr \
    python parse_barcodes.py \
    --bam ${data_folder}/cellranger710_count_${i}_Crispra_custom_ref/possorted_genome_bam.bam \
    --seq ${working_dir}/cloned_gRNA_constructs_w_barcode_processed.csv \
    --csv ${output_folder}/${i}_barcode_counts.csv
done


