#!/bin/sh

hcpdir="/nafs/narr/HCP_OUTPUT"
maindir="/nafs/narr/jloureiro"
HCPPIPEDIR="${maindir}/scripts/Pipelines-3.22.0"
Masksdir="${maindir}/Masks/freesurferSeg/template"
ROIlist="R_rostralmiddlefrontal L_rostralmiddlefrontal R_precentral L_precentral R_medialorbitofrontal L_medialorbitofrontal R_rostralanteriorcingulate L_rostralanteriorcingulate R_precuneus L_precuneus R_insula L_insula CAUDATE_RIGHT CAUDATE_LEFT PALLIDUM_RIGHT PALLIDUM_LEFT PUTAMEN_RIGHT PUTAMEN_LEFT HIPPOCAMPUS_RIGHT HIPPOCAMPUS_LEFT AMYGDALA_RIGHT AMYGDALA_LEFT "

# Merge ROIs for final Analysis

args=""
for mask in ${ROIlist}
do
	args="${args} -cifti ${Masksdir}/cifti_${mask}_aparcaseg.dscalar.nii "
done
	
wb_command -cifti-merge ${Masksdir}/MERGEDROIs.dscalar.nii ${args} 


