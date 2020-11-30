#!/bin/bash 

module load fsl
module load workbench

#Compute Seed based connectivity#####################################
#Subjlist=$(</nafs/narr/jloureiro/CEREBELLUM/ALLSUBS.txt)
Subjlist="k000801"
cerebellumdir="/nafs/narr/jloureiro/CEREBELLUM"
mainconndir="${cerebellumdir}/RSConnectivity"

suitmasksgonogo="Right_V Right_VI Right_VIIIa"

suitmasksfacesobjects="Vermis_VI Vermis_CrusI Left_CrusI Vermis_CrusII Left_CrusII Vermis_VIIb Left_VIIb Vermis_VIIIa Vermis_VIIIb Vermis_IX Left_X Vermis_X Right_X"

suitmasksfearfulneutral="Right_CrusI Right_CrusII Right_IX"

suitmaskshappyneutral="Left_CrusII"

suitmasks="Right_V Right_VI Right_VIIIa Vermis_VI Vermis_CrusI Left_CrusI Vermis_CrusII Left_CrusII Vermis_VIIb Left_VIIb Vermis_VIIIa Vermis_VIIIb Vermis_IX Left_X Vermis_X Right_X Right_CrusI Right_CrusII Right_IX"

sphereROIs="Mask_faces-objects_fwep13bin_x162_y128_z110_4mm Mask_faces-objects_fwep13bin_x245_y226_z224_4mm Mask_faces-objects_fwep13bin_x346_y336_z318_4mm Mask_faces-objects_fwep13bin_x458_y432_z421_4mm Mask_fearful-neutral_23zstatbin_x134_y122_z121_4mm Mask_fearful-neutral_23zstatbin_x228_y223_z217_4mm Mask_GONOGO_fwep13bin_x135_y139_z126_4mm Mask_GONOGO_fwep13bin_x237_y230_z210_4mm Mask_happy-neutral_23zstatbin_x154_y126_z117_4mm"

sphereROIs="Mask_faces-objects_fwep13bin_x162_y128_z110_4mm"


#ROIcombinedlistALL="Right_V_gonogo Right_VI_gonogo Right_VIIIa_gonogo Vermis_VI_faces-objects Vermis_CrusI_faces-objects Left_CrusI_faces-objects Vermis_CrusII_faces-objects Left_CrusII_faces-objects Vermis_VIIb_faces-objects Left_VIIb_faces-objects Vermis_VIIIa_faces-objects Vermis_VIIIb_faces-objects Vermis_IX_faces-objects Left_X_faces-objects Vermis_X_faces-objects Right_X_faces-objects Right_CrusI_fearful-neutral Right_CrusII_fearful-neutral Right_IX_fearful-neutral Left_CrusII_happy-neutral"
ROIcombinedlistALL=""
PEdirs="AP PA"

for mask in ${sphereROIs}
do
roi="${cerebellumdir}/FunctionalMaps/NARSAD_FINAL/SpheresROIs/${mask}.nii"
wb_command -volume-math 'x > 0' ${roi} -var 'x' ${roi}

	for sub in ${Subjlist}
	do
		conndir="${mainconndir}/${sub}"
		if [ ! -d ${conndir} ]
		then
			mkdir ${conndir}
		fi

		for dir in ${PEdirs}
		do

			datacleandir="/nafs/narr/HCP_OUTPUT/${sub}/MNINonLinear/Results/task-rest_acq-${dir}_run-01/task-rest_acq-${dir}_run-01_hp2000.ica"
			wb_command -cifti-correlation ${datacleandir}/Atlas_clean.dtseries.nii ${conndir}/zstat_rsconn_${sub}_${dir}_${mask}.dconn.nii -roi-override -vol-roi ${roi} -fisher-z
			wb_command -cifti-correlation ${datacleandir}/Atlas_clean.dtseries.nii ${conndir}/denseConnectome_${sub}_${dir}.dconn.nii -fisher-z
		done
		 
		wb_command -cifti-average ${conndir}/MEANzstat_rsconn_${sub}_${mask}.dconn.nii -cifti ${conndir}/zstat_rsconn_${sub}_AP_${mask}.dconn.nii -cifti ${conndir}/zstat_rsconn_${sub}_PA_${mask}.dconn.nii 
		wb_command -cifti-average ${conndir}/MEANdenseConnectome_${sub}.dconn.nii -cifti ${conndir}/denseConnectome_${sub}_PA.dconn.nii -cifti ${conndir}/denseConnectome_${sub}_AP.dconn.nii 	

	done
done


for mask in ${ROIcombinedlistALL}
do
roi="${cerebellumdir}/CombinedMasks/${mask}.nii"
wb_command -volume-math 'x > 0' ${roi} -var 'x' ${roi}

	for sub in ${Subjlist}
	do
		conndir="${mainconndir}/${sub}"
		if [ ! -d ${conndir} ]
		then
			mkdir ${conndir}
		fi

		for dir in ${PEdirs}
		do

			datacleandir="/nafs/narr/HCP_OUTPUT/${sub}/MNINonLinear/Results/task-rest_acq-${dir}_run-01/task-rest_acq-${dir}_run-01_hp2000.ica"
			wb_command -cifti-correlation ${datacleandir}/Atlas_clean.dtseries.nii ${conndir}/zstat_rsconn_${sub}_${dir}_${mask}.dconn.nii -roi-override -vol-roi ${roi} -fisher-z
		done
		 
		wb_command -cifti-average ${conndir}/MEANzstat_rsconn_${sub}_${mask}.dconn.nii -cifti ${conndir}/zstat_rsconn_${sub}_AP_${mask}.dconn.nii -cifti ${conndir}/zstat_rsconn_${sub}_PA_${mask}.dconn.nii 
	done
done

echo "finished"

