#!/bin/bash

# Create folder for error and output files

# set current directory to the folder where the script is located
working_dir=/lustre/scratch123/hgi/teams/parts/kl11/cell2state_tf_activation/data/


## Input folder
data_folder=/lustre/scratch126/cellgen/team283/vk7/large_data/ipsc_multiome_49_05/

## Output folder

# set path for output files
output_folder=${working_dir}/barcode_output_multiome/
mkdir -p $output_folder
# create an array with all barcode library names: Barcode-3P1, Barcode-3S, Barcode-3WT
# barcode_array=("08972bb85ef752ca936c888e2872b364" "54549d53a45599c8213eae016199fa4e" "f5a996dd2bce39c438fe8fff985ce824")
barcode_array=("cellranger-arc202_count_59ef94963174877bed43b5449e0c3e9d" "cellranger-arc202_count_6b9ffe36012988a1708d2ad859a18295" "cellranger-arc202_count_b986290cf415efe4e7f8e709e2cd6ad3" "cellranger-arc202_count_e9aa72d3b8ebcb6efdbd55eaef2e1fe8")

#loop through all barcodes and run parse_barcodes.py
for i in "${barcode_array[@]}";
do

    echo "Processing $i"


    # run parse_barcodes.py
    bsub -q normal -M5000 -R "select[mem>5000] rusage[mem=5000] span[hosts=1]" \
    -n 32 -oo ${output_folder}/barcodes_$i.stdout -eo ${output_folder}/barcodes_$i.stderr \
    python parse_barcodes.py \
    --bam ${data_folder}/${i}/gex_possorted_bam.bam \
    --seq ${working_dir}/cloned_gRNA_constructs_w_barcode_processed.csv \
    --csv ${output_folder}/${i}_barcode_counts.csv
done


