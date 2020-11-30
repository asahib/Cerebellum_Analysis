#!/bin/bash

maindir="/nafs/narr"
masksdir="${maindir}/jloureiro/Masks/PPI"
#PPI Analysis
#1- Chose contrast of interest and create PSY EV
neutral="cond002.txt"
fearful="cond003.txt"
happy="cond001.txt"
objects="cond004.txt"
Subjects=$(cat ${maindir}/jloureiro/logstxt/paper2/PPIAnalysis/HC4PPIAnalysis_paper2.txt)

DirectionList=""
DirectionList="${DirectionList} AP"
DirectionList="${DirectionList} PA"
roisdir="${maindir}/jloureiro/Masks/paper2/PPIMasks"
RoiList="rostralanteriorcingulate+medialorbitofrontal R_isthmuscingulate R_caudalanteriorcingulate"

module load workbench/1.3.2

#for sub in $Subjects
#do
	#for dir in ${DirectionList}
	#do
	#evsdir="${maindir}/HCP_OUTPUT/${sub}/MNINonLinear/Results/task-facematching_acq-${dir}_run-01/EVs"
	#cat ${evsdir}/${objects} | sed 's/1.0/-1.0 /g' > ${evsdir}/objectsneg_PPI.txt
	#cat ${evsdir}/${fearful} ${evsdir}/objectsneg_PPI.txt > ${evsdir}/fearful-objects_PPI.txt
	#cat ${evsdir}/${happy} ${evsdir}/objectsneg_PPI.txt > ${evsdir}/happy-objects_PPI.txt

#	rm ${evsdir}/objectsneg_PPI.txt
#	done
#done

#3- Extract time series of chosen ROI######################################################################
for roi in ${RoiList}
do

	for sub in ${Subjects}
	do
		for dir in ${DirectionList}
		do
			datadir="${maindir}/HCP_OUTPUT/${sub}/MNINonLinear/Results/task-facematching_acq-${dir}_run-01"
			evsdir="${maindir}/HCP_OUTPUT/${sub}/MNINonLinear/Results/task-facematching_acq-${dir}_run-01/EVs"
	
			wb_command -cifti-create-dense-from-template ${datadir}/task-facematching_acq-${dir}_run-01_Atlas_clean.dtseries.nii ${roisdir}/${roi}.dscalar.nii -cifti ${roisdir}/${roi}_SUM_thr78.dscalar.nii

			wb_command -cifti-roi-average ${datadir}/task-facematching_acq-${dir}_run-01_Atlas_clean.dtseries.nii ${evsdir}/${roi}_paper2_ts.txt -cifti-roi ${roisdir}/${roi}_SUM_thr78.dscalar.nii

		done
	done
done
echo "finished"
