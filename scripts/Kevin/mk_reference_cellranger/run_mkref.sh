#!/bin/bash
### BEGINNING OF GENOTYPE DECONVOLUTION SCRIPT ###
# AUTHOR: Claudia Feng (ecg@sanger.ac.uk)

## ---- SetVariables

#### Experiment-specific variables

ExperimentName=Magpie
ProjectID=P42
NonTargetGeneName=NonTarget
BatchNo=1
Date=210825 #change date
rerun=FALSE

HomeFolder=/lustre/scratch123/hgi/teams/parts/cf14/crispr_scrnaseq_hipsci/ #changed
ProjectFolder=/lustre/scratch123/hgi/projects/crispri_scrnaseq/ #change


WorkflowFolder=${HomeFolder}workflows/
CodeFolder=${HomeFolder}scripts/
FilesFolder=${ProjectFolder}files/${ExperimentName}/
DataFolder=${ProjectFolder}data/${ExperimentName}/
OutFolder=${ProjectFolder}outs/${ExperimentName}/
ResourcesFolder=${ProjectFolder}resources/

#check if this is needed
GuideMetadata=${FilesFolder}${ExperimentName}Library_forAnalysis.tsv
LaneMetadata=${FilesFolder}LaneMetadata_Batch${BatchNo}-Miseq.csv

##Useful Paths
CellRangerReferencePath=${ResourcesFolder}reference_sequences/${ExperimentName}_custom_ref/


## Experiment-specific variables (values)
no_of_ids=`cat ${LaneMetadata} | wc -l`



## ---- 1_MakeReference
# Make Reference

cd $ResourcesFolder
sh ${CodeFolder}/Setup/make_reference/mkref.sh \
	--added_sequences ${ResourcesFolder}reference_sequences/added_sequences/ \
	--home_directory ${ResourcesFolder}reference_sequences/ \
	--experiment_name ${ExperimentName}

mv ${ResourcesFolder}/${ExperimentName}_custom_ref/ ${CellRangerReferencePath}
rm Log.out
rm ${ResourcesFolder}reference_sequences/new_reference/