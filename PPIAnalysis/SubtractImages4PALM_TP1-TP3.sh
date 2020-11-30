#!/bin/bash 
	

ROIList="AvNoGoGo_CON_VIR AvNoGoGo_DAN_VIIbL AvNoGoGo_FPN_VIIbL AvNoGoGo_SMN_VIIIA_BR AvNoGoGo_SMN_V_VIR"
hcpdir="/nafs/narr/HCP_OUTPUT"

maindir="/nafs/narr/jloureiro"
mainoutputdir="${maindir}/PALM3rdLevel/CARIT/PPIAnalysis"
Subjlist=$(<${mainoutputdir}/TP1-TP3_Imgs/SubsnoTP.txt)

for PPIroi in ${ROIList}
do
	for sub in ${Subjlist}
	do
		mkdir ${mainoutputdir}/TP1-TP3_Imgs/${sub}
		mkdir ${mainoutputdir}/TP1-TP3_Imgs/${sub}/${PPIroi}

		wb_command -cifti-math 'x - y' ${mainoutputdir}/TP1-TP3_Imgs/${sub}/${PPIroi}/cope3_TP1-TP3.dtseries.nii -var x ${hcpdir}/${sub}01/MNINonLinear/Results/task-carit_acq-PA_run-01/task-carit_acq-PA_run-01_JL_clean_PPIAnalysis_${PPIroi}_hp200_s5_level1.feat/GrayordinatesStats/cope3.dtseries.nii -var y ${hcpdir}/${sub}03/MNINonLinear/Results/task-carit_acq-PA_run-01/task-carit_acq-PA_run-01_JL_clean_PPIAnalysis_${PPIroi}_hp200_s5_level1.feat/GrayordinatesStats/cope3.dtseries.nii
	done
done

