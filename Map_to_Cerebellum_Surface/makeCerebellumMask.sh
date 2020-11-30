#!/bin/bash 

hcpdir="/nafs/narr/HCP_OUTPUT"
maindir="/nafs/narr/jloureiro"
txtfile4analysis="${maindir}/tmpsubs4analysis.txt"
#FSLDIR="/usr/local/fsl-5.0.9"
HCPPIPEDIR="${maindir}/scripts/Pipelines-3.22.0"
#CARET7DIR="/usr/local/workbench-1.2.3/bin_rh_linux64"

StudyFolder="${hcpdir}" #Location of Subject folders (named by subjectID)
Subjlist=$(<$maindir/logstxt/Subs4ROIAnalysis_paper.txt) #Space delimited list of subject IDs
#Subjlist="k000801 k000802"
#Subjlist=$(<$maindir/logstxt/test.txt)
echo "$Subjlist" 
#Subjlist4masks=$(<$maindir/logstxt/Subs4CombinedMasks.txt)
#Subjlist4masks=$(<$maindir/logstxt/Subs4ROIAnalysis2.txt)
#Subjlist4masks="k006602"
Subjlist4masks=${Subjlist}
mainfreesurferMasksdir="${maindir}/Masks/freesurferSeg/cifti"
MakeIndMasks="NO"
EnvironmentScript="${maindir}/scripts/Pipelines-3.22.0/Examples/Scripts/SetUpHCPPipeline_JL_4slurm.sh"

source ${EnvironmentScript}

module load workbench

templatesdir="${maindir}/scripts/Pipelines-3.22.0/global/templates/91282_Greyordinates"
AverageDatadir="${maindir}/AverageData/HC_n34/MNINonLinear/fsaverage_LR32k"


wb_command -cifti-create-label ${templatesdir}/Atlas_ROIs_template.2.dlabel.nii -volume ${templatesdir}/Atlas_ROIs.2.nii.gz ${templatesdir}/Atlas_ROIs.2.nii.gz -left-label ${hcpdir}/k000801/MNINonLinear/fsaverage_LR32k/sub-k000801.L.aparc.32k_fs_LR.label.gii -right-label ${hcpdir}/k000801/MNINonLinear/fsaverage_LR32k/sub-k000801.R.aparc.32k_fs_LR.label.gii
if [ ${MakeIndMasks} = "YES" ]
then
	for sub in $Subjlist
	do
		freesurferMasksdir="${mainfreesurferMasksdir}/${sub}"
		echo "generating cerebellum masks for ${sub}"
		wb_command -cifti-label-to-roi ${templatesdir}/Atlas_ROIs_template.2.dlabel.nii ${freesurferMasksdir}/cifti_CEREBELLUM_LEFT_aparcaseg.dscalar.nii -name CEREBELLUM_LEFT

		wb_command -cifti-label-to-roi ${templatesdir}/Atlas_ROIs_template.2.dlabel.nii ${freesurferMasksdir}/cifti_CEREBELLUM_RIGHT_aparcaseg.dscalar.nii -name CEREBELLUM_RIGHT


		wb_command -cifti-math 'x + y' ${freesurferMasksdir}/cifti_CEREBELLUM_aparcaseg.dscalar.nii -var 'x' ${freesurferMasksdir}/cifti_CEREBELLUM_LEFT_aparcaseg.dscalar.nii -var 'y' ${freesurferMasksdir}/cifti_CEREBELLUM_RIGHT_aparcaseg.dscalar.nii
	done
fi

for sub in ${Subjlist}
do
	freesurferMasksdir="${mainfreesurferMasksdir}/${sub}"
	args="${args} -cifti 
	${freesurferMasksdir}/cifti_CEREBELLUM_aparcaseg.dscalar.nii -column 1"
done

wb_command -cifti-merge ${mainfreesurferMasksdir}/CEREBELLUM_ALLSUBS.dscalar.nii ${args}

wb_command -cifti-reduce ${mainfreesurferMasksdir}/CEREBELLUM_ALLSUBS.dscalar.nii SUM ${mainfreesurferMasksdir}/CEREBELLUM_ALLSUBS_SUM.dscalar.nii

wb_command -cifti-math 'x > 0' ${mainfreesurferMasksdir}/CEREBELLUM_ALLSUBS_SUM_bin.dscalar.nii -var 'x' ${mainfreesurferMasksdir}/CEREBELLUM_ALLSUBS_SUM.dscalar.nii




echo "finished"



