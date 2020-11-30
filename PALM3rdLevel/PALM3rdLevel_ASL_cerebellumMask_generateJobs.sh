#!/bin/bash



maindir="/nafs/narr/jloureiro"
GroupList="KTP2_KTP3"
hcpdir="/nafs/narr/HCP_OUTPUT"

 
for g in ${GroupList}
do
	
    	echo "sbatch --nodes=1 --ntasks=1 --cpus-per-task=1 --mem=500G --time=7-00:00:00 --qos=largemem \
--job-name=N5000_${g} --output=/nafs/narr/jloureiro/projects/PALM3rdlevel/MDDChange_${g}Change.log --export SCALE=${g} /nafs/narr/jloureiro/scripts/fMRI/PALMAnalysis/paper_FM/PALM3rdLevel_TFCE_JL_4slurm_wFIX_MDDchange_groupChange.sh"

	#sbatch --nodes=1 --ntasks=1 --cpus-per-task=1 --mem=30G --time=1-00:00:00 \
#--job-name=${cope}${g} --output=/nafs/narr/jloureiro/projects/PALM3rdlevel/paper2/${g}_${cope}.log --export=GROUP=${g},CON=${cope} /nafs/narr/jloureiro/scripts/fMRI/paper2_FMTask/PALM3rdLevel/PALM3rdLevel_v1.sh

	sbatch --nodes=1 --ntasks=1 --cpus-per-task=1 --mem=30G --time=1-00:00:00 \
--job-name=ASL${g} --output=/nafs/narr/jloureiro/projects/PALM3rdlevel/paper2/ASL_cerebellumMask/${g}.log --export=GROUP=${g} /nafs/narr/jloureiro/scripts/fMRI/paper2_FMTask/PALM3rdLevel/PALM3rdLevel_ASL_cerebellumMask_v1.sh

done
