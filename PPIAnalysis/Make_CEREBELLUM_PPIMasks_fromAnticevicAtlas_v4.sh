#!/bin/bash

maindir="/nafs/narr"
PPIMasksdir="${maindir}/jloureiro/Masks/paper2/PPIMasks"
AtlasMasksdir="${maindir}/jloureiro/scripts/ParcellationTemplates/ColeAnticevicNetPartition-master/Masks"
PALMdir="${maindir}/jloureiro/PALM3rdLevel"

colinerebellumdir="/nafs/narr/jloureiro/scripts/ParcellationTemplates/cerebellum_colin"
colinatlas="colin_cerebellum.lobules.native_cbllm"

suitdir="/nafs/apps/spm/64/12/toolbox/suit/atlas"
suitmasksdir="/nafs/narr/jloureiro/CEREBELLUM/SUITmasks"
suitatlas="Cerebellum-SUIT.nii"

MakeSuitMasks="NO"
MakeFuncROIS="NO"
MakeCombinedROIs="YES"
ConvertROIs2Cerebellum="NO"

module unload workbench
module load workbench/1.3.2
module load fsl


#1 Left_I_IV 1001
#2 Right_I_IV 1001
#3 Left_V 2002 
#5 Left_VI 2101 
#6 Vermis_VI 2101 
#7 Right_VI 2101 
#8 Left_CrusI 2102 
#9 Vermis_CrusI 2102 
#10 Right_CrusI 2102 
#11 Left_CrusII 2111 
#12 Vermis_CrusII 2111
#13 Right_CrusII 2111 
#14 Left_VIIb 2112 
#15 Vermis_VIIb 2112 
#16 Right_VIIb 2112 
#17 Left_VIIIa 2201
#18 Vermis_VIIIa 2201 
#19 Right_VIIIa 2201 
#20 Left_VIIIb 2202
#21 Vermis_VIIIb 2202
#22 Right_VIIIb 2202
#23 Left_IX 2211 
#24 Vermis_IX 2211
#25 Right_IX 2211 
#26 Left_X 2212 
#27 Vermis_X 2212 
#28 Right_X 2212 
#29 Left_Dentate 2301
#30 Right_Dentate 2301
#31 Left_Interposed 2302
#32 Right_Interposed 2302
#33 Left_Fastigial 2311
#34 Right_Fastigial 2311


if [ ${MakeSuitMasks} = "YES" ]
then

	ROIList="Right_V Right_VI Right_CrusI Right_CrusII Left_VIIb Right_VIIIa Right_VIIIb"	

	wb_command -volume-math 'x == 4' ${suitmasksdir}/Right_V.nii -var 'x' ${suitdir}/${suitatlas}
	
	wb_command -volume-math 'x == 7' ${suitmasksdir}/Right_VI.nii -var 'x' ${suitdir}/${suitatlas}
	wb_command -volume-math 'x == 5' ${suitmasksdir}/Left_VI.nii -var 'x' ${suitdir}/${suitatlas}

	wb_command -volume-math 'x == 10' ${suitmasksdir}/Right_CrusI.nii -var 'x' ${suitdir}/${suitatlas}
	wb_command -volume-math 'x == 8' ${suitmasksdir}/Left_CrusI.nii -var 'x' ${suitdir}/${suitatlas}
	
	wb_command -volume-math 'x == 13' ${suitmasksdir}/Right_CrusII.nii -var 'x' ${suitdir}/${suitatlas}

	wb_command -volume-math 'x == 14' ${suitmasksdir}/Left_VIIb.nii -var 'x' ${suitdir}/${suitatlas}
	
	wb_command -volume-math 'x == 19' ${suitmasksdir}/Right_VIIIa.nii -var 'x' ${suitdir}/${suitatlas}
	wb_command -volume-math 'x == 22' ${suitmasksdir}/Right_VIIIb.nii -var 'x' ${suitdir}/${suitatlas}

	for roi in ${ROIList}
	do
		flirt -in ${suitmasksdir}/${roi}.nii -ref /nafs/apps/fsl/64/6.0.0/data/standard/MNI152_T1_2mm.nii.gz -applyxfm -usesqform -interp nearestneighbour -out ${suitmasksdir}/${roi}_downsampled.nii.gz 
		rm ${suitmasksdir}/${roi}_downsampled.nii
		gunzip ${suitmasksdir}/${roi}_downsampled.nii.gz

	done

	
fi


if [ ${MakeFuncROIS} = "YES" ]
then
	

	FuncMask_NoGo_Go="${PALMdir}/CARIT/HCplusMDD"
	wb_command -cifti-separate ${FuncMask_NoGo_Go}/results_cifti_dat_ztstat.dscalar.nii COLUMN -volume-all ${FuncMask_NoGo_Go}/results_cifti_dat_ztstat.dscalar.nii_subcorticalvol.nii
	
	wb_command -volume-math 'x < -2.5' ${PPIMasksdir}/FuncMasks/AvNoGoGoztstatthr-2_FuncMask.nii -var 'x' ${FuncMask_NoGo_Go}/results_cifti_dat_ztstat.dscalar.nii_subcorticalvol.nii
	wb_command -volume-math 'x > 2.5' ${PPIMasksdir}/FuncMasks/AvNoGoGoztstatthr2_FuncMask.nii -var 'x' ${FuncMask_NoGo_Go}/results_cifti_dat_ztstat.dscalar.nii_subcorticalvol.nii
	
fi
	

if [ ${MakeCombinedROIs} = "YES" ]
then
	
wb_command -volume-math 'x * y * z' ${PPIMasksdir}/CombinedMasks/AvNoGoGoztstattr2_DAN_VIIbL.nii -var 'x' ${PPIMasksdir}/FuncMasks/AvNoGoGoztstatthr2_FuncMask.nii -var 'y' ${AtlasMasksdir}/Dorsal-attention/Dorsal-attention.cerebellum.nii -var 'z' ${suitmasksdir}/Left_VIIb_downsampled.nii
cp ${PPIMasksdir}/CombinedMasks/AvNoGoGoztstattr2_DAN_VIIbL.nii ${PPIMasksdir}/CombinedMasks/AverageBOLD_Networks_MMParcellation/Dorsal-attention/AvBOLD_Dorsal-attention_DAN_VIIb_L.nii	

wb_command -cifti-create-dense-from-template jloureiro/scripts/Pipelines-3.22.0/global/templates/91282_Greyordinates/Atlas_ROIs_labels.2.dlabel.nii ${PPIMasksdir}/CombinedMasks/AverageBOLD_Networks_MMParcellation/Dorsal-attention/AvBOLD_Dorsal-attention_DAN_VIIb_L.dscalar.nii -volume-all ${PPIMasksdir}/CombinedMasks/AverageBOLD_Networks_MMParcellation/Dorsal-attention/AvBOLD_Dorsal-attention_DAN_VIIb_L.nii 
cp ${PPIMasksdir}/CombinedMasks/AverageBOLD_Networks_MMParcellation/Dorsal-attention/AvBOLD_Dorsal-attention_DAN_VIIb_L.dscalar.nii ${PPIMasksdir}/CombinedMasks/TargetcerebellumROIs/
	
wb_command -volume-math 'x + y' ${suitmasksdir}/Right_VIIIa_b_downsampled.nii -var 'x' ${suitmasksdir}/Right_VIIIa_downsampled.nii -var 'y'  ${suitmasksdir}/Right_VIIIb_downsampled.nii
wb_command -volume-math 'x * y * z' ${PPIMasksdir}/CombinedMasks/AvNoGoGoztstatthr-2_SMN_VIIIA_BR.nii -var 'x' ${PPIMasksdir}/FuncMasks/AvNoGoGoztstatthr-2_FuncMask.nii -var 'y' ${AtlasMasksdir}/Somatomotor/Somatomotor.cerebellum.nii -var 'z' ${suitmasksdir}/Right_VIIIa_b_downsampled.nii
cp ${PPIMasksdir}/CombinedMasks/AvNoGoGoztstatthr-2_SMN_VIIIA_BR.nii ${PPIMasksdir}/CombinedMasks/AverageBOLD_Networks_MMParcellation/Somatomotor/AvBOLD_Somatomotor_SMN_VIIIA_B_R.nii
	
wb_command -cifti-create-dense-from-template jloureiro/scripts/Pipelines-3.22.0/global/templates/91282_Greyordinates/Atlas_ROIs_labels.2.dlabel.nii ${PPIMasksdir}/CombinedMasks/AverageBOLD_Networks_MMParcellation/Somatomotor/AvBOLD_Somatomotor_SMN_VIIIA_B_R.dscalar.nii -volume-all ${PPIMasksdir}/CombinedMasks/AverageBOLD_Networks_MMParcellation/Somatomotor/AvBOLD_Somatomotor_SMN_VIIIA_B_R.nii 
cp ${PPIMasksdir}/CombinedMasks/AverageBOLD_Networks_MMParcellation/Somatomotor/AvBOLD_Somatomotor_SMN_VIIIA_B_R.dscalar.nii ${PPIMasksdir}/CombinedMasks/TargetcerebellumROIs/

wb_command -volume-math 'x + y' ${suitmasksdir}/Right_V_VI_downsampled.nii -var 'x' ${suitmasksdir}/Right_V_downsampled.nii -var 'y' ${suitmasksdir}/Right_VI_downsampled.nii
wb_command -volume-math 'x * y * z' ${PPIMasksdir}/CombinedMasks/AvNoGoGoztstatthr-2_SMN_V_VIR.nii -var 'x' ${PPIMasksdir}/FuncMasks/AvNoGoGoztstatthr-2_FuncMask.nii -var 'y' ${AtlasMasksdir}/Somatomotor/Somatomotor.cerebellum.nii -var 'z' ${suitmasksdir}/Right_V_VI_downsampled.nii
cp ${PPIMasksdir}/CombinedMasks/AvNoGoGoztstatthr-2_SMN_V_VIR.nii ${PPIMasksdir}/CombinedMasks/AverageBOLD_Networks_MMParcellation/Somatomotor/AvBOLD_Somatomotor_SMN_V_VI_R.nii
	
wb_command -cifti-create-dense-from-template jloureiro/scripts/Pipelines-3.22.0/global/templates/91282_Greyordinates/Atlas_ROIs_labels.2.dlabel.nii ${PPIMasksdir}/CombinedMasks/AverageBOLD_Networks_MMParcellation/Somatomotor/AvBOLD_Somatomotor_SMN_V_VI_R.dscalar.nii -volume-all ${PPIMasksdir}/CombinedMasks/AverageBOLD_Networks_MMParcellation/Somatomotor/AvBOLD_Somatomotor_SMN_V_VI_R.nii 
cp ${PPIMasksdir}/CombinedMasks/AverageBOLD_Networks_MMParcellation/Somatomotor/AvBOLD_Somatomotor_SMN_V_VI_R.dscalar.nii ${PPIMasksdir}/CombinedMasks/TargetcerebellumROIs/


wb_command -volume-math 'x * y * z' ${PPIMasksdir}/CombinedMasks/AvNoGoGoztstatthr-2_DMN_CrusIL.nii -var 'x' ${PPIMasksdir}/FuncMasks/AvNoGoGoztstatthr-2_FuncMask.nii -var 'y' ${AtlasMasksdir}/Default/Default.cerebellum.nii -var 'z' ${suitmasksdir}/Left_CrusI_downsampled.nii
cp ${PPIMasksdir}/CombinedMasks/AvNoGoGoztstatthr-2_DMN_CrusIL.nii ${PPIMasksdir}/CombinedMasks/AverageBOLD_Networks_MMParcellation/Default/AvBOLD_Default_DMN_CrusI_L.nii
	
wb_command -cifti-create-dense-from-template jloureiro/scripts/Pipelines-3.22.0/global/templates/91282_Greyordinates/Atlas_ROIs_labels.2.dlabel.nii ${PPIMasksdir}/CombinedMasks/AverageBOLD_Networks_MMParcellation/Default/AvBOLD_Default_DMN_CrusI_L.dscalar.nii -volume-all ${PPIMasksdir}/CombinedMasks/AverageBOLD_Networks_MMParcellation/Default/AvBOLD_Default_DMN_CrusI_L.nii 
cp ${PPIMasksdir}/CombinedMasks/AverageBOLD_Networks_MMParcellation/Default/AvBOLD_Default_DMN_CrusI_L.dscalar.nii ${PPIMasksdir}/CombinedMasks/TargetcerebellumROIs/	
	
wb_command -volume-math 'x * y * z' ${PPIMasksdir}/CombinedMasks/AvNoGoGoztstatthr-2_DMN_CrusIR.nii -var 'x' ${PPIMasksdir}/FuncMasks/AvNoGoGoztstatthr-2_FuncMask.nii -var 'y' ${AtlasMasksdir}/Default/Default.cerebellum.nii -var 'z' ${suitmasksdir}/Right_CrusI_downsampled.nii
cp ${PPIMasksdir}/CombinedMasks/AvNoGoGoztstatthr-2_DMN_CrusIR.nii ${PPIMasksdir}/CombinedMasks/AverageBOLD_Networks_MMParcellation/Default/AvBOLD_Default_DMN_CrusI_R.nii
	
wb_command -cifti-create-dense-from-template jloureiro/scripts/Pipelines-3.22.0/global/templates/91282_Greyordinates/Atlas_ROIs_labels.2.dlabel.nii ${PPIMasksdir}/CombinedMasks/AverageBOLD_Networks_MMParcellation/Default/AvBOLD_Default_DMN_CrusI_R.dscalar.nii -volume-all ${PPIMasksdir}/CombinedMasks/AverageBOLD_Networks_MMParcellation/Default/AvBOLD_Default_DMN_CrusI_R.nii 
cp ${PPIMasksdir}/CombinedMasks/AverageBOLD_Networks_MMParcellation/Default/AvBOLD_Default_DMN_CrusI_R.dscalar.nii ${PPIMasksdir}/CombinedMasks/TargetcerebellumROIs/	



wb_command -volume-math 'x * y * z' ${PPIMasksdir}/CombinedMasks/AvNoGoGoztstatthr-2_CON_VIL.nii -var 'x' ${PPIMasksdir}/FuncMasks/AvNoGoGoztstatthr-2_FuncMask.nii -var 'y' ${AtlasMasksdir}/Cingulo-Opercular/Cingulo-Opercular.cerebellum.nii -var 'z' ${suitmasksdir}/Left_VI_downsampled.nii
cp ${PPIMasksdir}/CombinedMasks/AvNoGoGoztstatthr-2_CON_VIL.nii ${PPIMasksdir}/CombinedMasks/AverageBOLD_Networks_MMParcellation/Cingulo-Opercular/AvBOLD_Cingulo-Opercular_CON_VI_L.nii
	
wb_command -cifti-create-dense-from-template jloureiro/scripts/Pipelines-3.22.0/global/templates/91282_Greyordinates/Atlas_ROIs_labels.2.dlabel.nii ${PPIMasksdir}/CombinedMasks/AverageBOLD_Networks_MMParcellation/Cingulo-Opercular/AvBOLD_Cingulo-Opercular_CON_VI_L.dscalar.nii -volume-all ${PPIMasksdir}/CombinedMasks/AverageBOLD_Networks_MMParcellation/Cingulo-Opercular/AvBOLD_Cingulo-Opercular_CON_VI_L.nii 
cp ${PPIMasksdir}/CombinedMasks/AverageBOLD_Networks_MMParcellation/Cingulo-Opercular/AvBOLD_Cingulo-Opercular_CON_VI_L.dscalar.nii ${PPIMasksdir}/CombinedMasks/TargetcerebellumROIs/	

wb_command -volume-math 'x * y * z' ${PPIMasksdir}/CombinedMasks/AvNoGoGoztstatthr-2_CON_VIR.nii -var 'x' ${PPIMasksdir}/FuncMasks/AvNoGoGoztstatthr-2_FuncMask.nii -var 'y' ${AtlasMasksdir}/Cingulo-Opercular/Cingulo-Opercular.cerebellum.nii -var 'z' ${suitmasksdir}/Right_VI_downsampled.nii
cp ${PPIMasksdir}/CombinedMasks/AvNoGoGoztstatthr-2_CON_VIR.nii ${PPIMasksdir}/CombinedMasks/AverageBOLD_Networks_MMParcellation/Cingulo-Opercular/AvBOLD_Cingulo-Opercular_CON_VI_R.nii
	
wb_command -cifti-create-dense-from-template jloureiro/scripts/Pipelines-3.22.0/global/templates/91282_Greyordinates/Atlas_ROIs_labels.2.dlabel.nii ${PPIMasksdir}/CombinedMasks/AverageBOLD_Networks_MMParcellation/Cingulo-Opercular/AvBOLD_Cingulo-Opercular_CON_VI_R.dscalar.nii -volume-all ${PPIMasksdir}/CombinedMasks/AverageBOLD_Networks_MMParcellation/Cingulo-Opercular/AvBOLD_Cingulo-Opercular_CON_VI_R.nii 
cp ${PPIMasksdir}/CombinedMasks/AverageBOLD_Networks_MMParcellation/Cingulo-Opercular/AvBOLD_Cingulo-Opercular_CON_VI_R.dscalar.nii ${PPIMasksdir}/CombinedMasks/TargetcerebellumROIs/	


wb_command -volume-math 'x * y * z' ${PPIMasksdir}/CombinedMasks/AvNoGoGoztstatthr2_FPN_CrusIL.nii -var 'x' ${PPIMasksdir}/FuncMasks/AvNoGoGoztstatthr2_FuncMask.nii -var 'y' ${AtlasMasksdir}/Frontoparietal/Frontoparietal.cerebellum.nii -var 'z' ${suitmasksdir}/Left_CrusI_downsampled.nii
cp ${PPIMasksdir}/CombinedMasks/AvNoGoGoztstatthr2_FPN_CrusIL.nii ${PPIMasksdir}/CombinedMasks/AverageBOLD_Networks_MMParcellation/Frontoparietal/AvBOLD_Frontoparietal_FPN_CrusI_L.nii
	
wb_command -cifti-create-dense-from-template jloureiro/scripts/Pipelines-3.22.0/global/templates/91282_Greyordinates/Atlas_ROIs_labels.2.dlabel.nii ${PPIMasksdir}/CombinedMasks/AverageBOLD_Networks_MMParcellation/Frontoparietal/AvBOLD_Frontoparietal_FPN_CrusI_L.dscalar.nii -volume-all ${PPIMasksdir}/CombinedMasks/AverageBOLD_Networks_MMParcellation/Frontoparietal/AvBOLD_Frontoparietal_FPN_CrusI_L.nii 
cp ${PPIMasksdir}/CombinedMasks/AverageBOLD_Networks_MMParcellation/Frontoparietal/AvBOLD_Frontoparietal_FPN_CrusI_L.dscalar.nii ${PPIMasksdir}/CombinedMasks/TargetcerebellumROIs/	
	
fi

if [ ${ConvertROIs2Cerebellum} = "YES" ]
then

	ROIs="AvNoGoGoztstattr2_DAN_VIIbL AvNoGoGoztstatthr-2_SMN_VIIIA_BR AvNoGoGoztstatthr-2_SMN_V_VIR AvNoGoGoztstatthr-2_DMN_CrusIL AvNoGoGoztstatthr-2_DMN_CrusIR AvNoGoGoztstatthr-2_CON_VIL AvNoGoGoztstatthr-2_CON_VIR AvNoGoGoztstatthr2_FPN_CrusIL"
	#ROIs="ASL_Frontoparietal"
	for roi in ${ROIs}
	do 
		CEREBELLAR_SURFACE=colin.cerebellum.anatomical_MNI.surf.gii
		CEREBELLAR_SURFACE_DIR=/nafs/narr/jloureiro/CEREBELLUM/cerebellum_colin
		LabelVolumeAtlas=/nafs/narr/jloureiro/scripts/Pipelines-3.22.0/global/templates/91282_Greyordinates/Atlas_ROIs.2.nii
		INPUT_PREFIX=${roi}
		CIFTI_FILE_DIR=${PPIMasksdir}/CombinedMasks
		INPUT_CIFTI_FILE=${roi}.nii

		#wb_command -volume-dilate $CIFTI_FILE_DIR/$INPUT_PREFIX.nii 1 NEAREST $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum_dilate1.nii

		wb_command -volume-to-surface-mapping $CIFTI_FILE_DIR/$INPUT_PREFIX.nii $CEREBELLAR_SURFACE_DIR/$CEREBELLAR_SURFACE $CIFTI_FILE_DIR/$INPUT_PREFIX.cerebellum.func.gii -enclosing
		
	done

fi


echo "finished"

