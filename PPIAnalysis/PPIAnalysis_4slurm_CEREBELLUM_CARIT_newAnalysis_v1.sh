#!/bin/bash

maindir="/nafs/narr"
hcpdir="${maindir}/HCP_OUTPUT"
masksdir="${maindir}/jloureiro/Masks/PPI"
#PPI Analysis
#1- Chose contrast of interest and create PSY EV
#Go is same as HIT and NoGo is the same as MISS
Go="cond001.txt"
NoGo="cond002.txt"
NoGoCor="cond003.txt"
NoGoErr="cond004.txt"

roisdir="${maindir}/jloureiro/Masks/paper2/PPIMasks/CombinedMasks"

RoiList="ASL_Default_crusIIR ASL_Default_crusIR AvNoGoGo_CON_VIR AvNoGoGo_DAN_VIIbL AvNoGoGo_FPN_VIIbL AvNoGoGo_SMN_VIIIA_BR AvNoGoGo_SMN_V_VIR"

module load workbench/1.3.2
module load fsl

dest_dir="${maindir}/HCP_OUTPUT/${sub}/MNINonLinear/Results/task-carit_acq-PA_run-01/EVs"

if [ ! -d ${dest_dir} ]
then
	mkdir ${hcpdir}/$sub/EVs/facematching ${hcpdir}/$sub/EVs/carit
	mkdir ${hcpdir}/$sub/EVs/facematching/AP ${hcpdir}/$sub/EVs/facematching/PA ${hcpdir}/$sub/EVs/carit/PA
	cp -r -p $hcpdir/$sub/EVs/task-face_run-01/* ${hcpdir}/$sub/EVs/facematching/PA/
	cp -r -p $hcpdir/$sub/EVs/task-face_run-02/* ${hcpdir}/$sub/EVs/facematching/AP/
	cp -r -p $hcpdir/$sub/EVs/task-carit_run-01/* ${hcpdir}/$sub/EVs/carit/PA/

 	evs_dir1="${maindir}/HCP_OUTPUT/${sub}/EVs/carit/PA/*"

    	# copy files
    	mkdir ${dest_dir}
    	cp -rv ${evs_dir1} ${dest_dir}/

fi

evsdir="${maindir}/HCP_OUTPUT/${sub}/MNINonLinear/Results/task-carit_acq-PA_run-01/EVs"
cat ${evsdir}/${Go} | sed 's/1.0/-1.0 /g' > ${evsdir}/Goneg_PPI.txt
cat ${evsdir}/${NoGo} ${evsdir}/Goneg_PPI.txt > ${evsdir}/NoGo-Go_PPI.txt

rm ${evsdir}/Goneg_PPI.txt


#3- Extract time series of chosen ROI######################################################################
datadir="${maindir}/HCP_OUTPUT/${sub}/MNINonLinear/Results/task-carit_acq-PA_run-01/task-carit_acq-PA_run-01_hp2000.ica"
evsdir="${maindir}/HCP_OUTPUT/${sub}/MNINonLinear/Results/task-carit_acq-PA_run-01/EVs"
	
for roi in ${RoiList}
do
	
	
	fslmeants -i ${datadir}/filtered_func_data_clean.nii.gz -o ${evsdir}/${roi}_ts.txt -m ${roisdir}/${roi}.nii

done

echo "finished"
