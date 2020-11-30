library(lme4)

setwd("/ifs/faculty/narr/schizo/CONNECTOME/HCP_OUTPUT/Analysis_JL")

#1- load beahioral measures and Betas into R (Variables that change)################################################################################################

ClinicalData <- read.csv("Rtest/SubsInfo/behavioral4R_test_v1.csv",header=TRUE)
rownames(ClinicalData) <- ClinicalData$SubjID1

Subs4Analysis <- read.csv("Rtest/SubsInfo/Subs4Analysis.txt", header=FALSE)
SubswTP1_TP3 <- read.csv("Rtest/SubsInfo/SubswTP1_TP3.txt", header=FALSE)
colnames(Subs4Analysis) <- c("SubjID1")
colnames(SubswTP1_TP3) <- c("SubjID1")
PPIROI="SMN_V_VIR"
net="Somatomotor"
PPIROI=c("CON_VIR", "DAN_VIIbL", "FPN_VIIbL", "SMN_VIIIA_BR", "SMN_V_VIR")
task="carit"
cope="cope3"
Networks <- c("Default", "Frontoparietal", "Cingulo-Opercular", "Dorsal-attention","Somatomotor")
#ROIsSOM_R=c("HIPPOCAMPUS_RIGHT", "SOM-57 SOM-68", "SOM-77 SOM-74", "SOM-57", "SOM-59")
#ROIsSOM_L=c("SOM-87", "SOM-86 SOM-79", "SOM-88", "SOM-78", "SOM-93", "SOM-78", "SOM-80")
#ROIsALLnetworks <- c("HIPPOCAMPUS_RIGHT", "SOM-57", "SOM-68", "SOM-77", "SOM-74", "SOM_57", "SOM-59")
#ROIsALLnetworks <- c("Default", "Frontoparietal", "Cingulo-Opercular", "Dorsal-attention","Somatomotor")
ROIsALLnetworks <- c("RL")
#Hemi<-c("R")
#Hemi=c("RL")

ClinicalData4Analysis <- ClinicalData[ClinicalData$SubjID1 %in% Subs4Analysis$SubjID1,]

Table1_BehavioralValues <- data.frame(ClinicalData4Analysis$SubjID2,ClinicalData4Analysis$Timepoint,ClinicalData4Analysis$Diagnose_Group,ClinicalData4Analysis$cont_age, ClinicalData4Analysis$demog_gender,ClinicalData4Analysis$hamd3_suicide_bin, ClinicalData4Analysis$hamd8_retardation, ClinicalData4Analysis$hamd9_agitation, ClinicalData4Analysis$hamd_total, ClinicalData4Analysis$dass_anxiety_total, ClinicalData4Analysis$Rumination_state, ClinicalData4Analysis$shaps_sum, ClinicalData4Analysis$aes_score)
colnames(Table1_BehavioralValues) <- c("SubjID2", "Timepoint","Diagnose_Group", "Age", "gender", "hamd3_suicide_bin","hamd8_retardation","hamd9_agitation","hamd_total","DASS","Rumination_state","SHAPS","AES")

Table1_BehavioralValues_TP123<-subset(Table1_BehavioralValues[Table1_BehavioralValues$Timepoint!=4,])

write.csv(Table1_BehavioralValues,paste("Rtest/stats/Table1_BehavioralValues.csv",sep=""))
write.csv(Table1_BehavioralValues_TP123,paste("Rtest/stats/Table1_BehavioralValues_TP123.csv",sep=""))

#2 - Create R tables for all the stats#################################################################################################################################
p_table=list()
p_table_roi=list()
Table6_ALLVariables_ALLnets<-list()
for (roi in 1:length(PPIROI)) {
  for (net in 1:length(Networks)) {
    Betas <- read.delim(paste("Rtest/Betas/SUM_AvNoGoGo_",PPIROI[roi],"_AvBOLD_",Networks[net],"_RL.txt",sep=""), header=FALSE)
    colnames(Betas) <- ROIsALLnetworks
    #drops <- c("Default")
    #Betas<-Betas[ , !(names(Betas) %in% drops)]
    Table2_Betas <- data.frame(ClinicalData4Analysis$SubjID1, ClinicalData4Analysis$SubjID2,ClinicalData4Analysis$Timepoint,ClinicalData4Analysis$Diagnose_Group,ClinicalData4Analysis$cont_age, ClinicalData4Analysis$demog_gender, ClinicalData4Analysis$hamd17_suicide.Consult_bin, ClinicalData4Analysis$Response, ClinicalData4Analysis$Remission)
    colnames(Table2_Betas) <- c("SubjID1", "SubjID2", "Timepoint","Diagnose_Group", "Age", "gender","HAMD_suicideConsult_bin", "Response", "Remission")
    Table2_Betas<-cbind2(Table2_Betas, Betas)
    Table2_Betas<-data.frame(Table2_Betas)

    Table2_Betas_TP123_noHC<-subset(Table2_Betas[Table2_Betas$Diagnose_Group==1 & Table2_Betas$Timepoint!=4,])
    Table2_Betas_TP123<-subset(Table2_Betas[Table2_Betas$Timepoint!=4,])

    for (sub in 1:length(Table2_Betas_TP123_noHC$SubjID2)){
      if(!is.na(Table2_Betas_TP123_noHC$Response[sub])) {
        Table2_Betas_TP123_noHC$HAMD_suicideConsult_bin[Table2_Betas_TP123_noHC$SubjID2==Table2_Betas_TP123_noHC$SubjID2[sub]] = Table2_Betas_TP123_noHC$HAMD_suicideConsult_bin[Table2_Betas_TP123_noHC$SubjID1==paste(Table2_Betas_TP123_noHC$SubjID2[sub],"01",sep="")]
        Table2_Betas_TP123$HAMD_suicideConsult_bin[Table2_Betas_TP123$SubjID2==Table2_Betas_TP123$SubjID2[sub]] = Table2_Betas_TP123$HAMD_suicideConsult_bin[Table2_Betas_TP123$SubjID1==paste(Table2_Betas_TP123$SubjID2[sub],"01",sep="")]
  
        Table2_Betas_TP123_noHC$Response[Table2_Betas_TP123_noHC$SubjID2==Table2_Betas_TP123_noHC$SubjID2[sub]] = Table2_Betas_TP123_noHC$Response[Table2_Betas_TP123_noHC$SubjID1==paste(Table2_Betas_TP123_noHC$SubjID2[sub],"01",sep="")]
        Table2_Betas_TP123$Response[Table2_Betas_TP123$SubjID2==Table2_Betas_TP123$SubjID2[sub]] = Table2_Betas_TP123$Response[Table2_Betas_TP123$SubjID1==paste(Table2_Betas_TP123$SubjID2[sub],"01",sep="")]
  
        Table2_Betas_TP123_noHC$Remission[Table2_Betas_TP123_noHC$SubjID2==Table2_Betas_TP123_noHC$SubjID2[sub]] = Table2_Betas_TP123_noHC$Remission[Table2_Betas_TP123_noHC$SubjID1==paste(Table2_Betas_TP123_noHC$SubjID2[sub],"01",sep="")]
        Table2_Betas_TP123$Remission[Table2_Betas_TP123$SubjID2==Table2_Betas_TP123$SubjID2[sub]] = Table2_Betas_TP123$Remission[Table2_Betas_TP123$SubjID1==paste(Table2_Betas_TP123$SubjID2[sub],"01",sep="")]
    
        Table2_Betas_TP123_noHC$Age[Table2_Betas_TP123_noHC$SubjID2==Table2_Betas_TP123_noHC$SubjID2[sub]] = Table2_Betas_TP123_noHC$Age[Table2_Betas_TP123_noHC$SubjID1==paste(Table2_Betas_TP123_noHC$SubjID2[sub],"01",sep="")]
        Table2_Betas_TP123$Age[Table2_Betas_TP123$SubjID2==Table2_Betas_TP123$SubjID2[sub]] = Table2_Betas_TP123$Age[Table2_Betas_TP123$SubjID1==paste(Table2_Betas_TP123$SubjID2[sub],"01",sep="")]
  
        Table2_Betas_TP123_noHC$gender[Table2_Betas_TP123_noHC$SubjID2==Table2_Betas_TP123_noHC$SubjID2[sub]] = Table2_Betas_TP123_noHC$gender[Table2_Betas_TP123_noHC$SubjID1==paste(Table2_Betas_TP123_noHC$SubjID2[sub],"01",sep="")]
        Table2_Betas_TP123$gender[Table2_Betas_TP123$SubjID2==Table2_Betas_TP123$SubjID2[sub]] = Table2_Betas_TP123$gender[Table2_Betas_TP123$SubjID1==paste(Table2_Betas_TP123$SubjID2[sub],"01",sep="")]
  
      }
    }
    Table2_Betas_TP123_noHC_noNA<-Table2_Betas_TP123_noHC[complete.cases(Table2_Betas_TP123_noHC), ]
    Table2_Betas_TP123_noNA<-Table2_Betas_TP123[complete.cases(Table2_Betas_TP123), ]

    write.csv(Table2_Betas,paste("Rtest/stats/Table2_Betas_",PPIROI[roi],"_RL.csv",sep=""))
    write.csv(Table2_Betas_TP123_noHC,paste("Rtest/stats/Table2_Betas_TP123_noHC_",PPIROI[roi],"_RL.csv",sep=""))
    write.csv(Table2_Betas_TP123_noHC_noNA,paste("Rtest/stats/Table2_Betas_TP123_noHC_noNA_",PPIROI[roi],"_RL.csv",sep=""))
    write.csv(Table2_Betas_TP123,paste("Rtest/stats/Table2_Betas_TP123_",PPIROI[roi],"_RL.csv",sep=""))
    write.csv(Table2_Betas_TP123_noNA,paste("Rtest/stats/Table2_Betas_TP123_noNA_",PPIROI[roi],"_RL.csv",sep=""))

    ClinicalData_SubswTP1_TP3 <- ClinicalData[ClinicalData$SubjID1 %in% SubswTP1_TP3$SubjID1,]
    SubswTP1_TP3$SubjID2 <- ClinicalData_SubswTP1_TP3$SubjID2
    SubsIDnoTP<-subset(ClinicalData_SubswTP1_TP3[(ClinicalData_SubswTP1_TP3$Timepoint==1 & ClinicalData_SubswTP1_TP3$Diagnose_Group==1),])
    SubsIDnoTP<-SubsIDnoTP[Table2_Betas$SubjID2 %in% SubsIDnoTP$SubjID2,] 
    drops <- c("education","duration_current_episode","duration_lifetime._illness")
    SubsIDnoTP<-SubsIDnoTP[ , !(names(SubsIDnoTP) %in% drops)]
    SubsIDnoTP<-SubsIDnoTP[complete.cases(SubsIDnoTP), ]
    BetasChange<-list()
    for (sub in 1:dim(SubsIDnoTP)[1]) {
      tmp1<-Table2_Betas[Table2_Betas$SubjID1==paste(SubsIDnoTP$SubjID2[sub],"01",sep=""),]
      tmp1 <- tmp1[,10:dim(tmp1)[2]]
      tmp3<-Table2_Betas[Table2_Betas$SubjID1==paste(SubsIDnoTP$SubjID2[sub],"03",sep=""),]
      tmp3 <- tmp3[,10:dim(tmp3)[2]]
      BetasChange <- rbind(BetasChange,tmp1-tmp3)
    }
    Table3_ChangeValues <- data.frame(SubsIDnoTP$SubjID2, SubsIDnoTP$cont_age, SubsIDnoTP$demog_gender,SubsIDnoTP$Response, SubsIDnoTP$Remission, SubsIDnoTP$hamd17_suicide.Consult_bin, SubsIDnoTP$hamd_suicide_bin_change, SubsIDnoTP$X.hamd_total.change, SubsIDnoTP$X.dass_anxiety_total.change, SubsIDnoTP$X.shaps_sum.change, SubsIDnoTP$X.aes_score.change, SubsIDnoTP$X.Rumination_state_change)
    colnames(Table3_ChangeValues) <- c("SubjID2", "Age", "gender", "Response", "Remission", "Suicide_consult", "Suicidechange", "%HAMDchange","%DASSchange", "%shapschange", "%aeschange", "%Rumination_state_change")
    Table3_ChangeValues <- cbind2(Table3_ChangeValues, BetasChange)
    write.csv(Table3_ChangeValues,paste("Rtest/stats/Table3_ChangeValues_",PPIROI[roi],"_RL".csv",sep=""))

    ##Prelim Statistics!! Target is LMM###########################################################################
    prelim_stats <- list()
    prelim_ps <- list()
    betas_means <- list()
    betas_means <- list()
    for (i in 1:dim(Betas)[2]) {
      currdata <- data.frame(Table2_Betas$SubjID2,Table2_Betas$Timepoint,Table2_Betas$Diagnose_Group,Table2_Betas$Response,Table2_Betas$Remission, Table2_Betas$HAMD_suicideConsult_bin, Betas[,i])
      colnames(currdata) <- c("subjid","timepoint","diagnosis","response", "remission", "SuicideConsult","betas")
      currdata <- currdata[currdata$diagnosis==1,] #exclude nondepressed controls
      # currdata <- currdata[currdata$timepoint!=2,] #can exclude timepoints if desired
      currdata <- currdata[currdata$timepoint!=4,]
      stat <- lmer(betas ~ as.numeric(timepoint) + (1|subjid), currdata, REML=FALSE)
      null <- lmer(betas ~ (1|subjid), currdata, REML=FALSE)
      aovm <- anova(stat,null)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
      prelim_stats[[i]] <- aovm$Chisq[2]
      prelim_ps[[i]] <- aovm$`Pr(>Chisq)`[2]
      betas_means[[i]] <- c(mean(currdata$betas[currdata$timepoint==1]),mean(currdata$betas[currdata$timepoint==2]),mean(currdata$betas[currdata$timepoint==3]),mean(currdata$betas[currdata$timepoint==4]) )
    }
    #output prelim p values at console################################################################################

    DVnames<-colnames(Betas)
    yo <- unlist(prelim_ps)
    DVnames[which(yo<0.05)] #FCZ-pair names for all uncorrected p values < 0.05
    yo[which(yo<0.05)] 
    betas_means[which(yo<0.05)]
    yoyo <- p.adjust(yo,method="fdr")
    yoyo[which(yoyo<0.05)] #all fdr-corrected p values < 0.05

    #write out prelim p values to csv file
    temp_p_out <- data.frame(yo,yoyo)
    colnames(temp_p_out) <- c("p_uncorr","p_fdr")
    rownames(temp_p_out) <- DVnames
    p_table[[h]]<-temp_p_out

    #write.csv(temp_p_out,paste(rt,"Routput_node2node_181018_FCz_ANOVA-t1t2t3factor_withthal.csv",sep=""))
  }
  p_table_roi[[roi]]<- p_table
  
  
  #Generate Table with everything for each ROI##################################################################
  
  R_betas_tmp<-read.csv(paste("Rtest/stats/Table2_Betas_TP123_",PPIROI[roi],"_R",".csv",sep=""),header=TRUE)
  R_change_tmp<-read.csv(paste("Rtest/stats/Table3_ChangeValues_",PPIROI[roi],"_R",".csv",sep=""),header=TRUE)
  l<-1:dim(R_betas_tmp)[1]
  Hemmisphere<-rep("R",length(l))
  R_tmp<-cbind.fill(Table1_BehavioralValues_TP123,cbind(R_betas_tmp$HAMD_suicideConsult_bin, R_betas_tmp$Response, R_betas_tmp$Remission), cbind(R_change_tmp$X.HAMDchange, R_change_tmp$X.DASSchange, R_change_tmp$X.Rumination_state_change, R_change_tmp$X.shapschange, R_change_tmp$X.aeschange),Hemmisphere, cbind(R_betas_tmp$Frontoparietal, R_betas_tmp$Cingulo.Opercular, R_betas_tmp$Dorsal.attention, R_betas_tmp$Somatomotor), cbind(R_change_tmp$Frontoparietal, R_change_tmp$Cingulo.Opercular, R_change_tmp$Dorsal.attention, R_change_tmp$Somatomotor),fill="NULL")
  colnames(R_tmp) <- c("SubjID2", "Timepoint","Diagnose_Group", "Age", "gender", "hamd3_suicide_bin","hamd8_retardation","hamd9_agitation","hamd_total","DASS","Rumination_state","SHAPS","AES","hamd_cuicide_consult_bin","Response","Remission","HAMDchange","DASSchange","Ruminationchange","SHAPSchange","AESchange","Hemi","FPN","CON","DAN","SMN","FPNchange","CONchange","DANchange","SMNchange")
  
  L_betas_tmp<-read.csv(paste("Rtest/stats/Table2_Betas_TP123_",PPIROI[roi],"_L",".csv",sep=""),header=TRUE)
  L_change_tmp<-read.csv(paste("Rtest/stats/Table3_ChangeValues_",PPIROI[roi],"_L",".csv",sep=""),header=TRUE)
  l<-1:dim(L_betas_tmp)[1]
  Hemmisphere<-rep("L",length(l))
  L_tmp<-cbind.fill(Table1_BehavioralValues_TP123,cbind(L_betas_tmp$HAMD_suicideConsult_bin, L_betas_tmp$Response, L_betas_tmp$Remission), cbind(L_change_tmp$X.HAMDchange, L_change_tmp$X.DASSchange, L_change_tmp$X.Rumination_state_change, L_change_tmp$X.shapschange, L_change_tmp$X.aeschange),Hemmisphere, cbind(L_betas_tmp$Frontoparietal, L_betas_tmp$Cingulo.Opercular, L_betas_tmp$Dorsal.attention, L_betas_tmp$Somatomotor), cbind(L_change_tmp$Frontoparietal, L_change_tmp$Cingulo.Opercular, L_change_tmp$Dorsal.attention, L_change_tmp$Somatomotor),fill="NULL")
  colnames(L_tmp) <- c("SubjID2", "Timepoint","Diagnose_Group", "Age", "gender", "hamd3_suicide_bin","hamd8_retardation","hamd9_agitation","hamd_total","DASS","Rumination_state","SHAPS","AES","hamd_cuicide_consult_bin","Response","Remission","HAMDchange","DASSchange","Ruminationchange","SHAPSchange","AESchange","Hemi","FPN","CON","DAN","SMN","FPNchange","CONchange","DANchange","SMNchange")
  
  Table4_ALLVariables<-rbind(R_tmp,L_tmp)
  
  l<-1:dim(Table4_ALLVariables)[1]
  Network<-rep(PPIROI[roi],length(l))
  Table5_ALLVariables_wnet<-cbind(Table4_ALLVariables,Network)
  Table6_ALLVariables_ALLnets<-rbind(Table6_ALLVariables_ALLnets,Table5_ALLVariables_wnet)
  write.csv(Table4_ALLVariables,paste("Rtest/stats/Table4_ALLVariables_RL_",PPIROI[roi],".csv",sep=""))
  write.csv(Table5_ALLVariables_wnet,paste("Rtest/stats/Table4_ALLVariables_RL_",PPIROI[roi],"_",roi,".csv",sep=""))
}
write.csv(Table6_ALLVariables_ALLnets,paste("Rtest/stats/Table6_ALLVariables_ALLnets.csv",sep=""))
write.csv(p_table_roi, paste("Rtest/stats/p_table_hemi_roi.csv",sep=""))