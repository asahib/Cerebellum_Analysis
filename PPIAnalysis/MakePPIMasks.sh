#!/bin/bash

maindir="/nafs/narr"
masksdir="${maindir}/jloureiro/Masks/PPI"
Subjects=$(cat ${maindir}/jloureiro/logstxt/paper2/PPIAnalysis/Subs4PPIAnalysis_paper2.txt)
roisdir="${maindir}/jloureiro/Masks/paper2/PPIMasks"
group="KTP1_KTP2 KTP2_KTP3"
N="26"

module load workbench/1.3.2


for g in ${group}
do
	CombinedMasksdir="${maindir}/jloureiro/Masks/paper2/CombinedMasks/${g}_cifti"
	if [ ${g} = "KTP1_KTP2" ]
	then
		funcmask="cope2c2maskuncp0001"
		ROIList="R_rostralanteriorcingulate R_medialorbitofrontal R_isthmuscingulate"
	else
		funcmask="cope2c1maskfwep005"
		ROIList="R_caudalanteriorcingulate"
	fi

	for roi in ${ROIList}
	do
		if [ ${roi} = "R_isthmuscingulate" ]
		then
			funcmask="cope3c2maskuncp0001"
		fi
		args=""
		for sub in ${Subjects}
		do
			subMasksdir="${CombinedMasksdir}/${sub}"
			args="${args} -cifti ${subMasksdir}/combined_${roi}_${g}_${funcmask}.dscalar.nii "
		done
	
		wb_command -cifti-merge ${roisdir}/${roi}_allsubs.dscalar.nii ${args} 
		wb_command -cifti-reduce ${roisdir}/${roi}_allsubs.dscalar.nii SUM ${roisdir}/${roi}_SUM.dscalar.nii
		wb_command -cifti-math 'x == 78' ${roisdir}/${roi}_SUM_thr78.dscalar.nii -var x ${roisdir}/${roi}_SUM.dscalar.nii #78=26*3, N=26
	done	
done

wb_command -cifti-math 'x+y' ${roisdir}/rostralanteriorcingulate+medialorbitofrontal_SUM_thr78.dscalar.nii -var x ${roisdir}/R_rostralanteriorcingulate_SUM_thr78.dscalar.nii -var y ${roisdir}/R_medialorbitofrontal_SUM_thr78.dscalar.nii

echo "finished"

