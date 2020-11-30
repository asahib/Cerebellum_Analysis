#!/bin/sh

hcpdir="/nafs/narr/HCP_OUTPUT"
maindir="/nafs/narr/jloureiro"
HCPPIPEDIR="${maindir}/scripts/Pipelines-3.22.0"

StudyFolder="${hcpdir}" #Location of Subject folders (named by subjectID)
#Subjlist=$(<$maindir/logstxt/papper2/PPIAnalysis/Subs4PPIAnalyis.txt) #Space delimited list of subject IDs
#Subjlist="k000801 k000802"
echo "$Subjlist" 

mainfreesurferMasksdir="${maindir}/Masks/freesurferSeg/template"

EnvironmentScript="${maindir}/scripts/Pipelines-3.22.0/Examples/Scripts/SetUpHCPPipeline_JL_4slurm.sh"

source ${EnvironmentScript}

module load workbench/1.3.2

templatesdir="${maindir}/scripts/Pipelines-3.22.0/global/templates/91282_Greyordinates"
AverageDatadir="${maindir}/AverageData/HC_n34/MNINonLinear/fsaverage_LR32k"



#VARIABLES TO BE CHANGED##################################################################################

groupzstatdir="${maindir}/PALM3rdLevel/FM/paper2"

groupzstat="KTP2_KTP3"
#groupzstat="KTP1_KTP2"
#groupzstat="KTP1_KTP3"

CopeMask="cope2"
#CopeMask="cope3"
#CopeMask="cope1"
#ConMask="c2"
ConMask="c1"

#corrp="uncp" #"fwep" if corrected
corrp="fwep"
#pvalue="001" #"oo5" if corrected
pvalue="005"
FuncMasksdir="${maindir}/Masks/paper2/FuncMasks"
mainCombinedMasksdir="${maindir}/Masks/paper2/PPIMasks/ROIs4PolarPlots"
FuncMaskname="${groupzstat}_${CopeMask}${ConMask}mask${corrp}${pvalue}"

logdir="${maindir}/logstxt/ROIAnalysis/paper/${FuncMaskname}"
mkdir ${logdir}

SubcorticalROI="NO" #"NO" if cortical ROI

#Subcortical ROIs:

ROIList="AMYGDALA_RIGHT HIPPOCAMPUS_RIGHT"


#Cortical ROIs:
#ROIList="R_lateraloccipital R_precentral R_inferiorparietal R_rostralmiddlefrontal R_precuneus R_superiortemporal"
#ROIList="R_rostralanteriorcingulate R_medialorbitofrontal R_isthmuscingulate R_superiorfrontal PALLIDUM_RIGHT"
ROIList="R_rostralmiddlefrontal L_rostralmiddlefrontal R_precentral L_precentral R_medialorbitofrontal L_medialorbitofrontal R_rostralanteriorcingulate L_rostralanteriorcingulate R_precuneus L_precuneus R_insula L_insula CAUDATE_RIGHT CAUDATE_LEFT PALLIDUM_RIGHT PALLIDUM_LEFT PUTAMEN_RIGHT PUTAMEN_LEFT HIPPOCAMPUS_RIGHT HIPPOCAMPUS_LEFT AMYGDALA_RIGHT AMYGDALA_LEFT "
MergeROIs="YES" #"YES" if more than one ROI to merge at the end

FuncMasks="NO"
MakeMasks="YES" #YES if we want to isolate freesurfer masks
createPercChange="NO"
MakeCombinedMasks="NO"



#Get clusters from crossectional analysis - functional masks #####################################################################
if [ ${FuncMasks} = "YES" ]
then 
	#for fearful > neutral c2 (MDD > HC) vol min= 800mm3 (100 voxels)##############################
	#wb_command -cifti-math 'x > 1.3' ${FuncMasksdir}/${FuncMaskname}.dscalar.nii -var 'x' ${groupzstatdir}/${groupzstat}/${CopeMask}/results_dense_tfce_ztstat_${corrp}_${ConMask}.dscalar.nii
wb_command -cifti-math 'x > 2' ${FuncMasksdir}/${FuncMaskname}.dscalar.nii -var 'x' ${groupzstatdir}/${groupzstat}/${CopeMask}/results_dense_tfce_ztstat_${corrp}_${ConMask}.dscalar.nii
wb_command -cifti-create-dense-from-template ${templatesdir}/Atlas_ROIs_labels.2.dlabel.nii ${FuncMasksdir}/${FuncMaskname}.dscalar.nii -cifti ${FuncMasksdir}/${FuncMaskname}.dscalar.nii
fi


#1- Isolate ROI masks from aparc+aseg image and combine structural and functional rois#############################################

if [ ${MakeMasks} = "YES" ]
then 

echo "Generating masks from aparc+aseg"
				
for mask in $ROIList
do			
wb_command -cifti-label-to-roi ${templatesdir}/Atlas_ROIs_labels.2.dlabel.nii ${mainfreesurferMasksdir}/cifti_${mask}_aparcaseg.dscalar.nii -name ${mask}
if [ ${MakeCombinedMasks} = "YES" ]
then
wb_command -cifti-math 'x * y' ${mainCombinedMasksdir}/combined_${mask}_${FuncMaskname}.dscalar.nii -var 'x' ${mainfreesurferMasksdir}/cifti_${mask}_aparcaseg.dscalar.nii -var 'y' ${FuncMasksdir}/${FuncMaskname}.dscalar.nii
fi
done

	
fi


			




