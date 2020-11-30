#!/bin/bash

#SBATCH -J PPI
#SBATCH -o PPI


module unload fsl
module load fsl/6.0.0


hcpdir="/nafs/narr/HCP_OUTPUT"
maindir="/nafs/narr/jloureiro"
#Subjects4FM=$(cat ${maindir}/logstxt/paper2/PPIAnalysis/Subs4PPIAnalysis_paper2_v2_ALL.txt)
#Subjects4CARIT=$(cat ${maindir}/logstxt/CARIT_task/ALLSubs4PPI.txt)
Subjects4CARIT="k000901"


for s in ${Subjects4CARIT}
do
	
    	echo "sbatch --nodes=1 --ntasks=1 --cpus-per-task=1 --mem=30G --time=7-00:00:00 \
--job-name=${s}_PPI --output=/nafs/narr/jloureiro/projects/paper2/PPIAnalysis/ExtractTS/${s}.log --export sub=${s} /nafs/narr/jloureiro/scripts/fMRI/paper2_FMTask/PPIAnalysis/PPOAnalysis_4slurm_CEREBELLUM.sh"
   
	#sbatch --nodes=1 --ntasks=1 --cpus-per-task=1 --mem=30G --time=2:00:00 \
#--job-name=${s}_PPI --output=/nafs/narr/jloureiro/projects/paper2/PPIAnalysis/ExtractTS/${s}.log --export sub=${s} /nafs/narr/jloureiro/scripts/fMRI/paper2_FMTask/PPIAnalysis/PPIAnalysis_4slurm_CEREBELLUM_newAnalysis_v1.sh

	sbatch --nodes=1 --ntasks=1 --cpus-per-task=1 --mem=30G --time=2:00:00 \
--job-name=${s}_PPI --output=/nafs/narr/jloureiro/projects/paper2/PPIAnalysis/ExtractTS/CARIT_${s}.log --export sub=${s} /nafs/narr/jloureiro/scripts/fMRI/paper2_FMTask/PPIAnalysis/PPIAnalysis_4slurm_CEREBELLUM_CARIT_newAnalysis_v1.sh

done

echo "finished"
