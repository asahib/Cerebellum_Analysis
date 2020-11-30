#!/bin/bash


#SBATCH -J ExtractBetas_paper2

maindir="/nafs/narr/jloureiro"
#Subjlist=$(<$maindir/logstxt/SubsALL.txt) #Space delimited list of subject IDs

CopeList="cope1 cope3 cope4"
#CopeList="cope2"
hcpdir="/nafs/narr/HCP_OUTPUT"

 
for c in ${CopeList}
do
    echo "sbatch --nodes=1 --ntasks=1 --cpus-per-task=1 --mem=30G --time=7-00:00:00 \
--job-name=Neutralc1${c} --output=/nafs/narr/jloureiro/projects/paper2/ExtractBetas_KTP1_KTP3_${c}.log --export=cope=${c} /nafs/narr/jloureiro/scripts/fMRI/ROIAnalysis/paper2/ExtractBetas_KTP1_KTP3_cope2_subcortical_c1.sh"

	#sbatch --nodes=1 --ntasks=1 --cpus-per-task=1 --mem=30G --time=7-00:00:00 \
#--job-name=${c}c1 --output=/nafs/narr/jloureiro/projects/paper2/ExtractBetas_KTP1_KTP3_${c}.log --export=cope=${c} /nafs/narr/jloureiro/scripts/fMRI/paper2_FMTask/ROIAnalysis/ExtractBetas_KTP1_KTP3_cope2_cerebellum_c1.sh

	#sbatch --nodes=1 --ntasks=1 --cpus-per-task=1 --mem=30G --time=7-00:00:00 \
#--job-name=${c}c1 --output=/nafs/narr/jloureiro/projects/paper2/ExtractBetas_KTP1_KTP3_${c}_vol.log --export=cope=${c} /nafs/narr/jloureiro/scripts/fMRI/paper2_FMTask/ROIAnalysis/ExtractBetas_KTP1_KTP3_cope2_cerebellum_c1_vol.sh

	#sbatch --nodes=1 --ntasks=1 --cpus-per-task=1 --mem=30G --time=7-00:00:00 \
#--job-name=${c}c1 --output=/nafs/narr/jloureiro/projects/paper2/ExtractBetas_KTP1_KTP3_${c}_allcerbROIs.log --export=cope=${c} /nafs/narr/jloureiro/scripts/fMRI/paper2_FMTask/ROIAnalysis/ExtractBetas_KTP1_KTP3_cope2_cerebellum_c1_funcMasktest.sh

	#sbatch --nodes=1 --ntasks=1 --cpus-per-task=1 --mem=30G --time=7-00:00:00 \
#--job-name=2${c}c2 --output=/nafs/narr/jloureiro/projects/paper2/ExtractBetas_KTP1_KTP2_cope2c2_${c}.log --export=cope=${c} /nafs/narr/jloureiro/scripts/fMRI/paper2_FMTask/ROIAnalysis/ExtractBetas_KTP1_KTP2_cope2_cortical_c2.sh

	#sbatch --nodes=1 --ntasks=1 --cpus-per-task=1 --mem=30G --time=7-00:00:00 \
#--job-name=1${c}c2 --output=/nafs/narr/jloureiro/projects/paper2/ExtractBetas_KTP1_KTP2_cope1c2_${c}.log --export=cope=${c} /nafs/narr/jloureiro/scripts/fMRI/paper2_FMTask/ROIAnalysis/ExtractBetas_KTP1_KTP2_cope1_cortical_c2.sh

	sbatch --nodes=1 --ntasks=1 --cpus-per-task=1 --mem=30G --time=7-00:00:00 \
--job-name=1${c}c2 --output=/nafs/narr/jloureiro/projects/paper2/ExtractBetas_KTP1_KTP2_cope3c2_${c}.log --export=cope=${c} /nafs/narr/jloureiro/scripts/fMRI/paper2_FMTask/ROIAnalysis/ExtractBetas_KTP1_KTP2_cope3_cortical_c2.sh

	sbatch --nodes=1 --ntasks=1 --cpus-per-task=1 --mem=30G --time=7-00:00:00 \
--job-name=1${c}c2 --output=/nafs/narr/jloureiro/projects/paper2/ExtractBetas_KTP2_KTP3_cope2c1_${c}.log --export=cope=${c} /nafs/narr/jloureiro/scripts/fMRI/paper2_FMTask/ROIAnalysis/ExtractBetas_KTP2_KTP3_cope2_cortical_c1.sh


done
