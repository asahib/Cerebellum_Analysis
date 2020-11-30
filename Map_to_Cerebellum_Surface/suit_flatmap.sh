#!/bin/bash 

#Compute Seed based connectivity#####################################
#Subjlist=$(</nafs/narr/jloureiro/CEREBELLUM/ALLSUBS.txt)
Subjlist="k000802"
cerebellumdir="/nafs/narr/jloureiro/CEREBELLUM"
mainconndir="${cerebellumdir}/RSConnectivity"
#ROIlist="faces-objects_fwep13bin_x162_y128_z110 faces-objects_fwep13bin_x245_y226_z224 faces-objects_fwep13bin_x346_y336_z318 faces-objects_fwep13bin_x458_y432_z421 fearful-neutral_23zstatbin_x134_y122_z121 fearful-neutral_23zstatbin_x228_y223_z217 GONOGO_fwep13bin_x135_y139_z126 GONOGO_fwep13bin_x237_y230_z210  happy-neutral_23zstatbin_x154_y126_z117"

ROIlist="faces-objects_fwep13bin_x162_y128_z110"

PEdirs="AP PA"
for roi in ${ROIlist}
do
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
			wb_command -cifti-correlation ${datacleandir}/Atlas_clean.dtseries.nii ${conndir}/zfisher_${sub}_${dir}_${roi}.dconn.nii -roi-override -vol-roi ${cerebellumdir}/FunctionalMaps/NARSAD_FINAL/SpheresROIs/Mask_${roi}_4mm.nii -fisher-z
		
			wb_command -cifti-average-roi-correlation ${conndir}/zfisher_${sub}_${dir}_${roi}AVERAGE.dscalar.nii -vol-roi ${cerebellumdir}/FunctionalMaps/NARSAD_FINAL/SpheresROIs/Mask_${roi}_4mm.nii -cifti ${datacleandir}/Atlas_clean.dtseries.nii

		done
	done
done




