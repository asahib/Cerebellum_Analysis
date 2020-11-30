#!/bin/bash
#set -x
maindir="/nafs/narr"
masksdir="${maindir}/jloureiro/Masks/PPI"
#PPI Analysis
#1- Chose contrast of interest and create PSY EV
neutral="cond002.txt"
fearful="cond003.txt"
happy="cond001.txt"
objects="cond004.txt"
Subjects=$(cat ${maindir}/jloureiro/logstxt/PPI_ALLSubs.txt)
DirectionList=""
DirectionList="${DirectionList} AP"
DirectionList="${DirectionList} PA"
roisdir="${maindir}/jloureiro/Masks/PPI"
roi="Funcmask_RAmygdala_cope13"
module load workbench

for sub in $Subjects
do
for dir in ${DirectionList}
do
evsdir="${maindir}/HCP_OUTPUT/${sub}/MNINonLinear/Results/task-facematching_acq-${dir}_run-01/EVs"
cat ${evsdir}/${objects} | sed 's/1.0/-1.0 /g' > ${evsdir}/objectsneg_PPI.txt
cat ${evsdir}/${fearful} ${evsdir}/objectsneg_PPI.txt > ${evsdir}/fearful-objects_PPI.txt
cat ${evsdir}/${happy} ${evsdir}/objectsneg_PPI.txt > ${evsdir}/happy-objects_PPI.txt

rm ${evsdir}/objectsneg_PPI.txt
done
done

#3- Extract time series of chosen ROI######################################################################
for sub in $Subjects
do
for dir in ${DirectionList}
do
datadir="${maindir}/HCP_OUTPUT/${sub}/MNINonLinear/Results/task-facematching_acq-${dir}_run-01"
evsdir="${maindir}/HCP_OUTPUT/${sub}/MNINonLinear/Results/task-facematching_acq-${dir}_run-01/EVs"

wb_command -cifti-create-dense-from-template ${datadir}/task-facematching_acq-${dir}_run-01_Atlas_clean.dtseries.nii ${roisdir}/${roi}.dscalar.nii -cifti ${roisdir}/${roi}.dscalar.nii

wb_command -cifti-roi-average ${datadir}/task-facematching_acq-${dir}_run-01_Atlas_clean.dtseries.nii ${evsdir}/${roi}_ts.txt -cifti-roi ${roisdir}/${roi}.dscalar.nii

done
done

echo "finished"
