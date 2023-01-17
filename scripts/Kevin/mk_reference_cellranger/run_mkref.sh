#!/bin/bash
### BEGINNING OF GENOTYPE DECONVOLUTION SCRIPT ###
# AUTHOR: Claudia Feng (ecg@sanger.ac.uk)

## ---- SetVariables

#### Experiment-specific variables

ExperimentName=Magpie
ProjectID=P42
NonTargetGeneName=NonTarget
BatchNo=1
Date=230116 #change date
rerun=FALSE

HomeFolder=/lustre/scratch123/hgi/teams/parts/kl11/cell2state_tf_activation/ #changed



WorkflowFolder=${HomeFolder}workflows/
CodeFolder=${HomeFolder}scripts/Kevin/
FilesFolder=${HomeFolder}files/${ExperimentName}/
DataFolder=${HomeFolder}data/${ExperimentName}/
OutFolder=${HomeFolder}outs/${ExperimentName}/
ResourcesFolder=${HomeFolder}data/

# GuideMetadata=${FilesFolder}${ExperimentName}Library_forAnalysis.tsv
# LaneMetadata=${FilesFolder}LaneMetadata_Batch${BatchNo}-Miseq.csv

##Useful Paths
CellRangerReferencePath=${ResourcesFolder}reference_sequences/${ExperimentName}_custom_ref/


## Experiment-specific variables (values)
# no_of_ids=`cat ${LaneMetadata} | wc -l`



## ---- 1_MakeReference
# Make Reference

cd $ResourcesFolder
echo '---Start making reference file'
bash ${CodeFolder}mk_reference_cellranger/mkref.sh \
	--added_sequences ${ResourcesFolder}reference_sequences/added_sequences/ \
	--home_directory ${ResourcesFolder}reference_sequences/ \
	--experiment_name ${ExperimentName}
echo 'Reference file successfully made---'

# mv ${ResourcesFolder}/${ExperimentName}_custom_ref/ ${CellRangerReferencePath}
# rm Log.out
# rm ${ResourcesFolder}reference_sequences/new_reference/