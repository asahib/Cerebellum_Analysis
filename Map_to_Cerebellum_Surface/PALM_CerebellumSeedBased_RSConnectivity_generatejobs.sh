#!/bin/bash


#/ifshome/ewood/code/SFARI_RS/generate_jobs.sh
#fairshare
#http://cdoc.bmap.ucla.edu/compute/quickstart.html
#rsync -avz --exclude 'Analysis_JL/DATA'  Analysis_JL/*  cl.bmap.ucla.edu:/nafs/narr/jloureiro/
#rsync -avz --exclude 'Analysis_JL/DATA'  Analysis_JL/scripts/*  cl.bmap.ucla.edu:/nafs/narr/jloureiro/scripts/


hcpdir="/nafs/narr/HCP_OUTPUT"

ROIlist="faces-objects_fwep13bin_x162_y128_z110 faces-objects_fwep13bin_x245_y226_z224 faces-objects_fwep13bin_x346_y336_z318 faces-objects_fwep13bin_x458_y432_z421 fearful-neutral_23zstatbin_x134_y122_z121 fearful-neutral_23zstatbin_x228_y223_z217 GONOGO_fwep13bin_x135_y139_z126 GONOGO_fwep13bin_x237_y230_z210  happy-neutral_23zstatbin_x154_y126_z117"
#ROIlist="faces-objects_fwep13bin_x245_y226_z224"
#Grouplist="HC_MDDTP1 KetTP1_KetTP3 ECTTP1_ECTTP2 MDDTP1_MDDTP3 KetTP1_KetTP2"
Grouplist="ECTTP1_ECTTP2"

for group in ${Grouplist}
do
 
	for mask in ${ROIlist}
	do
   		echo "sbatch --nodes=1 --ntasks=1 --cpus-per-task=1 --mem=80G --time=7-00:00:00 \
--output=/nafs/narr/jloureiro/projects/PALM_DenseConnectome/${group}_${mask}_SeedBased.log --export roi=${mask} --export group=${group} /nafs/narr/jloureiro/scripts/fMRI/CEREBELLUM/PALM_CerebellumSeedBased_RSConnectivity.sh"


		sbatch --nodes=1 --ntasks=1 --cpus-per-task=1 --mem=80G --time=7-00:00:00 \
--output=/nafs/narr/jloureiro/projects/PALM_DenseConnectome/${group}_${mask}_SeedBased.log --export=roi=${mask},group=${group} /nafs/narr/jloureiro/scripts/fMRI/CEREBELLUM/PALM_CerebellumSeedBased_RSConnectivity.sh

	done
done
