
#!/bin/bash
### SCRIPT TO MAKE CUSTOM REFERENCE ###
# AUTHOR: CLAUDIA FENG (ecg@sanger.ac.uk)

# Defining messages
printHelpMessage() {
	echo ""
	echo ":::::::::::::::::::::::::::: MAKING A CUSTOM REFERENCE FOR SINGLE-CELL CRISPR EXPERIMENTS ::::::::::::::::::::::::::::"
	echo ""
	echo "This script performs creates a custom reference for CellRanger for single-cell CRISPR-based experimeents"
	echo "The script assumes ."
	echo "For more information, see usage or refer to the README.md file"
	echo ""
	echo "usage: 1_MakeReference.sh [OPTIONAL ARGUMENTS]"
	echo "" 
	echo "Optional arguments:"
	echo "[-h | --help]	Display this help message"
	echo "[-a | --added_sequences]	Folder containing sequences to be added to the reference genome. First line is '>[GENE NAME]'. Second line should be the sequence (standard .fa format). There can be other things in the folder, but it's important that the sequences you want added all end with .reference.fa"
	echo "[-c | --cellranger_path]	CellRanger path. Default: /lustre/scratch123/hgi/teams/parts/cellranger/cellranger-4.0.0/cellranger"
	echo "[-d | --home_directory]	Where the final reference will be written. There'll also be some intermediate files written here."
	echo "[-r | --reference]	Folder containing the reference that will be edited."
	echo ""
}

printErrorMessage() {
	echo ""
  	echo "[MakeReference]: ERROR: Something went wrong."
  	echo "Please see program usage (--help)"
  	echo ""
}

# Setting help message as default program call
if [ "$#" -eq 0 ]
then
    printHelpMessage
    exit 1
fi


CELLRANGER=/lustre/scratch123/hgi/teams/parts/cellranger/cellranger-4.0.0/cellranger #check cell ranger version
ref_folder=/lustre/scratch123/hgi/projects/crispri_scrnaseq/resources/reference_sequences/ #change this folder
added_sequences=${ref_folder}/added_sequences/
reference_folder=/nfs/srpipe_references/downloaded_from_10X/refdata-gex-GRCh38-2020-A/

for arg in "$@"
do
    case $arg in
        -h|--help)
        printHelpMessage
        exit 1
        ;;
        -a|--added_sequences)
        added_sequences="$2"
        shift # Remove --snplist from argument list
        shift # Remove argument value from argument list
        ;;
        -c|--cellranger_path)
        CELLRANGER="$2"
        shift # Remove --genotypes from argument list
        shift # Remove argument value from argument list
        ;;
        -d|--home_directory)
        ref_folder="$2"
        shift # Remove --genotypes from argument list
        shift # Remove argument value from argument list
        ;;
        -e|--experiment_name)
        ExperimentName="$2"
        shift # Remove --genotypes from argument list
        shift # Remove argument value from argument list
        ;;
        -r|--reference)
        reference_folder="$2"
        shift # Remove --out from argument list
        shift # Remove argument value from argument list
        ;;
    esac
done


if [ ! -d $ref_folder ]
then
	mkdir $ref_folder
fi

if [ ! -d ${ref_folder}/reference_genome/ ]
then
	mkdir ${ref_folder}/reference_genome/
fi

if [ ! -d ${ref_folder}/new_reference/ ]
then
	mkdir ${ref_folder}/new_reference/
fi


## ---- GetRefs
#get reference sequences 

cp ${reference_folder}fasta/genome.fa ${ref_folder}/reference_genome/
cp ${reference_folder}genes/genes.gtf ${ref_folder}/reference_genome/

## ---- ToUpper

#convert to uppercase
for added_seq in $added_sequences*.reference.fa
do
	sequence_name=`echo $added_seq | awk -F '/' '{print $NF}' | awk -F '.' '{print $1}'`
	cat $added_seq | tr [a-z] [A-Z] | fold -w60 > $ref_folder/added_sequences/${sequence_name}_uppercase.fa
done

## ---- nBases
#find number of bases

for added_seq in $added_sequences*.reference.fa
do
	sequence_name=`echo $added_seq | awk -F '/' '{print $NF}' | awk -F '.' '{print $1}'`
	cat $added_sequences${sequence_name}_uppercase.fa | grep -v "^>" | tr -d "\n" | wc -c > $added_sequences${sequence_name}_n_bases.txt
done

## ---- CreateGTF
#create_gtf_puro_cas9.sh

for added_seq in $added_sequences*.reference.fa
do
	sequence_name=`echo $added_seq | awk -F '/' '{print $NF}' | awk -F '.' '{print $1}'`
	/bin/echo -e $sequence_name"\tunknown\texon\t1\t"`cat $ref_folder/added_sequences/${sequence_name}_n_bases.txt`\
'\t.\t+\t.\tgene_id "'$sequence_name'"; transcript_id "'$sequence_name'"; gene_name "'$sequence_name'"; gene_biotype "protein_coding";' > $added_sequences${sequence_name}.gtf
done

## ---- CreateNewReference

## prepare augmented genome fa:
cp $ref_folder/reference_genome/genome.fa $ref_folder/new_reference/genome.fa

for added_seq in $added_sequences*.reference.fa
do
	sequence_name=`echo $added_seq | awk -F '/' '{print $NF}' | awk -F '.' '{print $1}'`
	echo $sequence_name
	cat $added_sequences${sequence_name}_uppercase.fa >> $ref_folder/new_reference/genome.fa
	echo '' >> $ref_folder/new_reference/genome.fa
done


## prepare augmented gtf:
cp $ref_folder/reference_genome/genes.gtf $ref_folder/new_reference/genes.gtf

for added_seq in $added_sequences*.reference.fa
do
	sequence_name=`echo $added_seq | awk -F '/' '{print $NF}' | awk -F '.' '{print $1}'`
	echo $sequence_name
	cat $added_sequences${sequence_name}.gtf >> $ref_folder/new_reference/genes.gtf
done

## ---- 

bsub -q long -M20000 -R "select[mem>20000] rusage[mem=20000] span[hosts=1]" \
	-n 16 -oo $ref_folder/mkref.stdout -eo $ref_folder/mkref.stderr \
	$CELLRANGER mkref --genome=${ExperimentName}_custom_ref --fasta=$ref_folder/new_reference/genome.fa \
	--genes=$ref_folder/new_reference/genes.gtf



