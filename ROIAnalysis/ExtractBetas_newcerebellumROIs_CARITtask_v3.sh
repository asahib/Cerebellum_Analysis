#!/bin/sh

hcpdir="/nafs/narr/HCP_OUTPUT"
maindir="/nafs/narr/jloureiro"
StudyFolder="${hcpdir}" #Location of Subject folders (named by subjectID)
Subjlist=$(<$maindir/logstxt/CARIT_task/ALLSubs4PPI.txt) #Space delimited list of subject IDs
echo "$Subjlist" 

EnvironmentScript="${maindir}/scripts/Pipelines-3.22.0/Examples/Scripts/SetUpHCPPipeline_JL_4slurm.sh"

source ${EnvironmentScript}
cope="cope3"
module load workbench/1.3.2

ROIMasksdir="${maindir}/Masks/paper2/ColeAnticevicMasks"
CombinedMasksdir="${maindir}/Masks/paper2/PPIMasks/CombinedMasks/AverageBOLD_Networks_MMParcellation"
CopeList="cope3"		
logdir="${maindir}/logstxt/paper2/PPIAnalysis/Extractbetas"
Networks="Default Frontoparietal Cingulo-Opercular Dorsal-attention Somatomotor"
logfile_SumRL="${logdir}/SUM_${PPIROI}_RL.txt"
logfile_SumL="${logdir}/SUM_${PPIROI}_L.txt"
logfile_SumR="${logdir}/SUM_${PPIROI}_R.txt"

logfile_ALLNetsin1_SumRL="${logdir}/SUM_ALLNetsin1_${PPIROI}_RL.txt"
logfile_ALLNetsin1_SumL="${logdir}/SUM_ALLNetsin1_${PPIROI}_L.txt"
logfile_ALLNetsin1_SumR="${logdir}/SUM_ALLNetsin1_${PPIROI}_R.txt"

rm ${logfile_SumRL}
rm ${logfile_SumL}
rm ${logfile_SumR}

rm ${logfile_ALLNetsin1_SumRL}
rm ${logfile_ALLNetsin1_SumL}
rm ${logfile_ALLNetsin1_SumR}

for net in ${Networks}
do

logfile_R="${logdir}/MERGEDROIs_${PPIROI}_AvBOLD_${net}_R.txt"
logfile_L="${logdir}/MERGEDROIs_${PPIROI}_AvBOLD_${net}_L.txt"
if [ -f ${logfile} ]; then
#rm ${logfile_RL}
rm ${logfile_R}
rm ${logfile_L}

fi
for sub in ${Subjlist}
do
imagesdir="${hcpdir}/${sub}/MNINonLinear"
betaimgsdir="${imagesdir}/Results/task-carit_acq-PA_run-01/task-carit_acq-PA_run-01_JL_clean_PPIAnalysis_${PPIROI}_hp200_s5_level1.feat/GrayordinatesStats"

wb_command -cifti-stats ${betaimgsdir}/${cope}.dtseries.nii -reduce MEAN -roi ${CombinedMasksdir}/${net}/MERGEDROIs_AvBOLD_${net}_R.dscalar.nii >> ${logfile_R}
wb_command -cifti-stats ${betaimgsdir}/${cope}.dtseries.nii -reduce MEAN -roi ${CombinedMasksdir}/${net}/MERGEDROIs_AvBOLD_${net}_L.dscalar.nii >> ${logfile_L}


done
done
for sub in ${Subjlist}
do
imagesdir="${hcpdir}/${sub}/MNINonLinear"
betaimgsdir="${imagesdir}/Results/task-carit_acq-PA_run-01/task-carit_acq-PA_run-01_JL_clean_PPIAnalysis_${PPIROI}_hp200_s5_level1.feat/GrayordinatesStats"

wb_command -cifti-stats ${betaimgsdir}/${cope}.dtseries.nii -reduce MEAN -roi ${CombinedMasksdir}/SUM_AvBOLD_RL.dscalar.nii >> ${logfile_SumRL}
wb_command -cifti-stats ${betaimgsdir}/${cope}.dtseries.nii -reduce MEAN -roi ${CombinedMasksdir}/SUM_AvBOLD_L.dscalar.nii>> ${logfile_SumL}
wb_command -cifti-stats ${betaimgsdir}/${cope}.dtseries.nii -reduce MEAN -roi ${CombinedMasksdir}/SUM_AvBOLD_R.dscalar.nii>> ${logfile_SumR}

wb_command -cifti-stats ${betaimgsdir}/${cope}.dtseries.nii -reduce MEAN -roi ${CombinedMasksdir}/SUM_ALLNetsin1_AvBOLD_RL.dscalar.nii >> ${logfile_ALLNetsin1_SumRL}
wb_command -cifti-stats ${betaimgsdir}/${cope}.dtseries.nii -reduce MEAN -roi ${CombinedMasksdir}/SUM_ALLNetsin1_AvBOLD_L.dscalar.nii>> ${logfile_ALLNetsin1_SumL}
wb_command -cifti-stats ${betaimgsdir}/${cope}.dtseries.nii -reduce MEAN -roi ${CombinedMasksdir}/SUM_ALLNetsin1_AvBOLD_R.dscalar.nii>> ${logfile_ALLNetsin1_SumR}

done
echo "finished"


