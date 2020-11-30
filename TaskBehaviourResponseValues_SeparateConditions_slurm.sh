#!/bin/bash 

logsmaindir="/nafs/narr/HCP_OUTPUT"
maindir="/nafs/narr/jloureiro"

#FSLDIR="/usr/local/fsl-5.0.9"
#HCPPIPEDIR="${maindir}/scripts/Pipelines-3.22.0"
#CARET7DIR="/usr/local/workbench-1.2.3/bin_rh_linux64"

#source ${EnvironmentScript}
#export PATH=/usr/local/workbench-1.3.2/bin_rh_linux64:$PATH 

listname="Paper2"
#listname=""
subjlist=$(<${maindir}/logstxt/Subs4ROIAnalysis_paper.txt)
#echo "$subjlist" 	

for sub in ${subjlist}
do
#paste ${sub} >> subs
#to visualize csv files in linux:
#column -s, -t < ${logsmaindir}/psychopy_output/${sub}/${sub}_Scanner_ABCD_AB_FaceMatching_2017_Jun_05_0912.csv  | less -#2 -N -S

logfile=`find ${logsmaindir}/psychopy_output/${sub} -type f -name "*_Scanner_ABCD_AB_FaceMatching*.csv"`

if [ -e "${logsmaindir}/psychopy_output/${sub}/Happy_rt_${sub}.txt" ]
then 
	rm ${logsmaindir}/psychopy_output/${sub}/Happy_rt_${sub}.txt
	rm ${logsmaindir}/psychopy_output/${sub}/Fearful_rt_${sub}.txt
	rm ${logsmaindir}/psychopy_output/${sub}/Neutral_rt_${sub}.txt
	rm ${logsmaindir}/psychopy_output/${sub}/Objects_rt_${sub}.txt
fi
	awk '/Happy/ {print}' ${logfile} > ${logsmaindir}/psychopy_output/${sub}/Happy_rt_${sub}.txt
	awk '/Fearful/ {print}' ${logfile} > ${logsmaindir}/psychopy_output/${sub}/Fearful_rt_${sub}.txt
	awk '/Neutral/ {print}' ${logfile} > ${logsmaindir}/psychopy_output/${sub}/Neutral_rt_${sub}.txt
	awk '/Object/ {print}' ${logfile} > ${logsmaindir}/psychopy_output/${sub}/Objects_rt_${sub}.txt


#Reaction times are in column 21 of the csv file (key_resp_trial.rt) 
#ReactionTimes=`awk -F "\"*,\"*" '{print $18}' ${logfile}`

if [ -e "${logsmaindir}/psychopy_output/${sub}/Happy_rt_${sub}.txt >> ${maindir}/logstxt/tfmri_responses/${listname}_av_rt_Happy.txt" ]
then
	rm ${logsmaindir}/psychopy_output/${sub}/Happy_rt_${sub}.txt >> ${maindir}/logstxt/tfmri_responses/${listname}_*
fi
	awk -F',' 'NR > 1 {sum+=$18} END {print sum / (NR - 1)}' ${logsmaindir}/psychopy_output/${sub}/Happy_rt_${sub}.txt >> ${maindir}/logstxt/tfmri_responses/${listname}_av_rt_Happy.txt
	awk -F',' 'NR > 1 {sum+=$18} END {print sum / (NR - 1)}' ${logsmaindir}/psychopy_output/${sub}/Fearful_rt_${sub}.txt >> ${maindir}/logstxt/tfmri_responses/${listname}_av_rt_Fearful.txt
	awk -F',' 'NR > 1 {sum+=$18} END {print sum / (NR - 1)}' ${logsmaindir}/psychopy_output/${sub}/Neutral_rt_${sub}.txt >> ${maindir}/logstxt/tfmri_responses/${listname}_av_rt_Neutral.txt
	awk -F',' 'NR > 1 {sum+=$18} END {print sum / (NR - 1)}' ${logsmaindir}/psychopy_output/${sub}/Objects_rt_${sub}.txt >> ${maindir}/logstxt/tfmri_responses/${listname}_av_rt_Objects.txt


#nr. keys pressed correctly (key_resp_trial.corr)
#awk -F "\"*,\"*" '{print $17}' ${logfile} | grep -o '1' | wc -l |

done

av_rt_Happy=$(<${maindir}/logstxt/tfmri_responses/${listname}_av_rt_Happy.txt)
av_rt_Fearful=$(<${maindir}/logstxt/tfmri_responses/${listname}_av_rt_Fearful.txt)
av_rt_Neutral=$(<${maindir}/logstxt/tfmri_responses/${listname}_av_rt_Neutral.txt)
av_rt_Objects=$(<${maindir}/logstxt/tfmri_responses/${listname}_av_rt_Objects.txt)

if [ -e "${maindir}/logstxt/tfmri_responses/${listname}_av_rt_Happy.txt" ] 
then 
	rm ${maindir}/logstxt/tfmri_responses/${listname}_av_rt_*
fi
	paste <(echo "$subjlist") <(echo "$av_rt_Happy") --delimiters '\t'> ${maindir}/logstxt/tfmri_responses/${listname}_av_rt_Happy.txt
	paste <(echo "$subjlist") <(echo "$av_rt_Fearful") --delimiters '\t'> ${maindir}/logstxt/tfmri_responses/${listname}_av_rt_Fearful.txt
	paste <(echo "$subjlist") <(echo "$av_rt_Neutral") --delimiters '\t'> ${maindir}/logstxt/tfmri_responses/${listname}_av_rt_Neutral.txt
	paste <(echo "$subjlist") <(echo "$av_rt_Objects") --delimiters '\t'> ${maindir}/logstxt/tfmri_responses/${listname}_av_rt_Objects.txt



