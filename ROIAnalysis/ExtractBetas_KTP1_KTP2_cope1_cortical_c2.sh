#!/bin/sh

hcpdir="/nafs/narr/HCP_OUTPUT"
maindir="/nafs/narr/jloureiro"
StudyFolder="${hcpdir}" #Location of Subject folders (named by subjectID)
Subjlist=$(<$maindir/logstxt/paper2/Subs4ROIAnalysis_paper2.txt) #Space delimited list of subject IDs
Subjlist4masks=${Subjlist}
echo "$Subjlist" 

mainfreesurferMasksdir="${maindir}/Masks/freesurferSeg/cifti"

EnvironmentScript="${maindir}/scripts/Pipelines-3.22.0/Examples/Scripts/SetUpHCPPipeline_JL_4slurm.sh"

source ${EnvironmentScript}

module load workbench/1.3.2

templatesdir="${maindir}/scripts/Pipelines-3.22.0/global/templates/91282_Greyordinates"
AverageDatadir="${maindir}/AverageData/HC_n34/MNINonLinear/fsaverage_LR32k"


#VARIABLES TO BE CHANGED##################################################################################

groupzstatdir="${maindir}/PALM3rdLevel/FM/paper2/KTP1_KTP2"

groupzstat="KTP1_KTP2"

CopeMask="cope1"
ConMask="c2"
corrp="uncp" #"fwep" if corrected
pvalue="0001" #"oo5" if corrected
FuncMasksdir="${maindir}/Masks/paper2/FuncMasks"
mainCombinedMasksdir="${maindir}/Masks/paper2/CombinedMasks/${groupzstat}_cifti"
FuncMaskname="${groupzstat}_${CopeMask}${ConMask}mask${corrp}${pvalue}"

mkdir ${FuncMasksdir}
mkdir ${mainCombinedMasksdir}

logdir="${maindir}/logstxt/paper2/ROIAnalysis/${FuncMaskname}"
mkdir ${logdir}

SubcorticalROI="NO" #"NO" if cortical ROI

#Cortical ROIs:
ROIlist="L_posteriorcingulate"
MergeROIs="NO" #"YES" if more than one ROI to merge at the end
FuncMasks="NO"
MakeMasks="NO" #YES if we want to isolate freesurfer masks
createPercChange="NO"

#Get clusters from crossectional analysis - functional masks #####################################################################
if [ ${FuncMasks} = "YES" ]
then 

#for fearful > neutral c2 (MDD > HC) vol min= 800mm3 (100 voxels)##############################

wb_command -cifti-math 'x > 3' ${FuncMasksdir}/${FuncMaskname}.dscalar.nii -var 'x' ${groupzstatdir}/${CopeMask}/results_cifti_dat_ztstat_${corrp}_${ConMask}.dscalar.nii
fi



#1- Isolate ROI masks from aparc+aseg image and combine structural and functional rois#############################################

if [ ${MakeMasks} = "YES" ]
then 

	
	wb_command -cifti-create-label ${templatesdir}/Atlas_ROIs_template.2.dlabel.nii -volume ${templatesdir}/Atlas_ROIs.2.nii ${templatesdir}/Atlas_ROIs.2.nii.gz -left-label ${hcpdir}/k000801/MNINonLinear/fsaverage_LR32k/sub-k000801.L.aparc.32k_fs_LR.label.gii -right-label ${hcpdir}/k000801/MNINonLinear/fsaverage_LR32k/sub-k000801.R.aparc.32k_fs_LR.label.gii

	for sub in ${Subjlist4masks}
	do
		echo "Generating masks from aparc+aseg for ${sub}"
	
		freesurferMasksdir="${mainfreesurferMasksdir}/${sub}"
		CombinedMasksdir="${mainCombinedMasksdir}/${sub}"
		imagesdir="${hcpdir}/${sub}/MNINonLinear"
		mkdir ${CombinedMasksdir}
		mkdir ${freesurferMasksdir}
		
		if [ ${SubcorticalROI} = "YES" ]; then
				
				for mask in $ROIlist
				do
					i=$((${i} + 1))
					#echo $i
					
					wb_command -cifti-label-to-roi ${templatesdir}/Atlas_ROIs_template.2.dlabel.nii ${freesurferMasksdir}/cifti_${mask}_aparcaseg.dscalar.nii -name ${mask}

					wb_command -cifti-math 'x * y' ${CombinedMasksdir}/combined_${mask}_${FuncMaskname}.dscalar.nii -var 'x' ${freesurferMasksdir}/cifti_${mask}_aparcaseg.dscalar.nii -var 'y' ${FuncMasksdir}/${FuncMaskname}.dscalar.nii
					
				done

		else

				for mask in $ROIlist
				do
						wb_command -cifti-label-to-roi ${templatesdir}/Atlas_ROIs_template.2.dlabel.nii ${freesurferMasksdir}/cifti_${mask}_aparcaseg.dscalar.nii -name ${mask}

						wb_command -cifti-math 'x * y' ${CombinedMasksdir}/combined_${mask}_${FuncMaskname}.dscalar.nii -var 'x' ${freesurferMasksdir}/cifti_${mask}_aparcaseg.dscalar.nii -var 'y' ${FuncMasksdir}/${FuncMaskname}.dscalar.nii
						

				done

		fi

		if [ ${MergeROIs} = "YES" ]
		then
		args=""
		for mask in ${ROIlist}
		do
			args="${args} -cifti ${CombinedMasksdir}/combined_${mask}_${FuncMaskname}.dscalar.nii "
		done
	
			wb_command -cifti-merge ${CombinedMasksdir}/MERGEDROIs_${FuncMaskname}.dscalar.nii ${args} 
	
			wb_command -cifti-create-dense-from-template ${maindir}/scripts/Pipelines-3.22.0/global/templates/91282_Greyordinates/Atlas_ROIs_template.2.dlabel.nii ${CombinedMasksdir}/MERGEDROIs_${FuncMaskname}.dscalar.nii -cifti ${CombinedMasksdir}/MERGEDROIs_${FuncMaskname}.dscalar.nii
			
			
	else
		wb_command -cifti-create-dense-from-template ${maindir}/scripts/Pipelines-3.22.0/global/templates/91282_Greyordinates/Atlas_ROIs_template.2.dlabel.nii ${CombinedMasksdir}/combined_${ROIlist}_${FuncMaskname}.dscalar.nii -cifti ${CombinedMasksdir}/combined_${ROIlist}_${FuncMaskname}.dscalar.nii
		
	fi
	done

fi

#generate one file with all ROIs################################################################################################



mkdir ${logdir}/${cope}
rm ${logdir}/${cope}/${cope}_${FuncMaskname}.txt


for sub in ${Subjlist}
do

	CombinedMasksdir="${mainCombinedMasksdir}/${sub}"
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

		if [ ${MergeROIs} = "YES" ]
		then
			wb_command -cifti-stats ${betaimgsdir}/${sub}_task-facematching_JL_20cons_clean_level2_percChange_${cope}_hp200_s5.dscalar.nii -reduce MEAN -roi ${CombinedMasksdir}/MERGEDROIs_${FuncMaskname}.dscalar.nii >> ${logdir}/${cope}/MERGEDROIs_${cope}_${FuncMaskname}.txt
	
		else
			wb_command -cifti-stats ${betaimgsdir}/${sub}_task-facematching_JL_20cons_clean_level2_percChange_${cope}_hp200_s5.dscalar.nii -reduce MEAN -roi ${CombinedMasksdir}/combined_${ROIlist}_${FuncMaskname}.dscalar.nii >> ${logdir}/${cope}/${ROIlist}_${cope}_${FuncMaskname}.txt
		
		fi

	
done


echo "finished"


