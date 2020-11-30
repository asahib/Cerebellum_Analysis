#!/bin/bash

#SBATCH -J PALM_PPI
#SBATCH -o PALM_PPI

hcpdir="/nafs/narr/HCP_OUTPUT"
maindir="/nafs/narr/jloureiro"

copeList="cope3"
#copeList="cope3"

ROIList="AvNoGoGo_CON_VIR AvNoGoGo_DAN_VIIbL AvNoGoGo_FPN_VIIbL AvNoGoGo_SMN_VIIIA_BR AvNoGoGo_SMN_V_VIR"
#ROIList="AvNoGoGo_FPN_VIIbL"
#GroupList="KTP1_KTP3"
#GroupList="KTP1_KTP3 KTP1_KTP2 KTP2_KTP3"
#GroupList="KTP1mean KTP2mean KTP3mean HCmean KTP1_HCmean"
#GroupList="KTP1_HC"
GroupList="PPITP1_TP3_HAMDTP1_TP3"

for g in ${GroupList}
do
	for roi in ${ROIList}
	do

		for con in ${copeList}
		do
    			echo "sbatch --nodes=1 --ntasks=1 --cpus-per-task=1 --mem=300G --time=7-00:00:00 \
--job-name=PALM_PPIAnalysis_${con} --output=/nafs/narr/jloureiro/projects/PALM_PPI/PALM_PPI_${con}.log --export COPE=${con} /nafs/narr/jloureiro/scripts/fMRI/PPIAnalysis/PALM3rdLevel_TFCE_JL_4slurm_wFIX_PPIAnalysis_MDDTP1_MDDTP3_generateJobs.sh"
   
			#sbatch --nodes=1 --ntasks=1 --cpus-per-task=1 --mem=30G --time=4-00:00:00 \
#--job-name=wMP${roi} --output=/nafs/narr/jloureiro/projects/CARIT/PPIAnalysis/PALM/PALM_PPI_${con}_${roi}_${g}.log --export=COPE=${con},PPIroi=${roi},group=${g} /nafs/narr/jloureiro/scripts/fMRI/paper2_FMTask/PPIAnalysis/PALM3rdLevel_TFCE_JL_4slurm_wFIX_PPIAnalysis_NoGoGoSeeds_wFuncMask_CARIT.sh

			#sbatch --nodes=1 --ntasks=1 --cpus-per-task=1 --mem=30G --time=4-00:00:00 \
#--job-name=nMP${roi} --output=/nafs/narr/jloureiro/projects/CARIT/PPIAnalysis/PALM/PALM_PPI_nomask_${con}_${roi}_${g}.log --export=COPE=${con},PPIroi=${roi},group=${g} /nafs/narr/jloureiro/scripts/fMRI/paper2_FMTask/PPIAnalysis/PALM3rdLevel_TFCE_JL_4slurm_wFIX_PPIAnalysis_NoGoGoSeeds_noMask_CARIT.sh

			#sbatch --nodes=1 --ntasks=1 --cpus-per-task=1 --mem=30G --time=4-00:00:00 \
#--job-name=wMM${roi} --output=/nafs/narr/jloureiro/projects/CARIT/PPIAnalysis/PALM/PALM_PPI_${con}_${roi}_${g}.log --export=COPE=${con},PPIroi=${roi},group=${g} /nafs/narr/jloureiro/scripts/fMRI/paper2_FMTask/PPIAnalysis/PALM3rdLevel_MEAN_TFCE_JL_4slurm_wFIX_PPIAnalysis_NoGoGoSeeds_wFuncMask_CARIT.sh

			#sbatch --nodes=1 --ntasks=1 --cpus-per-task=1 --mem=30G --time=4-00:00:00 \
#--job-name=nMM${roi} --output=/nafs/narr/jloureiro/projects/CARIT/PPIAnalysis/PALM/PALM_PPI_noMask_${con}_${roi}_${g}.log --export=COPE=${con},PPIroi=${roi},group=${g} /nafs/narr/jloureiro/scripts/fMRI/paper2_FMTask/PPIAnalysis/PALM3rdLevel_MEAN_TFCE_JL_4slurm_wFIX_PPIAnalysis_NoGoGoSeeds_noMask_CARIT.sh

			sbatch --nodes=1 --ntasks=1 --cpus-per-task=1 --mem=30G --time=4-00:00:00 \
--job-name=wMC${roi} --output=/nafs/narr/jloureiro/projects/CARIT/PPIAnalysis/PALM/PALM_PPI_${con}_${roi}_${g}.log --export=COPE=${con},PPIroi=${roi},group=${g} /nafs/narr/jloureiro/scripts/fMRI/paper2_FMTask/PPIAnalysis/PALM3rdLevel_TFCE_JL_4slurm_wFIX_PPIAnalysis_NoGoGoSeeds_wFuncMask_CARIT_PPIchange_HAMDchange.sh

			sbatch --nodes=1 --ntasks=1 --cpus-per-task=1 --mem=30G --time=4-00:00:00 \
--job-name=nMC${roi} --output=/nafs/narr/jloureiro/projects/CARIT/PPIAnalysis/PALM/PALM_PPI_nomask_${con}_${roi}_${g}.log --export=COPE=${con},PPIroi=${roi},group=${g} /nafs/narr/jloureiro/scripts/fMRI/paper2_FMTask/PPIAnalysis/PALM3rdLevel_TFCE_JL_4slurm_wFIX_PPIAnalysis_NoGoGoSeeds_noMask_CARIT_PPIchange_HAMDchange.sh

		done
		
	done
done

echo "finished"
