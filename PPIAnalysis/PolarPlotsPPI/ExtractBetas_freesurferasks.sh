#!/bin/sh

hcpdir="/nafs/narr/HCP_OUTPUT"
maindir="/nafs/narr/jloureiro"
StudyFolder="${hcpdir}" #Location of Subject folders (named by subjectID)
Subjlist=$(<$maindir/logstxt/paper2/PPIAnalysis/ALLSubswithPPI_cerebellum.txt) #Space delimited list of subject IDs
#Subjlist="k000901 k000902"
echo "$Subjlist" 

Masksdir="${maindir}/Masks/freesurferSeg/template"

EnvironmentScript="${maindir}/scripts/Pipelines-3.22.0/Examples/Scripts/SetUpHCPPipeline_JL_4slurm.sh"
source ${EnvironmentScript}

module load workbench/1.3.2
templatesdir="${maindir}/scripts/Pipelines-3.22.0/global/templates/91282_Greyordinates"
AverageDatadir="${maindir}/AverageData/HC_n34/MNINonLinear/fsaverage_LR32k"


#VARIABLES TO BE CHANGED##################################################################################

logdir="${maindir}/logstxt/paper2/PPIAnalysis/PolarPlotsROIvalues"
mkdir ${logdir}


ROIlist="R_rostralmiddlefrontal L_rostralmiddlefrontal R_precentral L_precentral R_medialorbitofrontal L_medialorbitofrontal R_rostralanteriorcingulate L_rostralanteriorcingulate R_precuneus L_precuneus R_insula L_insula CAUDATE_RIGHT CAUDATE_LEFT PALLIDUM_RIGHT PALLIDUM_LEFT PUTAMEN_RIGHT PUTAMEN_LEFT HIPPOCAMPUS_RIGHT HIPPOCAMPUS_LEFT AMYGDALA_RIGHT AMYGDALA_LEFT"

createPercChange="NO"
CreateMergedROIs="NO"

if [ ${CreateMergedROIs} ="YES" ]
then
args=""
for mask in ${ROIlist}
do
	args="${args} -cifti ${Masksdir}/cifti_${mask}_aparcaseg.dscalar.nii "
done
	
wb_command -cifti-merge ${Masksdir}/MERGEDROIs.dscalar.nii ${args} 

fi

rm ${logdir}/${cope}/${ppiroi}.txt
		
for sub in ${Subjlist}
do
		
	imagesdir="${hcpdir}/${sub}/MNINonLinear"
	betaimgsdir="${imagesdir}/Results/task-facematching_JL_level2_20cons_clean_PPIAnalysis_${ppiroi}_KTP1_KTP3_cope2c1maskfwep005_paper2/task-facematching_JL_20cons_clean_hp200_s5_level2.feat"
		
	
		
	if [ ${createPercChange} = "YES" ]
	then
		wb_command -cifti-average ${imagesdir}/Results/task-facematching_JL_level2_20cons_clean/meanfMRI2sessions.dscalar.nii -cifti ${imagesdir}/Results/task-facematching_acq-AP_run-01/task-facematching_acq-AP_run-01_Atlas_mean.dscalar.nii -cifti ${imagesdir}/Results/task-facematching_acq-PA_run-01/task-facematching_acq-PA_run-01_Atlas_mean.dscalar.nii
	
		wb_command -cifti-math 'x / y' ${betaimgsdir}/${sub}_task-facematching_JL_20cons_clean_level2_percChange_cope7_hp200_s5.dscalar.nii -var 'x' ${betaimgsdir}/${sub}_task-facematching_JL_20cons_clean_level2_beta_PPIneutral_hp200_s5.dscalar.nii -var 'y' ${imagesdir}/Results/task-facematching_JL_level2_20cons_clean/meanfMRI2sessions.dscalar.nii
		wb_command -cifti-math 'x / y' ${betaimgsdir}/${sub}_task-facematching_JL_20cons_clean_level2_percChange_cope6_hp200_s5.dscalar.nii -var 'x' ${betaimgsdir}/${sub}_task-facematching_JL_20cons_clean_level2_beta_PPIhappy_hp200_s5.dscalar.nii -var 'y' ${imagesdir}/Results/task-facematching_JL_level2_20cons_clean/meanfMRI2sessions.dscalar.nii	
		wb_command -cifti-math 'x / y' ${betaimgsdir}/${sub}_task-facematching_JL_20cons_clean_level2_percChange_cope8_hp200_s5.dscalar.nii -var 'x' ${betaimgsdir}/${sub}_task-facematching_JL_20cons_clean_level2_beta_PPIfearful_hp200_s5.dscalar.nii -var 'y' ${imagesdir}/Results/task-facematching_JL_level2_20cons_clean/meanfMRI2sessions.dscalar.nii
	fi

	wb_command -cifti-stats ${betaimgsdir}/${sub}_task-facematching_JL_20cons_clean_level2_percChange_${cope}_hp200_s5.dscalar.nii -reduce MEAN -roi ${Masksdir}/MERGEDROIs.dscalar.nii >> ${logdir}/${cope}/${ppiroi}.txt
	
		
done


echo "finished"


