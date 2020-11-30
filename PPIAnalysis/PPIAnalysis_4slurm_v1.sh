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
Subjects=$(cat ${maindir}/jloureiro/logstxt/PPIlist.txt)
DirectionList=""
DirectionList="${DirectionList} AP"
DirectionList="${DirectionList} PA"
for sub in $Subjects
do
for dir in ${DirectionList}
do
evsdir="${maindir}/HCP_OUTPUT/${sub}/MNINonLinear/Results/task-facematching_acq-${dir}_run-01/EVs"
cat ${evsdir}/${neutral} | sed 's/1.0/-1.0 /g' > ${evsdir}/neutralneg_PPI.txt
 cat ${evsdir}/${fearful} ${evsdir}/neutralneg_PPI.txt > ${evsdir}/fearful-neutral_PPI.txt
rm ${evsdir}/neutralneg_PPI.txt
done
done


#2- make mask from functional activation of ROI of interest (circle around activation peak)#################
x="35"
y="57"
z="24"
#create,a,mask,file,that,covers,a,single,voxel:
fslmaths ${datadir}/task-facematching_acq-${dir}_run-01_s5.nii.gz -mul 0 -add 1 -roi $x 1 $y 1 $z 1 0 1 ${masksdir}/PPImask_${x}_${y}_${z}
#create,a,sphere,mask,around,the,voxel,mask:
fslmaths ${masksdir}/PPImask_${x}_${y}_${z} -kernel sphere 3 -fmean ${masksdir}/PPIspheremask3mm_${x}_${y}_${z}


#3- Extract time series of chosen ROI######################################################################
for sub in $Subjects
do
for dir in ${DirectionList}
do
datadir="${maindir}/HCP_OUTPUT/${sub}/MNINonLinear/Results/task-facematching_acq-${dir}_run-01/task-facematching_acq-${dir}_run-01_JL_hp200_s5_level1.feat"
ppidir="${maindir}/jloureiro/${sub}
/MNINonLinear/Results/task-facematching_acq-${dir}_run-01/PPItest"
mkdir ${ppidir}
fslmeants -i ${datadir}/task-facematching_acq-${dir}_run-01_s5.nii.gz -o ${ppidir}/${x}_${y}_${z}_3mmseed_ts.txt -m ${masksdir}/PPIspheremask3mm_${x}_${y}_${z}

done
done

