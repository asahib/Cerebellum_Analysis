#!/bin/sh

hcpdir="/nafs/narr/HCP_OUTPUT"
maindir="/nafs/narr/jloureiro"
HCPPIPEDIR="${maindir}/scripts/Pipelines-3.22.0"
Masksdir="${maindir}/Masks/paper2/PPIMasks/ROIs4PolarPlots/Final"
ROIlist="AmygdalaRight HippocampusRight PallidumRight InferiorParietalRight IsthmusCingulateRight LateralOccipitalRight MedialOrbitoFrontalRight PrecentralRight PrecuneusRight RostralmiddlefrontalRight SuperiorTemporalRight"

# Merge ROIs for final Analysis

args=""
for mask in ${ROIlist}
do
	args="${args} -cifti ${Masksdir}/${mask}.dscalar.nii "
done
	
wb_command -cifti-merge ${Masksdir}/MERGEDROIs.dscalar.nii ${args} 


