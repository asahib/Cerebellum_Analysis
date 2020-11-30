#!/bin/bash

#SBATCH -J PALM_PPI
#SBATCH -o PALM_PPI


module unload fsl
module load fsl/6.0.0


hcpdir="/nafs/narr/HCP_OUTPUT"
maindir="/nafs/narr/jloureiro"
copeList="cope6 cope7 cope8 cope9 cope10 cope11 cope1 cope2 cope3 cope4 cope5"
#copeList="cope6"
ROIList="R_caudalanteriorcingulate_paper2 R_isthmuscingulate_paper2 rostralanteriorcingulate+medialorbitofrontal_paper2"
#ROIList="R_caudalanteriorcingulate_paper2"
#GroupList="KTP1_KTP2 KTP1_KTP3 KTP2_KTP3"
GroupList="KTP2_KTP3"

for group in ${GroupList}
do
	for roi in ${ROIList}
	do

		for con in ${copeList}
		do
    			echo "sbatch --nodes=1 --ntasks=1 --cpus-per-task=1 --mem=300G --time=7-00:00:00 \
--job-name=PALM_PPIAnalysis_${con} --output=/nafs/narr/jloureiro/projects/PALM_PPI/PALM_PPI_${con}.log --export COPE=${con} /nafs/narr/jloureiro/scripts/fMRI/PPIAnalysis/PALM3rdLevel_TFCE_JL_4slurm_wFIX_PPIAnalysis_MDDTP1_MDDTP3_generateJobs.sh"
   
			sbatch --nodes=1 --ntasks=1 --cpus-per-task=1 --mem=30G --time=7-00:00:00 \
--job-name=${con}${roi} --output=/nafs/narr/jloureiro/projects/paper2/PPIAnalysis/PALM_PPI/PALM_PPI_${con}_${roi}_${group}.log --export=COPE=${con},PPIroi=${roi} /nafs/narr/jloureiro/scripts/fMRI/paper2_FMTask/PPIAnalysis/PALM3rdLevel_TFCE_JL_4slurm_wFIX_PPIAnalysis_${group}.sh

		done
	done
done

echo "finished"
