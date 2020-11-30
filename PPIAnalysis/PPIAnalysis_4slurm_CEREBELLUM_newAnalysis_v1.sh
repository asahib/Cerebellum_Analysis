#!/bin/bash

maindir="/nafs/narr"
hcpdir="${maindir}/HCP_OUTPUT"
masksdir="${maindir}/jloureiro/Masks/PPI"
#PPI Analysis
#1- Chose contrast of interest and create PSY EV
neutral="cond002.txt"
fearful="cond003.txt"
happy="cond001.txt"
objects="cond004.txt"

DirectionList=""
DirectionList="${DirectionList} AP"
DirectionList="${DirectionList} PA"
roisdir="${maindir}/jloureiro/Masks/paper2/PPIMasks/CombinedMasks"

funcmask="KTP1_KTP3_cope2c1maskfwep005"
RoiList="ASL_Default ASL_Frontoparietal Happy_neutral_Somatomotor Fearful_neutral_Default NoGo_Go_Visual2"

module load workbench/1.3.2
module load fsl


for dir in ${DirectionList}
do

	dest_dir="${maindir}/HCP_OUTPUT/${sub}/MNINonLinear/Results/task-facematching_acq-${dir}_run-01/EVs"

	if [ ! -d ${dest_dir} ]
	then
		mkdir ${hcpdir}/$sub/EVs/facematching ${hcpdir}/$sub/EVs/carit
		mkdir ${hcpdir}/$sub/EVs/facematching/AP ${hcpdir}/$sub/EVs/facematching/PA ${hcpdir}/$sub/EVs/carit/PA
		cp -r -p $hcpdir/$sub/EVs/task-face_run-01/* ${hcpdir}/$sub/EVs/facematching/PA/
		cp -r -p $hcpdir/$sub/EVs/task-face_run-02/* ${hcpdir}/$sub/EVs/facematching/AP/
		cp -r -p $hcpdir/$sub/EVs/task-carit_run-01/* ${hcpdir}/$sub/EVs/carit/PA/

 		evs_dir1="${maindir}/HCP_OUTPUT/${sub}/EVs/facematching/${dir}/*"

    		# copy files
    		mkdir ${dest_dir}
    		cp -rv ${evs_dir1} ${dest_dir}/

	fi

	evsdir="${maindir}/HCP_OUTPUT/${sub}/MNINonLinear/Results/task-facematching_acq-${dir}_run-01/EVs"
	cat ${evsdir}/${neutral} | sed 's/1.0/-1.0 /g' > ${evsdir}/neutralneg_PPI.txt
	cat ${evsdir}/${fearful} ${evsdir}/neutralneg_PPI.txt > ${evsdir}/fearful-neutral_PPI.txt
	cat ${evsdir}/${happy} ${evsdir}/neutralneg_PPI.txt > ${evsdir}/happy-neutral_PPI.txt

	rm ${evsdir}/neutralneg_PPI.txt
	
done


#3- Extract time series of chosen ROI######################################################################
for dir in ${DirectionList}
do
	datadir="${maindir}/HCP_OUTPUT/${sub}/MNINonLinear/Results/task-facematching_acq-${dir}_run-01/task-facematching_acq-${dir}_run-01_hp2000.ica"
	evsdir="${maindir}/HCP_OUTPUT/${sub}/MNINonLinear/Results/task-facematching_acq-${dir}_run-01/EVs"
	
	for roi in ${RoiList}
	do
	
	
		fslmeants -i ${datadir}/filtered_func_data_clean.nii.gz -o ${evsdir}/${roi}_ts.txt -m ${roisdir}/${roi}.nii

	done
	
done
echo "finished"
