#!/bin/bash 


#1- transfrm into nifti:
#wb_command -cifti-separate FM_cope5_HC_MDDTP1mean_results_cifti_dat.dscalar.nii COLUMN -volume-all FM_cope5_HC_MDDTP1mean_results_cifti_dat_subcortical.nii

#Matlab command to convert data into suit flatmap
#Data=suit_map2surf('FM_cope5+cope10_HC_MDDTP1mean_results_cifti_dat_subcortical_2.3bin.nii', 'space', 'FSL', 'stats', @minORmax);
#suit_plotflatmap(Data,'threshold',2.3, 'cscale', [2 3.3], 'cmap',summer)



#Directory of SUIT images: 

#/nafs/apps/spm/64/12/toolbox/suit/atlas/Cerebellum-SUIT.nii

#Cerebellum-SUIT.nii.gz: 	Maximum probability map signifying the most probable compartment (1-28) 
#Cerebellum-SUIT.txt: 		Assignment of compartment numbers to lobules 
#Cerebellum-SUIT-maxprob.nii: 	Probability of the compartment with the highest probability 
#Cerebellum-SUIT-prob.nii: 	28 full probability maps for each of the compartments 



#1 Left_I_IV 1001
#2 Right_I_IV 1001
#3 Left_V 2002 
#4 Right_V 2002 ######################### gonoo
#5 Left_VI 2101 
#6 Vermis_VI 2101 ##################### f>o
#7 Right_VI 2101 ######################### gonoo
#8 Left_CrusI 2102 ########################f>o
#9 Vermis_CrusI 2102 ########################f>o
#10 Right_CrusI 2102 ######################fearful-neutral
#11 Left_CrusII 2111 #####################f>o & happy-neutral
#12 Vermis_CrusII 2111#####################f>o
#13 Right_CrusII 2111 ######################fearful-neutral
#14 Left_VIIb 2112 ########################f>o
#15 Vermis_VIIb 2112 ###################f>o
#16 Right_VIIb 2112 
#17 Left_VIIIa 2201
#18 Vermis_VIIIa 2201 ######################f>o
#19 Right_VIIIa 2201 ######################### gonoo
#20 Left_VIIIb 2202
#21 Vermis_VIIIb 2202 ###################f>o
#22 Right_VIIIb 2202
#23 Left_IX 2211 
#24 Vermis_IX 2211 ######################f>o
#25 Right_IX 2211 ######################fearful-neutral
#26 Left_X 2212 ########################f>o
#27 Vermis_X 2212 ######################f>o
#28 Right_X 2212 ######################f>o
#29 Left_Dentate 2301
#30 Right_Dentate 2301
#31 Left_Interposed 2302
#32 Right_Interposed 2302
#33 Left_Fastigial 2311
#34 Right_Fastigial 2311



module load fsl
module load workbench/1.3.2

suitdir="/nafs/apps/spm/64/12/toolbox/suit/atlas"
suitatlas="Cerebellum-SUIT.nii"
suitlabels="Cerebellum-SUIT.nii.txt"
funcmapsdir="/nafs/narr/jloureiro/PALM3rdLevel/FM/paper2/KTP1_KTP3"
suitmasksdir="/nafs/narr/jloureiro/Masks/CEREBELLUM_masks/SUITmasks"
funcmasksdir="/nafs/narr/jloureiro/Masks/paper2/FuncMasks"

combinedmasksdir="/nafs/narr/jloureiro/Masks/paper2/CombinedMasks/cerebellum"

suitmasks="Right_V Left_V Right_VI Left_VI Vermis_VI Right_CrusI Left_CrusI Vermis_CrusI Right_CrusII Left_CrusII Vermis_CrusII Right_VIIb Left_VIIb Vermis_VIIb Right_VIIIa Left_VIIIa Left_VIIIb Left_IX"
#suitmasks="Left_V Left_IX"

MakeFuncROIs="YES"
MakeSUITROIs="YES"
MakeCombinedROIs="YES"
MakePeackActivationROIs="YES"

#Make masks from functional maps 
if [ ${MakeFuncROIs} = "YES" ]
then
	
	wb_command -cifti-separate ${funcmapsdir}/cope2/results_dense_tfce_ztstat_fwep_c1.dscalar.nii COLUMN -volume-all ${funcmapsdir}/cope2/results_dense_tfce_ztstat_fwep_c1_vol.nii
	wb_command -volume-math 'x > 1.3' ${funcmasksdir}/Mask_KTP1_KTP3_cope2_c1_p005.nii -var 'x' ${funcmapsdir}/cope2/results_dense_tfce_ztstat_fwep_c1_vol.nii 

fi 
#Make SUIT subdivisions masks###############
if [ ${MakeSUITROIs} = "YES" ]
then

	wb_command -volume-math 'x == 4' ${suitmasksdir}/Right_V.nii -var 'x' ${suitdir}/${suitatlas}
	wb_command -volume-math 'x == 3' ${suitmasksdir}/Left_V.nii -var 'x' ${suitdir}/${suitatlas}
	wb_command -volume-math 'x == 7' ${suitmasksdir}/Right_VI.nii -var 'x' ${suitdir}/${suitatlas}
	wb_command -volume-math 'x == 5' ${suitmasksdir}/Left_VI.nii -var 'x' ${suitdir}/${suitatlas}
	wb_command -volume-math 'x == 6' ${suitmasksdir}/Vermis_VI.nii -var 'x' ${suitdir}/${suitatlas}
	wb_command -volume-math 'x == 10' ${suitmasksdir}/Right_CrusI.nii -var 'x' ${suitdir}/${suitatlas}
	wb_command -volume-math 'x == 8' ${suitmasksdir}/Left_CrusI.nii -var 'x' ${suitdir}/${suitatlas}
	wb_command -volume-math 'x == 9' ${suitmasksdir}/Vermis_CrusI.nii -var 'x' ${suitdir}/${suitatlas}
	wb_command -volume-math 'x == 13' ${suitmasksdir}/Right_CrusII.nii -var 'x' ${suitdir}/${suitatlas}
	wb_command -volume-math 'x == 11' ${suitmasksdir}/Left_CrusII.nii -var 'x' ${suitdir}/${suitatlas}
	wb_command -volume-math 'x == 12' ${suitmasksdir}/Vermis_CrusII.nii -var 'x' ${suitdir}/${suitatlas}
	wb_command -volume-math 'x == 16' ${suitmasksdir}/Right_VIIb.nii -var 'x' ${suitdir}/${suitatlas}
	wb_command -volume-math 'x == 14' ${suitmasksdir}/Left_VIIb.nii -var 'x' ${suitdir}/${suitatlas}
	wb_command -volume-math 'x == 15' ${suitmasksdir}/Vermis_VIIb.nii -var 'x' ${suitdir}/${suitatlas}
	wb_command -volume-math 'x == 19' ${suitmasksdir}/Right_VIIIa.nii -var 'x' ${suitdir}/${suitatlas}
	wb_command -volume-math 'x == 17' ${suitmasksdir}/Left_VIIIa.nii -var 'x' ${suitdir}/${suitatlas}
	wb_command -volume-math 'x == 20' ${suitmasksdir}/Left_VIIIb.nii -var 'x' ${suitdir}/${suitatlas}
	wb_command -volume-math 'x == 23' ${suitmasksdir}/Left_IX.nii -var 'x' ${suitdir}/${suitatlas}
	
	#wb_command -volume-math 'x == 21' ${suitmasksdir}/Vermis_VIIIb.nii -var 'x' ${suitdir}/${suitatlas}
	#wb_command -volume-math 'x == 24' ${suitmasksdir}/Vermis_IX.nii -var 'x' ${suitdir}/${suitatlas}
	#wb_command -volume-math 'x == 26' ${suitmasksdir}/Left_X.nii -var 'x' ${suitdir}/${suitatlas}
	#wb_command -volume-math 'x == 27' ${suitmasksdir}/Vermis_X.nii -var 'x' ${suitdir}/${suitatlas}
	#wb_command -volume-math 'x == 28' ${suitmasksdir}/Right_X.nii -var 'x' ${suitdir}/${suitatlas}
	#wb_command -volume-math 'x == 25' ${suitmasksdir}/Right_IX.nii -var 'x' ${suitdir}/${suitatlas}
	

#Downsample suit masks######################################

	for roi in ${suitmasks}
	do
		flirt -in ${suitmasksdir}/${roi}.nii -ref /nafs/apps/fsl/64/6.0.0/data/standard/MNI152_T1_2mm.nii.gz -applyxfm -usesqform -interp nearestneighbour -out ${suitmasksdir}/${roi}_downsampled.nii.gz 
		rm ${suitmasksdir}/${roi}_downsampled.nii
		gunzip ${suitmasksdir}/${roi}_downsampled.nii.gz

	done
fi
#Make combined masks`########################

if [ ${MakeCombinedROIs} = "YES" ]
then
	args=""
	for roi in ${suitmasks}
	do
		wb_command -volume-math 'x * y' ${combinedmasksdir}/${roi}_KTP1KTP3cope2c1_vol.nii -var 'x' ${funcmasksdir}/Mask_KTP1_KTP3_cope2_c1_p005.nii -var 'y' ${suitmasksdir}/${roi}_downsampled.nii

		#wb_command -cifti-create-dense-scalar ${combinedmasksdir}/${roi}_KTP1KTP3cope2c1.dscalar.nii -volume ${combinedmasksdir}/${roi}_KTP1KTP3cope2c1.nii /nafs/narr/jloureiro/scripts/Pipelines-3.22.0/global/templates/91282_Greyordinates/Atlas_ROIs.2.nii -left-metric /nafs/narr/jloureiro/scripts/Pipelines-3.22.0/global/templates/standard_mesh_atlases/L.atlasroi.32k_fs_LR.shape.gii -right-metric /nafs/narr/jloureiro/scripts/Pipelines-3.22.0/global/templates/standard_mesh_atlases/R.atlasroi.32k_fs_LR.shape.gii 

		#wb_command -cifti-create-dense-from-template /nafs/narr/jloureiro/scripts/Pipelines-3.22.0/global/templates/91282_Greyordinates/91282_Greyordinates.dscalar.nii ${combinedmasksdir}/${roi}_KTP1KTP3cope2c1.dscalar.nii -cifti ${combinedmasksdir}/${roi}_KTP1KTP3cope2c1.dscalar.nii
		
		args="${args} -volume ${combinedmasksdir}/${roi}_KTP1KTP3cope2c1_vol.nii "

	done

	
	wb_command -volume-merge ${combinedmasksdir}/MERGEDROIs_cerebellum_KTP1KTP3cope2c1_vol.nii ${args} 
	
	
fi

echo "finished"


