#!/bin/bash 

module load fsl
module load workbench
module load freesurfer
module load MATLAB


grouplist="ECTTP2"
cerebellumdir="/nafs/narr/jloureiro/CEREBELLUM"
mainconndir="${cerebellumdir}/RSConnectivity"

ROIlist="faces-objects_fwep13bin_x162_y128_z110 faces-objects_fwep13bin_x245_y226_z224 faces-objects_fwep13bin_x346_y336_z318 faces-objects_fwep13bin_x458_y432_z421 fearful-neutral_23zstatbin_x134_y122_z121 fearful-neutral_23zstatbin_x228_y223_z217 GONOGO_fwep13bin_x135_y139_z126 GONOGO_fwep13bin_x237_y230_z210  happy-neutral_23zstatbin_x154_y126_z117"


for group in ${grouplist}
do
Subjlist=$(</nafs/narr/jloureiro/CEREBELLUM/txtfiles/${group}.txt)
	for roi in ${ROIlist}
	do
		args=""
		for sub in ${Subjlist}
		do
			conndir="${mainconndir}/SubjectsDATA/${sub}"
			#args="${args} -cifti ${conndir}/MEANdenseConnectome_${sub}.dconn.nii "
			args="${args} -cifti ${conndir}/MEANdenseConnectome_${roi}_${sub}.dscalar.nii "
		done

		wb_command -cifti-average ${mainconndir}/GroupAnalysis/${group}_MEAN/MEANdenseConnectome_${roi}_${group}.dscalar.nii ${args} 

	done
	echo "finished for ${group}"
done
