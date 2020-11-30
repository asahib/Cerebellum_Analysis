#!/bin/bash


#/ifshome/ewood/code/SFARI_RS/generate_jobs.sh
#fairshare
#http://cdoc.bmap.ucla.edu/compute/quickstart.html
#rsync -avz --exclude 'Analysis_JL/DATA'  Analysis_JL/*  cl.bmap.ucla.edu:/nafs/narr/jloureiro/
#rsync -avz --exclude 'Analysis_JL/DATA'  Analysis_JL/scripts/*  cl.bmap.ucla.edu:/nafs/narr/jloureiro/scripts/

Subjlist=$(</nafs/narr/jloureiro/CEREBELLUM/ALLKet.txt) #Space delimited list of subject IDs
#Subjlist="k000801 k000802"

hcpdir="/nafs/narr/HCP_OUTPUT"

 
for line in ${Subjlist}
do
    echo "sbatch --nodes=1 --ntasks=1 --cpus-per-task=1 --mem=250G --time=7-00:00:00 \
--output=/nafs/narr/jloureiro/projects/DenseConnectome/${line}.log --export BATCH_SUB=${line} /nafs/narr/jloureiro/scripts/fMRI/CEREBELLUM/DenseConnectome.sh"


	sbatch --nodes=1 --ntasks=1 --cpus-per-task=1 --mem=80G --time=7-00:00:00 \
--output=/nafs/narr/jloureiro/projects/DenseConnectome/${line}.log --export BATCH_SUB=${line} /nafs/narr/jloureiro/scripts/fMRI/CEREBELLUM/DenseConnectme.sh

done
