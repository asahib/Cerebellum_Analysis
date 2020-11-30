#!/bin/sh

hcpdir="/nafs/narr/HCP_OUTPUT"
maindir="/nafs/narr/jloureiro"
StudyFolder="${hcpdir}" #Location of Subject folders (named by subjectID)
Subjlist=$(<$maindir/logstxt/paper2/Subs4ROIAnalysis_paper2.txt) #Space delimited list of subject IDs
echo "$Subjlist" 

EnvironmentScript="${maindir}/scripts/Pipelines-3.22.0/Examples/Scripts/SetUpHCPPipeline_JL_4slurm.sh"

source ${EnvironmentScript}

module load workbench/1.3.2

templatesdir="${maindir}/scripts/Pipelines-3.22.0/global/templates/91282_Greyordinates"
AverageDatadir="${maindir}/AverageData/HC_n34/MNINonLinear/fsaverage_LR32k"


#VARIABLES TO BE CHANGED##################################################################################

group="KTP1_KTP3"
groupzstatdir="${maindir}/PALM3rdLevel/FM/paper2/${group}"

CopeMask="cope2"
ConMask="c1"

corrp="fwep" #"fwep" if corrected
pvalue="005" #"oo5" if corrected

FuncMasksdir="${maindir}/Masks/paper2/FuncMasks"
CombinedMasksdir="${maindir}/Masks/paper2/CombinedMasks/cerebellum"
FuncMaskname="${group}_${CopeMask}${ConMask}mask${corrp}${pvalue}"

mkdir ${FuncMasksdir}
mkdir ${mainCombinedMasksdir}

logdir="${maindir}/logstxt/paper2/ROIAnalysis/${FuncMaskname}"
mkdir ${logdir}

#ROIlist="Left_VIIb Left_VIIIa Left_VI Right_VIIb"

createPercChange="NO"

if [ -f "${logdir}/MERGEDROIs_${cope}_${FuncMaskname}.txt" ]; then
	rm ${logdir}/MERGEDROIs_${cope}_${FuncMaskname}.txt
fi

for sub in ${Subjlist}
do

	imagesdir="${hcpdir}/${sub}/MNINonLinear"
	betaimgsdir="${imagesdir}/Results/task-facematching_JL_level2_20cons_clean/task-facematching_JL_20cons_clean_hp200_s5_level2.feat"
			
	if [ ${createPercChange} = "YES" ]
	then
	
		wb_command -cifti-average ${betaimgsdir}/meanfMRI2sessions.dscalar.nii -cifti ${imagesdir}/Results/task-facematching_acq-AP_run-01/task-facematching_acq-AP_run-01_Atlas_mean.dscalar.nii -cifti ${imagesdir}/Results/task-facematching_acq-PA_run-01/task-facematching_acq-PA_run-01_Atlas_mean.dscalar.nii
	
		wb_command -cifti-math 'x / y' ${betaimgsdir}/${sub}_task-facematching_JL_20cons_clean_level2_percChange_cope1_hp200_s5.dscalar.nii -var 'x' ${betaimgsdir}/${sub}_task-facematching_JL_20cons_clean_level2_beta_HAPPY_hp200_s5.dscalar.nii -var 'y' ${betaimgsdir}/meanfMRI2sessions.dscalar.nii

		wb_command -cifti-math 'x / y' ${betaimgsdir}/${sub}_task-facematching_JL_20cons_clean_level2_percChange_cope2_hp200_s5.dscalar.nii -var 'x' ${betaimgsdir}/${sub}_task-facematching_JL_20cons_clean_level2_beta_NEUTRAL_hp200_s5.dscalar.nii -var 'y' ${betaimgsdir}/meanfMRI2sessions.dscalar.nii

		wb_command -cifti-math 'x / y' ${betaimgsdir}/${sub}_task-facematching_JL_20cons_clean_level2_percChange_cope3_hp200_s5.dscalar.nii -var 'x' ${betaimgsdir}/${sub}_task-facematching_JL_20cons_clean_level2_beta_FEARFUL_hp200_s5.dscalar.nii -var 'y' ${betaimgsdir}/meanfMRI2sessions.dscalar.nii

		wb_command -cifti-math 'x / y' ${betaimgsdir}/${sub}_task-facematching_JL_20cons_clean_level2_percChange_cope4_hp200_s5.dscalar.nii -var 'x' ${betaimgsdir}/${sub}_task-facematching_JL_20cons_clean_level2_beta_OBJECTS_hp200_s5.dscalar.nii -var 'y' ${betaimgsdir}/meanfMRI2sessions.dscalar.nii

	fi

	wb_command -cifti-separate ${betaimgsdir}/${sub}_task-facematching_JL_20cons_clean_level2_percChange_${cope}_hp200_s5.dscalar.nii COLUMN -volume-all ${betaimgsdir}/${sub}_task-facematching_JL_20cons_clean_level2_percChange_${cope}_hp200_s5_vol.nii

	wb_command -volume-stats ${betaimgsdir}/${sub}_task-facematching_JL_20cons_clean_level2_percChange_${cope}_hp200_s5_vol.nii -reduce MEAN -roi ${CombinedMasksdir}/MERGEDROIs_cerebellum_KTP1KTP3cope2c1_vol.nii >> ${logdir}/MERGEDROIs_${cope}_${FuncMaskname}_vol.txt

	
done


echo "finished"


