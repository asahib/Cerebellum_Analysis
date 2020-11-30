#!/bin/sh

hcpdir="/nafs/narr/HCP_OUTPUT"
maindir="/nafs/narr/jloureiro"
StudyFolder="${hcpdir}" #Location of Subject folders (named by subjectID)
Subjlist=$(<$maindir/logstxt/paper2/PPIAnalysis/ALLSubswithPPI_cerebellum.txt) #Space delimited list of subject IDs
echo "$Subjlist" 

EnvironmentScript="${maindir}/scripts/Pipelines-3.22.0/Examples/Scripts/SetUpHCPPipeline_JL_4slurm.sh"

source ${EnvironmentScript}

module load workbench/1.3.2


MERGENets="NO"
#logdir="${maindir}/logstxt/paper2/PPIAnalysis/Extractbetas/EmotionalCons"
#Networks="Auditory Default Frontoparietal Orbito-Affective Somatomotor Cingulo-Opercular Dorsal-attention Language Posterior-Multimodal Ventral-Multimodal Visual1 Visual2"
Networks="Default Frontoparietal Somatomotor Visual2"
CopeList="cope4 cope5"		
logdir="${maindir}/logstxt/paper2/PPIAnalysis/Extractbetas"

for net in ${Networks}
do	
	ROIMasksdir="${maindir}/Masks/paper2/ColeAnticevicMasks/${net}/IndividualRegions"
	for cope in ${CopeList}
	do

		logfile="${logdir}/MERGEDROIs_Cortex_AnticevicNetworks_FM${cope}_${net}ROIs_${PPIROI}.txt"
		if [ -f ${logfile} ]; then
			rm ${logfile}
		fi

		for sub in ${Subjlist}
		do

			imagesdir="${hcpdir}/${sub}/MNINonLinear"
			betaimgsdir="${imagesdir}/Results/task-facematching_JL_level2_20cons_clean_PPIAnalysis_${PPIROI}/task-facematching_JL_20cons_clean_hp200_s5_level2.feat"
			
			cp ${betaimgsdir}/${sub}_task-facematching_JL_20cons_clean_level2_beta_PPIhappy-neutral_hp200_s5.dscalar.nii ${betaimgsdir}/${sub}_task-facematching_JL_20cons_clean_level2_cope4_hp200_s5.dscalar.nii
			cp ${betaimgsdir}/${sub}_task-facematching_JL_20cons_clean_level2_beta_PPIfearful-neutral_hp200_s5.dscalar.nii ${betaimgsdir}/${sub}_task-facematching_JL_20cons_clean_level2_cope5_hp200_s5.dscalar.nii
	
			wb_command -cifti-stats ${betaimgsdir}/${sub}_task-facematching_JL_20cons_clean_level2_${cope}_hp200_s5.dscalar.nii -reduce MEAN -roi ${ROIMasksdir}/MERGEDROIs_${net}.dscalar.nii >> ${logfile}
	
		done
	done

done
echo "finished"


