#!/bin/bash 



hcpdir="/nafs/narr/HCP_OUTPUT"

maindir="/nafs/narr/jloureiro"
txtfile4analysis="${maindir}/logstxt/tmpsubs4analysis.txt"

GroupAnalysis=""
#GroupAnalysis="${GroupAnalysis} HC_KTP1 KTP1_KTP2 KTP1_KTP3 KTP2_KTP3"
GroupAnalysis="${GroupAnalysis} KTP1_KTP2_KTP3"
copeList=""
copeList="${copeList} cope11 cope13 cope5 cope10 cope1 cope3 cope2 cope4 cope15"
#copeList="${copeList} cope1 cope2 cope3 cope4 cope5 cope10 cope11 cope13 cope15 cope19"
mainoutputdir="${maindir}/PALM3rdLevel/FM"

EnvironmentScript="${maindir}/scripts/Pipelines-3.22.0/Examples/Scripts/SetUpHCPPipeline_JL_4slurm.sh"
funcmask="" 
funcmask="ciftimask_HC_KTP1mean_cope15_fwe005"
funcmaskdir="${maindir}/Masks/FuncMasks/HC_KTP1mean"
cluster_thr="2.3"
#regtype="NOReg age_sex_reg age_sex_taskrt_reg"
#regtype="age_sex_reg2_v2"
#Analysis="ParcellatedAnalysis" #ParcellatedAnalysis if parcellation was used VoxelAnalysis if voxel ise analysis was used
Analysis="VoxelAnalysis"
module unload fsl
module load fsl/6.0.0
module unload workbench
module load workbench
module unload MATLAB
module load MATLAB/R2017a
module load PALM

if [ ${Analysis} = "VoxelAnalysis" ]
then
	extension="dtseries.nii"
	Fextension="dscalar"
	niter="500"
else
	extension="ptseries.nii"
	Fextension="pscalar.nii"
	niter="5000"
fi

source ${EnvironmentScript}

for group in ${GroupAnalysis}
do
	if [ ! -z "${funcmask}" ]; then
		workdir="${mainoutputdir}/${group}/${funcmask}"
	else
		#workdir="${mainoutputdir}/${group}/ALLSubs/noFuncMask/${regtype}"
		#workdir="${mainoutputdir}/${group}/${regtype}"
		workdir="${mainoutputdir}/${group}/NOmask"
		mkdir ${workdir}
	fi

	cd ${workdir}
	subjlist=$(<${maindir}/logstxt/${group}IDs.txt)
	#echo "$subjlist" 	
	for cope in ${copeList}
	do
		echo $cope		
		args=""
#Merge all subjects data#####################################################################################################################
		for subj in ${subjlist}
		do
			if [ ${Analysis} = "VoxelAnalysis" ]
			then	
				args="${args} -cifti 
				${hcpdir}/${subj}/MNINonLinear/Results/task-facematching_JL_level2_20cons_clean/task-facematching_JL_20cons_clean_hp200_s5_level2.feat/GrayordinatesStats/${cope}.feat/cope1.${extension} -column 1"
			else
				args="${args} -cifti 
				${hcpdir}/${subj}/MNINonLinear/Results/task-facematching_JL_level2_20cons_clean/task-facematching_JL_20cons_clean_hp200_s5_level2_Glasser.feat/ParcellatedStats/${cope}.feat/cope1.${extension} -column 1"
			fi
		done


#/usr/local/workbench-1.2.3/bin_rh_linux64/


#Run the Permutation test##################################################################################################
		if [ ! -z "${funcmask}" ]; then
			outputdir="${workdir}/${cope}"
			mkdir ${outputdir}
			cd ${outputdir}
			echo "$args"
			wb_command -cifti-merge Y.dtseries.nii ${args}
			palm -i Y.${extension} -m ${funcmaskdir}/${funcmask}.dscalar.nii -transposedata -d ../design.mat -t ../design.con -o results_cifti -n 500 -corrcon -logp -accel tail -zstat -fdr
		else
			outputdir="${workdir}/${cope}"
			mkdir ${outputdir}
			cd ${outputdir}
			echo "$args"
			wb_command -cifti-merge Y.${extension} ${args}
			palm -i Y.${extension} -transposedata -d ../design.mat -t ../design.con -o results_cifti -n ${niter} -corrcon -logp -accel tail -zstat -fdr 
		fi
#results_cifti_dat_tstat_d?_c?.dscalar.nii: Contains the Student’s t-statistic for each design (‘d?’) and contrast (‘c?’), computed grayordinate-wise.
#results_cifti_dat_tstat_fwep_d?_c?.dscalar.nii: Contains the p-values Family-Wise Error Rate (FWER)-corrected across the 91282 grayordinates.
#results_cifti_dat_tstat_cfwep_d?_c?.dscalar.nii: Contains the p-values FWER-corrected across the 91282 grayordinates and all contrasts from all designs.

#Run Permutation test also with TFCE#################################################################################################
#1-Separate surface and volume of the cifti file######
	
		if [ ${Analysis} = "VoxelAnalysis" ]
		then 

			wb_command -cifti-separate Y.dtseries.nii COLUMN -volume-all Y_subcortical.nii -label Y_subcortical_label.nii -roi Y_subcortical_roi.nii -metric CORTEX_LEFT Y_left.func.gii -roi left.shape.gii -metric CORTEX_RIGHT Y_right.func.gii -roi right.shape.gii
			wb_command -gifti-convert BASE64_BINARY Y_left.func.gii Y_left.func.gii			
			wb_command -gifti-convert BASE64_BINARY Y_right.func.gii Y_right.func.gii
			wb_command -gifti-convert BASE64_BINARY ${maindir}/AverageData/HC_n34/MNINonLinear/fsaverage_LR32k/HC_n34.L.midthickness.32k_fs_LR.surf.gii L_midthickness.surf.gii			
			wb_command -gifti-convert BASE64_BINARY ${maindir}/AverageData/HC_n34/MNINonLinear/fsaverage_LR32k/HC_n34.R.midthickness.32k_fs_LR.surf.gii R_midthickness.surf.gii
#2- Run PALM with TFCE For subcortical regions:#################
			if [ ! -z "${funcmask}" ]; then
				wb_command -cifti-separate ${funcmaskdir}/${funcmask}.dscalar.nii COLUMN -volume-all ciftimask_subcortical.nii -label Y_subcortical_label.nii -roi Y_subcortical_roi.nii -metric CORTEX_LEFT ciftimask_cortexleft.func.gii -roi left.shape.gii -metric CORTEX_RIGHT ciftimask_cortexright.func.gii -roi right.shape.gii 
				palm -i Y_subcortical.nii -m ciftimask_subcortical.nii -d ../design.mat -t ../design.con -o results_dense_subcortical -n 500 -corrcon -C ${cluster_thr} -Cstat "extent" -logp -accel tail  -T -zstat -fdr
#3- Run PALM with TFCE for cortical surfaces:#################
				palm  -i Y_left.func.gii -i Y_right.func.gii -m ciftimask_cortexleft.func.gii -m ciftimask_cortexright.func.gii -d ../design.mat -t ../design.con -o results_dense_cortical -n 500 -corrcon -corrmod -C ${cluster_thr} -Cstat "extent" -logp -accel tail -T -tfce2D -s L_midthickness.surf.gii -s R_midthickness.surf.gii -zstat -fdr
			else
				palm -i Y_subcortical.nii -d ../design.mat -t ../design.con -o results_dense_subcortical -n ${niter} -corrcon -C ${cluster_thr} -Cstat "extent" -logp -accel tail  -T -zstat -fdr 	
#3- Run PALM with TFCE for cortical surfaces:#################
				palm  -i Y_left.func.gii -i Y_right.func.gii -d ../design.mat -t ../design.con -o results_dense_cortical -n ${niter} -corrcon -corrmod -C ${cluster_thr} -Cstat "extent" -logp -accel tail -T -tfce2D -s L_midthickness.surf.gii -s R_midthickness.surf.gii -zstat -fdr

			fi
		fi

#View the results of the permutation test with TFCE.##############################################################
		methodtype="tfce clustere"
		corrtype="fwep fdrp uncp"
		#Get nr of contrasts#####
		numCons="`cat ${workdir}/design.con | sed -n 's/.*NumContrasts//p'`"

		for (( c=1; c <= ${numCons}; c++ )) 
		do

			wb_command -cifti-create-dense-scalar results_cifti_dat_ztstat_c${c}.${Fextension}.nii -volume results_dense_subcortical_vox_ztstat_c${c}.nii Y_subcortical_label.nii -left-metric results_dense_cortical_dpv_ztstat_m1_c${c}.gii -right-metric results_dense_cortical_dpv_ztstat_m2_c${c}.gii

			for method in ${methodtype}
			do
				wb_command -cifti-create-dense-scalar results_dense_${method}_ztstat_c${c}.${Fextension}.nii -volume results_dense_subcortical_${method}_ztstat_c${c}.nii Y_subcortical_label.nii -left-metric results_dense_cortical_${method}_ztstat_m1_c${c}.gii -right-metric results_dense_cortical_${method}_ztstat_m2_c${c}.gii

				for corr in ${corrtype}
				do
					if [ ${corr} = "uncp" ]
					then
						wb_command -cifti-create-dense-scalar results_dense_${method}_ztstat_${corr}_c${c}.${Fextension}.nii -volume results_dense_subcortical_${method}_ztstat_${corr}_c${c}.nii Y_subcortical_label.nii -left-metric results_dense_cortical_${method}_ztstat_${corr}_m1_c${c}.gii -right-metric results_dense_cortical_${method}_ztstat_${corr}_m2_c${c}.gii
					else
						wb_command -cifti-create-dense-scalar results_dense_${method}_ztstat_c${corr}_c${c}.${Fextension}.nii -volume results_dense_subcortical_${method}_ztstat_c${corr}_c${c}.nii Y_subcortical_label.nii -left-metric results_dense_cortical_${method}_ztstat_mc${corr}_m1_c${c}.gii -right-metric results_dense_cortical_${method}_ztstat_mc${corr}_m2_c${c}.gii
						wb_command -cifti-create-dense-scalar results_dense_${method}_ztstat_${corr}_c${c}.${Fextension}.nii -volume results_dense_subcortical_${method}_ztstat_${corr}_c${c}.nii Y_subcortical_label.nii -left-metric results_dense_cortical_${method}_ztstat_m${corr}_m1_c${c}.gii -right-metric results_dense_cortical_${method}_ztstat_m${corr}_m2_c${c}.gii
					fi

				done
			done


		done
	done
done
cd ${maindir}
