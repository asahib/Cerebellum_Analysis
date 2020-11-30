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
module load workbench

suitdir="/nafs/apps/spm/64/12/toolbox/suit/atlas"
suitatlas="Cerebellum-SUIT.nii"
suitlabels="Cerebellum-SUIT.nii.txt"
funcmapsdir="/nafs/narr/jloureiro/CEREBELLUM/FunctionalMaps/NARSAD_FINAL"
suitmasksdir="/nafs/narr/jloureiro/CEREBELLUM/SUITmasks"

combinedmasksdir="/nafs/narr/jloureiro/CEREBELLUM/CombinedMasks"

suitmasksgonogo="Right_V Right_VI Right_VIIIa"

suitmasksfacesobjects="Vermis_VI Vermis_CrusI Left_CrusI Vermis_CrusII Left_CrusII Vermis_VIIb Left_VIIb Vermis_VIIIa Vermis_VIIIb Vermis_IX Left_X Vermis_X Right_X"

suitmasksfearfulneutral="Right_CrusI Right_CrusII Right_IX"

suitmaskshappyneutral="Left_CrusII"

suitmasks="Right_V Right_VI Right_VIIIa Vermis_VI Vermis_CrusI Left_CrusI Vermis_CrusII Left_CrusII Vermis_VIIb Left_VIIb Vermis_VIIIa Vermis_VIIIb Vermis_IX Left_X Vermis_X Right_X Right_CrusI Right_CrusII Right_IX"


MakeFuncROIs="YES"
MakeSUITROIs="YES"
MakeCombinedROIs="YES"
MakePeackActivationROIs="YES"

#Make masks from functional maps 
if [ ${MakeFuncROIs} = "YES" ]
then

	wb_command -volume-math 'x > 1.3' ${funcmapsdir}/Mask_GONOGO_fwep13bin.nii -var 'x' ${funcmapsdir}/CARIT_cope5_HC_MDDTP1mean_tfce_subcortical_fwep.nii

	wb_command -volume-math 'x > 1.3' ${funcmapsdir}/Mask_faces-objects_fwep13bin.nii -var 'x' ${funcmapsdir}/FM_cope15_HC_MDDTP1mean_tfce_subcortical_fwep.nii
	
	wb_command -volume-math 'x > 2.3' ${funcmapsdir}/Mask_fearful-neutral_23zstatbin.nii -var 'x' ${funcmapsdir}/FM_cope10_HC_MDDTP1mean_results_cifti_dat_subcortical.nii

	wb_command -volume-math 'x > 2.3' ${funcmapsdir}/Mask_happy-neutral_23zstatbin.nii -var 'x' ${funcmapsdir}/FM_cope5_HC_MDDTP1mean_results_cifti_dat_subcortical.nii
fi 
#Make SUIT subdivisions masks###############
if [ ${MakeSUITROIs} = "YES" ]
then

	wb_command -volume-math 'x == 4' ${suitmasksdir}/Right_V.nii -var 'x' ${suitdir}/${suitatlas}
	wb_command -volume-math 'x == 7' ${suitmasksdir}/Right_VI.nii -var 'x' ${suitdir}/${suitatlas}
	wb_command -volume-math 'x == 19' ${suitmasksdir}/Right_VIIIa.nii -var 'x' ${suitdir}/${suitatlas}

	wb_command -volume-math 'x == 6' ${suitmasksdir}/Vermis_VI.nii -var 'x' ${suitdir}/${suitatlas}
	wb_command -volume-math 'x == 8' ${suitmasksdir}/Left_CrusI.nii -var 'x' ${suitdir}/${suitatlas}
	wb_command -volume-math 'x == 9' ${suitmasksdir}/Vermis_CrusI.nii -var 'x' ${suitdir}/${suitatlas}
	wb_command -volume-math 'x == 11' ${suitmasksdir}/Left_CrusII.nii -var 'x' ${suitdir}/${suitatlas}
	wb_command -volume-math 'x == 12' ${suitmasksdir}/Vermis_CrusII.nii -var 'x' ${suitdir}/${suitatlas}
	wb_command -volume-math 'x == 15' ${suitmasksdir}/Vermis_VIIb.nii -var 'x' ${suitdir}/${suitatlas}
	wb_command -volume-math 'x == 14' ${suitmasksdir}/Left_VIIb.nii -var 'x' ${suitdir}/${suitatlas}
	wb_command -volume-math 'x == 18' ${suitmasksdir}/Vermis_VIIIa.nii -var 'x' ${suitdir}/${suitatlas}
	wb_command -volume-math 'x == 21' ${suitmasksdir}/Vermis_VIIIb.nii -var 'x' ${suitdir}/${suitatlas}
	wb_command -volume-math 'x == 24' ${suitmasksdir}/Vermis_IX.nii -var 'x' ${suitdir}/${suitatlas}
	wb_command -volume-math 'x == 26' ${suitmasksdir}/Left_X.nii -var 'x' ${suitdir}/${suitatlas}
	wb_command -volume-math 'x == 27' ${suitmasksdir}/Vermis_X.nii -var 'x' ${suitdir}/${suitatlas}
	wb_command -volume-math 'x == 28' ${suitmasksdir}/Right_X.nii -var 'x' ${suitdir}/${suitatlas}

	wb_command -volume-math 'x == 10' ${suitmasksdir}/Right_CrusI.nii -var 'x' ${suitdir}/${suitatlas}
	wb_command -volume-math 'x == 13' ${suitmasksdir}/Right_CrusII.nii -var 'x' ${suitdir}/${suitatlas}
	wb_command -volume-math 'x == 25' ${suitmasksdir}/Right_IX.nii -var 'x' ${suitdir}/${suitatlas}

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

	for roi in ${suitmasksgonogo}
	do
		wb_command -volume-math 'x * y' ${combinedmasksdir}/${roi}_gonogo.nii -var 'x' ${funcmapsdir}/Mask_GONOGO_fwep13bin.nii -var 'y' ${suitmasksdir}/${roi}_downsampled.nii
	done

	for roi in ${suitmasksfacesobjects}
	do

		wb_command -volume-math 'x * y' ${combinedmasksdir}/${roi}_faces-objects.nii -var 'x' ${funcmapsdir}/Mask_faces-objects_fwep13bin.nii -var 'y' ${suitmasksdir}/${roi}_downsampled.nii

	done
	for roi in ${suitmasksfearfulneutral}
	do

		wb_command -volume-math 'x * y' ${combinedmasksdir}/${roi}_fearful-neutral.nii -var 'x' ${funcmapsdir}/Mask_fearful-neutral_23zstatbin.nii -var 'y' ${suitmasksdir}/${roi}_downsampled.nii

	done
	for roi in ${suitmaskshappyneutral}
	do

		wb_command -volume-math 'x * y' ${combinedmasksdir}/${roi}_happy-neutral.nii -var 'x' ${funcmapsdir}/Mask_happy-neutral_23zstatbin.nii -var 'y' ${suitmasksdir}/${roi}_downsampled.nii

	done
fi
#Make sphere around peak activation mask###########################

if [ ${MakePeackActivationROIs} = "YES" ]
then

	#coorinates by looking in fsleyes
	#1) coordinates for CARIT 1stcluster (LCrusI/HVI):35,39,26; 
	
	x1="35"
	y1="39"
	z1="26"

	fslmaths ${funcmapsdir}/Mask_GONOGO_fwep13bin.nii -mul 0 -add 1 -roi ${x1} 1 ${y1} 1 ${z1} 1 0 1 ${funcmapsdir}/SpheresROIs/Mask_GONOGO_fwep13bin_x1${x1}_y1${y1}_z1${z1}.nii -odt float
	
	fslmaths ${funcmapsdir}/SpheresROIs/Mask_GONOGO_fwep13bin_x1${x1}_y1${y1}_z1${z1}.nii  -kernel sphere 4 -fmean ${funcmapsdir}/SpheresROIs/Mask_GONOGO_fwep13bin_x1${x1}_y1${y1}_z1${z1}_4mm.nii  -odt float

	#2) coordinates for CARIT  2ndcluster(LVIIIa):37,30,10

	x2="37"
	y2="30"
	z2="10"

	fslmaths ${funcmapsdir}/Mask_GONOGO_fwep13bin.nii -mul 0 -add 1 -roi ${x2} 1 ${y2} 1 ${z2} 1 0 1 ${funcmapsdir}/SpheresROIs/Mask_GONOGO_fwep13bin_x2${x2}_y2${y2}_z2${z2}.nii -odt float
	
	fslmaths ${funcmapsdir}/SpheresROIs/Mask_GONOGO_fwep13bin_x2${x2}_y2${y2}_z2${z2}.nii  -kernel sphere 4 -fmean ${funcmapsdir}/SpheresROIs/Mask_GONOGO_fwep13bin_x2${x2}_y2${y2}_z2${z2}_4mm.nii  -odt float

	#3) coordinates for faces-objects  1stcluster(LVIIb):62,28,10

	x1="62"
	y1="28"
	z1="10"

	fslmaths ${funcmapsdir}/Mask_faces-objects_fwep13bin.nii -mul 0 -add 1 -roi ${x1} 1 ${y1} 1 ${z1} 1 0 1 ${funcmapsdir}/SpheresROIs/Mask_faces-objects_fwep13bin_x1${x1}_y1${y1}_z1${z1}.nii -odt float
	
	fslmaths ${funcmapsdir}/SpheresROIs/Mask_faces-objects_fwep13bin_x1${x1}_y1${y1}_z1${z1}.nii  -kernel sphere 4 -fmean ${funcmapsdir}/SpheresROIs/Mask_faces-objects_fwep13bin_x1${x1}_y1${y1}_z1${z1}_4mm.nii  -odt float

	#4) coordinates for faces-objects  2ndcluster(VermisVI):45,26,24

	x2="45"
	y2="26"
	z2="24"

	fslmaths ${funcmapsdir}/Mask_faces-objects_fwep13bin.nii -mul 0 -add 1 -roi ${x2} 1 ${y2} 1 ${z2} 1 0 1 ${funcmapsdir}/SpheresROIs/Mask_faces-objects_fwep13bin_x2${x2}_y2${y2}_z2${z2}.nii -odt float
	
	fslmaths ${funcmapsdir}/SpheresROIs/Mask_faces-objects_fwep13bin_x2${x2}_y2${y2}_z2${z2}.nii  -kernel sphere 4 -fmean ${funcmapsdir}/SpheresROIs/Mask_faces-objects_fwep13bin_x2${x2}_y2${y2}_z2${z2}_4mm.nii  -odt float

	#5) coordinates for faces-objects  3rdcluster(VermisIX):46,36,18

	x3="46"
	y3="36"
	z3="18"

	fslmaths ${funcmapsdir}/Mask_faces-objects_fwep13bin.nii -mul 0 -add 1 -roi ${x3} 1 ${y3} 1 ${z3} 1 0 1 ${funcmapsdir}/SpheresROIs/Mask_faces-objects_fwep13bin_x3${x3}_y3${y3}_z3${z3}.nii -odt float
	
	fslmaths ${funcmapsdir}/SpheresROIs/Mask_faces-objects_fwep13bin_x3${x3}_y3${y3}_z3${z3}.nii  -kernel sphere 4 -fmean ${funcmapsdir}/SpheresROIs/Mask_faces-objects_fwep13bin_x3${x3}_y3${y3}_z3${z3}_4mm.nii  -odt float

	#6) coordinates for faces-objects  4thcluster(LCrusI):58,32,21

	x4="58"
	y4="32"
	z4="21"

	fslmaths ${funcmapsdir}/Mask_faces-objects_fwep13bin.nii -mul 0 -add 1 -roi ${x4} 1 ${y4} 1 ${z4} 1 0 1 ${funcmapsdir}/SpheresROIs/Mask_faces-objects_fwep13bin_x4${x4}_y4${y4}_z4${z4}.nii -odt float
	
	fslmaths ${funcmapsdir}/SpheresROIs/Mask_faces-objects_fwep13bin_x4${x4}_y4${y4}_z4${z4}.nii  -kernel sphere 4 -fmean ${funcmapsdir}/SpheresROIs/Mask_faces-objects_fwep13bin_x4${x4}_y4${y4}_z4${z4}_4mm.nii  -odt float

	#7) coordinates for happy-neutral  1stcluster(LCrusII):54,26,17

	x1="54"
	y1="26"
	z1="17"

	fslmaths ${funcmapsdir}/Mask_happy-neutral_23zstatbin.nii -mul 0 -add 1 -roi ${x1} 1 ${y1} 1 ${z1} 1 0 1 ${funcmapsdir}/SpheresROIs/Mask_happy-neutral_23zstatbin_x1${x1}_y1${y1}_z1${z1}.nii -odt float
	
	fslmaths ${funcmapsdir}/SpheresROIs/Mask_happy-neutral_23zstatbin_x1${x1}_y1${y1}_z1${z1}.nii  -kernel sphere 4 -fmean ${funcmapsdir}/SpheresROIs/Mask_happy-neutral_23zstatbin_x1${x1}_y1${y1}_z1${z1}_4mm.nii  -odt float

	#7) coordinates for fearful-neutral  1stcluster(RCrusI/CrusII):34,22,21

	x1="34"
	y1="22"
	z1="21"

	fslmaths ${funcmapsdir}/Mask_fearful-neutral_23zstatbin.nii -mul 0 -add 1 -roi ${x1} 1 ${y1} 1 ${z1} 1 0 1 ${funcmapsdir}/SpheresROIs/Mask_fearful-neutral_23zstatbin_x1${x1}_y1${y1}_z1${z1}.nii -odt float
	
	fslmaths ${funcmapsdir}/SpheresROIs/Mask_fearful-neutral_23zstatbin_x1${x1}_y1${y1}_z1${z1}.nii  -kernel sphere 4 -fmean ${funcmapsdir}/SpheresROIs/Mask_fearful-neutral_23zstatbin_x1${x1}_y1${y1}_z1${z1}_4mm.nii  -odt float

	#8) coordinates for fearful-neutral  2ndcluster(RCrusI/CrusII):28,23,17

	x2="28"
	y2="23"
	z2="17"

	fslmaths ${funcmapsdir}/Mask_fearful-neutral_23zstatbin.nii -mul 0 -add 1 -roi ${x2} 1 ${y2} 1 ${z2} 1 0 1 ${funcmapsdir}/SpheresROIs/Mask_fearful-neutral_23zstatbin_x2${x2}_y2${y2}_z2${z2}.nii -odt float
	
	fslmaths ${funcmapsdir}/SpheresROIs/Mask_fearful-neutral_23zstatbin_x2${x2}_y2${y2}_z2${z2}.nii  -kernel sphere 4 -fmean ${funcmapsdir}/SpheresROIs/Mask_fearful-neutral_23zstatbin_x2${x2}_y2${y2}_z2${z2}_4mm.nii  -odt float

fi
