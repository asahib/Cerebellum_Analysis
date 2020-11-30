#!/bin/bash 

module unload fsl
module load fsl/6.0.1
module unload workbench
module load workbench
module unload MATLAB
module load MATLAB/R2017a
module load PALM


hcpdir="/nafs/narr/HCP_OUTPUT"
ASLdir="/nafs/narr/asahib/ASL/ASL_nifti"

maindir="/nafs/narr/jloureiro"
txtfile4analysis="${maindir}/logstxt/tmpsubs4analysis.txt"

mainoutputdir="${maindir}/PALM3rdLevel/ASL/CEREBELLUM_MASK"

EnvironmentScript="${maindir}/scripts/Pipelines-3.22.0/Examples/Scripts/SetUpHCPPipeline_JL_4slurm.sh"
cluster_thr="2.3"

niter="5000"

CEREBELLUM_MASK_DIR="/nafs/narr/jloureiro/Masks/CEREBELLUM_masks"
CEREBELLUM_MASK=$CEREBELLUM_MASK_DIR/CEREBELLUM_ALLSUBS_SUM_bin.dscalar.nii

source ${EnvironmentScript}

workdir="${mainoutputdir}/${GROUP}"
	
cd ${workdir}
subjlist=$(<${GROUP}IDs.txt)
echo "$subjlist" 	
echo $CON
		
args=""
#Merge all subjects data#####################################################################################################################
for subj in ${subjlist}
do	
	args="${args} -cifti 
	${ASLdir}/${subj}/oxasl_MD_F/std_space/pvcorr/${subj}_AtlasFS_fwhm5_perfusion_calib.dscalar.nii -column 1"
	
done


#/usr/local/workbench-1.2.3/bin_rh_linux64/


#Run the Permutation test##################################################################################################
		
outputdir="${workdir}"
mkdir ${outputdir}
cd ${outputdir}
echo "$args"
wb_command -cifti-merge Y.dscalar.nii ${args}
palm -i Y.dscalar.nii -m $CEREBELLUM_MASK -transposedata -d design.mat -t design.con -o results_cifti -n ${niter} -corrcon -logp -accel tail -zstat -fdr 
		
#Run Permutation test also with TFCE#################################################################################################
#1-Separate surface and volume of the cifti file######
	
wb_command -cifti-separate Y.dscalar.nii COLUMN -volume-all Y_subcortical.nii -label Y_subcortical_label.nii -roi Y_subcortical_roi.nii -metric CORTEX_LEFT Y_left.func.gii -roi left.shape.gii -metric CORTEX_RIGHT Y_right.func.gii -roi right.shape.gii

wb_command -cifti-separate $CEREBELLUM_MASK COLUMN -volume-all $CEREBELLUM_MASK_DIR/CEREBELLUM_ALLSUBS_SUM_bin_subcortical.nii -label Y_subcortical_label.nii -roi Y_subcortical_roi.nii -metric CORTEX_LEFT Y_left.func.gii -roi left.shape.gii -metric CORTEX_RIGHT Y_right.func.gii -roi right.shape.gii

wb_command -gifti-convert BASE64_BINARY Y_left.func.gii Y_left.func.gii			
wb_command -gifti-convert BASE64_BINARY Y_right.func.gii Y_right.func.gii
wb_command -gifti-convert BASE64_BINARY ${maindir}/AverageData/HC_n34/MNINonLinear/fsaverage_LR32k/HC_n34.L.midthickness.32k_fs_LR.surf.gii L_midthickness.surf.gii			
wb_command -gifti-convert BASE64_BINARY ${maindir}/AverageData/HC_n34/MNINonLinear/fsaverage_LR32k/HC_n34.R.midthickness.32k_fs_LR.surf.gii R_midthickness.surf.gii

#2- Run PALM with TFCE For subcortical regions:#################
palm -i Y_subcortical.nii -m $CEREBELLUM_MASK_DIR/CEREBELLUM_ALLSUBS_SUM_bin_subcortical.nii -d design.mat -t design.con -o results_dense_subcortical -n ${niter} -corrcon -C ${cluster_thr} -Cstat "extent" -logp -accel tail  -T -zstat -fdr 	

			

cd ${maindir}
