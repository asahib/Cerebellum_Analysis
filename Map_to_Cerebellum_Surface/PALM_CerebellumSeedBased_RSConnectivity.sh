#!/bin/bash 



hcpdir="/nafs/narr/HCP_OUTPUT"

maindir="/nafs/narr/jloureiro"

#group="HC_MDDTP1"

mainoutputdir="${maindir}/CEREBELLUM/RSConnectivity/GroupAnalysis"

EnvironmentScript="${maindir}/scripts/Pipelines-3.22.0/Examples/Scripts/SetUpHCPPipeline_JL_4slurm.sh"
mainfreesurferMasksdir="${maindir}/Masks/freesurferSeg/cifti"

cluster_thr="2.3"
#regtype="age_sex_reg2_v2"


module unload workbench
module load workbench
module unload MATLAB
module load MATLAB/R2017a
module load PALM
module unload freesurfer
module load freesurfer/6.0.1


extension="dtseries.nii"
Fextension="dscalar"
niter="500"

source ${EnvironmentScript}



workdir="${mainoutputdir}/${group}/${roi}"

if [ ! -d ${workdir} ]
then
mkdir ${workdir}
fi

cd ${workdir}
subjlist=$(<../${group}.txt)
#echo "$subjlist" 	
		
args=""
#Merge all subjects data#####################################################################################################################
for subj in ${subjlist}
do
			
	args="${args} -cifti 
	${maindir}/CEREBELLUM/RSConnectivity/SubjectsDATA/${subj}/MEANdenseConnectome_${roi}_${subj}.dscalar.nii -column 1"
			
done


#/usr/local/workbench-1.2.3/bin_rh_linux64/


#Run the Permutation test##################################################################################################

echo "$args"
wb_command -cifti-merge Y.dscalar.nii ${args}

palm -i Y.dscalar.nii -transposedata -d ../design.mat -t ../design.con -o results_cifti -n 500 -corrcon -logp -accel tail -zstat
		
#results_cifti_dat_tstat_d?_c?.dscalar.nii: Contains the Student’s t-statistic for each design (‘d?’) and contrast (‘c?’), computed grayordinate-wise.
#results_cifti_dat_tstat_fwep_d?_c?.dscalar.nii: Contains the p-values Family-Wise Error Rate (FWER)-corrected across the 91282 grayordinates.
#results_cifti_dat_tstat_cfwep_d?_c?.dscalar.nii: Contains the p-values FWER-corrected across the 91282 grayordinates and all contrasts from all designs.

#Run Permutation test also with TFCE#################################################################################################
#1-Separate surface and volume of the cifti file######
	
		
wb_command -cifti-separate Y.dscalar.nii COLUMN -volume-all Y_subcortical.nii -label Y_subcortical_label.nii -roi Y_subcortical_roi.nii -metric CORTEX_LEFT Y_left.func.gii -roi left.shape.gii -metric CORTEX_RIGHT Y_right.func.gii -roi right.shape.gii
wb_command -gifti-convert BASE64_BINARY Y_left.func.gii Y_left.func.gii			
wb_command -gifti-convert BASE64_BINARY Y_right.func.gii Y_right.func.gii
wb_command -gifti-convert BASE64_BINARY ${maindir}/AverageData/HC_n34/MNINonLinear/fsaverage_LR32k/HC_n34.L.midthickness.32k_fs_LR.surf.gii L_midthickness.surf.gii			
wb_command -gifti-convert BASE64_BINARY ${maindir}/AverageData/HC_n34/MNINonLinear/fsaverage_LR32k/HC_n34.R.midthickness.32k_fs_LR.surf.gii R_midthickness.surf.gii


#2- Run PALM with TFCE For subcortical regions:#################
			
palm -i Y_subcortical.nii -d ../design.mat -t ../design.con -o results_dense_subcortical -n 500 -corrcon -C 2.3 -Cstat "extent" -logp -accel tail -T -zstat -ise

#2- Run PALM with TFCE For cortical regions:#################

palm  -i Y_left.func.gii -i Y_right.func.gii -d ../design.mat -t ../design.con -o results_dense_cortical -n 500 -corrcon -corrmod -C 2.3 -Cstat "extent" -logp -accel tail -T -tfce2D -s L_midthickness.surf.gii -s R_midthickness.surf.gii -zstat

				

#View the results of the permutation test with TFCE.##############################################################
methodtype="tfce clustere"
corrtype="fwep uncp"
#Get nr of contrasts#####
numCons="`cat ${workdir}/../design.con | sed -n 's/.*NumContrasts//p'`"

for (( c=1; c <= ${numCons}; c++ )) 
do

	wb_command -cifti-create-dense-scalar results_cifti_dat_ztstat_c${c}.dscalar.nii -volume results_dense_subcortical_vox_ztstat_c${c}.nii /nafs/narr/jloureiro/scripts/Pipelines-3.22.0/global/templates/91282_Greyordinates/Atlas_ROIs.2.nii -left-metric results_dense_cortical_dpv_ztstat_m1_c${c}.gii -right-metric results_dense_cortical_dpv_ztstat_m2_c${c}.gii

	for method in ${methodtype}
	do
		wb_command -cifti-create-dense-scalar results_dense_${method}_ztstat_c${c}.dscalar.nii -volume results_dense_subcortical_${method}_ztstat_c${c}.nii /nafs/narr/jloureiro/scripts/Pipelines-3.22.0/global/templates/91282_Greyordinates/Atlas_ROIs.2.nii -left-metric results_dense_cortical_${method}_ztstat_m1_c${c}.gii -right-metric results_dense_cortical_${method}_ztstat_m2_c${c}.gii

		for corr in ${corrtype}
		do
			if [ ${corr} = "uncp" ]
			then
				wb_command -cifti-create-dense-scalar results_dense_${method}_ztstat_${corr}_c${c}.dscalar.nii -volume results_dense_subcortical_${method}_ztstat_${corr}_c${c}.nii /nafs/narr/jloureiro/scripts/Pipelines-3.22.0/global/templates/91282_Greyordinates/Atlas_ROIs.2.nii -left-metric results_dense_cortical_${method}_ztstat_${corr}_m1_c${c}.gii -right-metric results_dense_cortical_${method}_ztstat_${corr}_m2_c${c}.gii
			else
			wb_command -cifti-create-dense-scalar results_dense_${method}_ztstat_c${corr}_c${c}.dscalar.nii -volume results_dense_subcortical_${method}_ztstat_c${corr}_c${c}.nii /nafs/narr/jloureiro/scripts/Pipelines-3.22.0/global/templates/91282_Greyordinates/Atlas_ROIs.2.nii -left-metric results_dense_cortical_${method}_ztstat_mc${corr}_m1_c${c}.gii -right-metric results_dense_cortical_${method}_ztstat_mc${corr}_m2_c${c}.gii
			wb_command -cifti-create-dense-scalar results_dense_${method}_ztstat_${corr}_c${c}.dscalar.nii -volume results_dense_subcortical_${method}_ztstat_${corr}_c${c}.nii /nafs/narr/jloureiro/scripts/Pipelines-3.22.0/global/templates/91282_Greyordinates/Atlas_ROIs.2.nii -left-metric results_dense_cortical_${method}_ztstat_m${corr}_m1_c${c}.gii -right-metric results_dense_cortical_${method}_ztstat_m${corr}_m2_c${c}.gii
			fi

		done
	done

done
		

#Convert dscalar map in nifti 

#wb_command -cifti-separate cope5_zstat_HC_MDDTP1mean.dscalar.nii COLUMN -volume-all cope5_zstat_HC_MDDTP1mean.nii

cd ${maindir}
