#!/bin/sh

hcpdir="/nafs/narr/HCP_OUTPUT"
maindir="/nafs/narr/jloureiro"
StudyFolder="${hcpdir}" #Location of Subject folders (named by subjectID)
Subjlist=$(<$maindir/logstxt/paper2/PPIAnalysis/ALLSubswithPPI_cerebellum.txt) #Space delimited list of subject IDs
echo "$Subjlist" 

EnvironmentScript="${maindir}/scripts/Pipelines-3.22.0/Examples/Scripts/SetUpHCPPipeline_JL_4slurm.sh"

source ${EnvironmentScript}

module load workbench/1.3.2

ROIMasksdir="${maindir}/Masks/paper2/ColeAnticevicMasks"
MERGENets="NO"
#logdir="${maindir}/logstxt/paper2/PPIAnalysis/Extractbetas/EmotionalCons"

if [ ${MERGENets} = "YES" ]; then

	Networks="Auditory Default Frontoparietal Orbito-Affective Somatomotor Cingulo-Opercular Dorsal-attention Language Posterior-Multimodal Ventral-Multimodal Visual1 Visual2"
	args=""

	for net in ${Networks}; do

		args="${args} -cifti ${ROIMasksdir}/${net}/Cortex_${net}.dscalar.nii "
	done

	wb_command -cifti-merge ${ROIMasksdir}/MERGEDROIs_AnticevicNetworks.dscalar.nii ${args} 
fi
	
CopeList="cope3"
Networks="Default Frontoparietal Somatomotor Visual2"		
logdir="${maindir}/logstxt/paper2/PPIAnalysis/Extractbetas"

for net in ${Networks}
do	
	ROIMasksdir="${maindir}/Masks/paper2/ColeAnticevicMasks/${net}/IndividualRegions"
	for cope in ${CopeList}
	do

		logfile="${logdir}/MERGEDROIs_Cortex_AnticevicNetworks_CARIT${cope}_${net}ROIs_${PPIROI}.txt"
		if [ -f ${logfile} ]; then
			rm ${logfile}
		fi

		for sub in ${Subjlist}
		do

			imagesdir="${hcpdir}/${sub}/MNINonLinear"
			betaimgsdir="${imagesdir}/Results/task-carit_acq-PA_run-01/task-carit_acq-PA_run-01_JL_clean_PPIAnalysis_${PPIROI}_hp200_s5_level1.feat/GrayordinatesStats"
	
			wb_command -cifti-stats ${betaimgsdir}/${cope}.dtseries.nii -reduce MEAN -roi ${ROIMasksdir}/MERGEDROIs_${net}.dscalar.nii >> ${logfile}
	
		done
	done
done


echo "finished"


