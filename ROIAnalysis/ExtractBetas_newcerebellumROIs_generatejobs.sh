#!/bin/bash


#SBATCH -J ExtractBetas_paper2

maindir="/nafs/narr/jloureiro"
#Subjlist=$(<$maindir/logstxt/SubsALL.txt) #Space delimited list of subject IDs
#PPIROIs="ASL_Default ASL_Frontoparietal"
PPIROIs="AvNoGoGo_DAN_VIIbL AvNoGoGo_SMN_VIIIA_BR AvNoGoGo_SMN_V_VIR"
#PPIROIs="ASL_Default_crusIIR"
#PPIROIs="happyfearful-neutral_ASL_Frontoparietal happyfearful-neutral_ASL_Default happyfearful-neutral_Happy_neutral_Somatomotor happyfearful-neutral_Fearful_neutral_Default happyfearful-neutral_NoGo_Go_Visual2"
#PPIROIs="ASL_Default"


#Emotional contrasts ppi:
#CopeList="cope4 cope5"
#NoGoGo PPI coontrasts:
#CopeList="cope3"

hcpdir="/nafs/narr/HCP_OUTPUT"

for proi in ${PPIROIs}
do

		echo "sbatch --nodes=1 --ntasks=1 --cpus-per-task=1 --mem=30G --time=10:00:00 \
--job-name=ic${proi} --output=/nafs/narr/jloureiro/projects/paper2/ExtractBetas_FMtask_individualCon_${proi}.log --export=PPIROI=${proi} /nafs/narr/jloureiro/scripts/fMRI/paper2_FMTask/ROIAnalysis/ExtractBetas_newcerebellumROIs_FMtask_IndividualCon_individualNetROIs.sh"

		#sbatch --nodes=1 --ntasks=1 --cpus-per-task=1 --mem=30G --time=10:00:00 \
#--job-name=ic${proi} --output=/nafs/narr/jloureiro/projects/paper2/ExtractBetas_FMtask_individualCon_${proi}.log --export=PPIROI=${proi} /nafs/narr/jloureiro/scripts/fMRI/paper2_FMTask/ROIAnalysis/ExtractBetas_newcerebellumROIs_FMtask_IndividualCon_individualNetROIs.sh

		#sbatch --nodes=1 --ntasks=1 --cpus-per-task=1 --mem=30G --time=10:00:00 \
#--job-name=ec${proi} --output=/nafs/narr/jloureiro/projects/paper2/ExtractBetas_FMtask_emotionalCon_${proi}.log --export=PPIROI=${proi} /nafs/narr/jloureiro/scripts/fMRI/paper2_FMTask/ROIAnalysis/ExtractBetas_newcerebellumROIs_FMtask_EmotionalCon.sh

		#sbatch --nodes=1 --ntasks=1 --cpus-per-task=1 --mem=30G --time=10:00:00 \
#--job-name=iec${proi} --output=/nafs/narr/jloureiro/projects/paper2/ExtractBetas_FMtask_emotionalCon_individualNetROIs_${proi}.log --export=PPIROI=${proi} /nafs/narr/jloureiro/scripts/fMRI/paper2_FMTask/ROIAnalysis/ExtractBetas_newcerebellumROIs_FMtask_EmotionalCon_individualNetROIs.sh

		sbatch --nodes=1 --ntasks=1 --cpus-per-task=1 --mem=30G --time=10:00:00 \
--job-name=c${proi} --output=/nafs/narr/jloureiro/projects/paper2/ExtractBetas_CARITtask_${proi}.log --export=cope=${c},PPIROI=${proi} /nafs/narr/jloureiro/scripts/fMRI/paper2_FMTask/ROIAnalysis/ExtractBetas_newcerebellumROIs_CARITtask_v3_wcereb.sh

		#sbatch --nodes=1 --ntasks=1 --cpus-per-task=1 --mem=30G --time=10:00:00 \
#--job-name=ic${proi} --output=/nafs/narr/jloureiro/projects/paper2/ExtractBetas_CARITtask_individualNetROIs_${proi}.log --export=cope=${c},PPIROI=${proi} /nafs/narr/jloureiro/scripts/fMRI/paper2_FMTask/ROIAnalysis/ExtractBetas_newcerebellumROIs_CARITtask_individualNetROIs.sh
	
done
