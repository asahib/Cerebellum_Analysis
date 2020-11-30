#!/bin/bash

#SBATCH -J PALM_PPI
#SBATCH -o PALM_PPI


module unload fsl
module load fsl/6.0.0


hcpdir="/nafs/narr/HCP_OUTPUT"
maindir="/nafs/narr/jloureiro"
#copeList="cope6 cope7 cope8 cope9 cope10 cope11 cope1 cope2 cope3 cope4 cope5"
#copeList="cope6 cope7 cope8"
copeList="cope6"

#ROIList="ASL_Default ASL_Frontoparietal Happy_neutral_Somatomotor Fearful_neutral_Default NoGo_Go_Visual2"
ROIList="ASL_Default"

#GroupList="KTP1_KTP2 KTP1_KTP3 KTP2_KTP3"
GroupList="KTP1_KTP2"

for g in ${GroupList}
do
	for roi in ${ROIList}
	do

		for con in ${copeList}
		do
    			echo "sbatch --nodes=1 --ntasks=1 --cpus-per-task=1 --mem=300G --time=7-00:00:00 \
--job-name=PALM_PPIAnalysis_${con} --output=/nafs/narr/jloureiro/projects/PALM_PPI/PALM_PPI_${con}.log --export COPE=${con} /nafs/narr/jloureiro/scripts/fMRI/PPIAnalysis/PALM3rdLevel_TFCE_JL_4slurm_wFIX_PPIAnalysis_MDDTP1_MDDTP3_generateJobs.sh"
   
			sbatch --nodes=1 --ntasks=1 --cpus-per-task=1 --mem=30G --time=1-00:00:00 \
--job-name=${r}${g}${con} --output=/nafs/narr/jloureiro/projects/paper2/PPIAnalysis/PALM_PPI/CerebellumROIs/PALM_PPI_${con}_${roi}_${g}.log --export=COPE=${con},PPIroi=${roi},group=${g} /nafs/narr/jloureiro/scripts/fMRI/paper2_FMTask/PPIAnalysis/PALM3rdLevel_TFCE_JL_4slurm_wFIX_PPIAnalysis_CerebellumROIs_v2.sh
		done

		
	done
done

echo "finished"
