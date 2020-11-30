#!/bin/bash

#SBATCH -J PALM_PPI
#SBATCH -o PALM_PPI


module unload fsl
module load fsl/6.0.0


hcpdir="/nafs/narr/HCP_OUTPUT"
maindir="/nafs/narr/jloureiro"
copeList="cope6 cope7 cope8"
PPIROIs="Right_V Left_V Right_VI Left_VI Left_VIIb Right_VIIb"
#copeList="cope7"
#PPIROIs="Right_VIIb"


for r in ${PPIROIs}
do

	for con in ${copeList}
	do
    		echo "sbatch --nodes=1 --ntasks=1 --cpus-per-task=1 --mem=300G --time=7-00:00:00 \
--job-name=PALM_PPIAnalysis_${con} --output=/nafs/narr/jloureiro/projects/PALM_PPI/PALM_PPI_${con}.log --export COPE=${con} /nafs/narr/jloureiro/scripts/fMRI/PPIAnalysis/PALM3rdLevel_TFCE_JL_4slurm_wFIX_PPIAnalysis_MDDTP1_MDDTP3_generateJobs.sh"
   
		sbatch --nodes=1 --ntasks=1 --cpus-per-task=1 --mem=30G --time=1-00:00:00 \
--job-name=${r}${con} --output=/nafs/narr/jloureiro/projects/paper2/PPIAnalysis/PolarPlotsExtractBetas/Betas_${con}_${r}.log --export=cope=${con},ppiroi=${r} /nafs/narr/jloureiro/scripts/fMRI/paper2_FMTask/PPIAnalysis/PolarPlotsPPI/ExtractBetas_freesurferasks.sh

	done
done

echo "finished"
