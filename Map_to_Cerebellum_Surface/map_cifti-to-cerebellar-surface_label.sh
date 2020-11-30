#!/bin/bash
# script to map cifti volume to colin cerebellar surface.
# DVE 19sep2017 in preparation for possible BALSA release

#Replace with your input dscalar or dtseries data file
#INPUT_CIFTI_FILE=results_dense_tfce_ztstat_uncp_c2.dscalar.nii
#INPUT_CIFTI_FILE=CortexSubcortex_ColeAnticevic_NetPartition_wSubcorGSR_netassignments_LR.dlabel.nii
INPUT_CIFTI_FILE=melodic_IC200d.dscalar.nii
#Add steps to strip file type from end (".dscalar.nii" or ".dtseries.nii"

#Replace with your file prefix
#INPUT_PREFIX=results_dense_tfce_ztstat_uncp_c2
#INPUT_PREFIX=CortexSubcortex_ColeAnticevic_NetPartition_wSubcorGSR_netassignments_LR
INPUT_PREFIX=melodic_IC200d

#Replace with your input directory 
#CIFTI_FILE_DIR=/nafs/narr/jloureiro/PALM3rdLevel/PPIAnalysis/paper2/CerebellumROIs/KTP1_KTP2/Right_V_KTP1_KTP3_cope2c1maskfwep005_paper2/cope7
#CIFTI_FILE_DIR=/nafs/narr/jloureiro/scripts/ParcellationTemplates/ColeAnticevicNetPartition-master
CIFTI_FILE_DIR=/nafs/narr/asahib/MR_fix_MSMALL_GICA/rs_fmri200d
#CIFTI_FILE_DIR=/nafs/narr/jloureiro
CEREBELLAR_SURFACE=colin.cerebellum.anatomical_MNI.surf.gii

#Replace with your cerebellar surface directory
CEREBELLAR_SURFACE_DIR=/nafs/narr/jloureiro/CEREBELLUM/cerebellum_colin

#generate left and right nifti volumes

wb_command -cifti-separate $CIFTI_FILE_DIR/$INPUT_CIFTI_FILE COLUMN -volume CEREBELLUM_LEFT $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum_left.nii -roi $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum_left_roi.nii

wb_command -cifti-separate $CIFTI_FILE_DIR/$INPUT_CIFTI_FILE COLUMN -volume CEREBELLUM_RIGHT $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum_right.nii -roi $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum_right_roi.nii

#combine into single nifti volume and dilate one step:

wb_command -volume-math 'x+y' $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum.nii -var x $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum_left.nii  -var y $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum_right.nii

wb_command -volume-dilate $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum.nii 1 NEAREST $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum_dilate1.nii

#Map to cerebellar surface, generating a dtseries file

wb_command -volume-to-surface-mapping $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum_dilate1.nii $CEREBELLAR_SURFACE_DIR/$CEREBELLAR_SURFACE $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum.func.gii -enclosing
wb_command -metric-label-import $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum.func.gii  ${NET_LABEL_TXT_FILE} $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum.label.gii


#copy this cifti file to a gifti file 
#cp $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum.dtseries.nii $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum.func.gii

#wb_command -cifti-create-dense-timeseries $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum.dtseries.nii -cerebellum-metric $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum.func.gii -timestep 1.0 -timestart 1

#wb_command -nifti-information $CIFTI_FILE_DIR/$INPUT_PREFIX.dscalar.nii -print-xml | grep MapName | cut -d ">" -f 2 | cut -d "<" -f 1 > tmp.txt
#wb_command -cifti-convert-to-scalar $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum.dtseries.nii ROW $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum.dscalar.nii -name-file tmp.txt

#clean up (but preserve metric file(s) *.func.gii)
rm $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum_left.nii $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum_left_roi.nii $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum_right.nii $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum_right_roi.nii $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum.nii $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum_dilate1.nii $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum.dtseries.nii tmp.txt

