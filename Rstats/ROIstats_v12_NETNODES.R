  library(lme4)
  
  setwd("/ifs/faculty/narr/schizo/CONNECTOME/HCP_OUTPUT/Analysis_JL")
  
  #1- load beahioral measures and Betas into R (Variables that change)################################################################################################
  
  ClinicalData <- read.csv("Rtest/SubsInfo/SubsClinicalData_MAIN.csv",header=TRUE)
  rownames(ClinicalData) <- ClinicalData$SubjID1
  
  Subs4Analysis <- read.csv("Rtest/SubsInfo/Subs4Analysis_3.txt", header=FALSE)
  Subs4AnalysisnoHC <- read.csv("Rtest/SubsInfo/Subs4Analysis_noHC_noTP4.txt", header=FALSE)
  SubswBetas <- read.csv("Rtest/SubsInfo/Subs4Analysis.txt", header=FALSE)
  SubswTP1_TP3 <- read.csv("Rtest/SubsInfo/SubswTP1_TP3.txt", header=FALSE)
  
  colnames(Subs4Analysis) <- c("SubjID1")
  colnames(SubswBetas) <- c("SubjID1")
  colnames(Subs4AnalysisnoHC) <- c("SubjID1")
  colnames(SubswTP1_TP3) <- c("SubjID1")
  PPIROIs<-c("DAN_VIIbL", "SMN_VIIIA_BR", "SMN_V_VIR")
  task="carit"
  cope="cope3"
  Networks <- c("Default", "Frontoparietal", "Cingulo-Opercular", "Dorsal-attention","Somatomotor")
  Networknames <- c("Default", "Frontoparietal", "Cingulo_Opercular", "Dorsal_attention","Somatomotor")
  Hemi<-c("R", "L")
  
  ROIs_Default_R<-c("HIPPOCAMPUS_RIGHT","DMN.184", "DMN.185", "DMN.157", "DMN.158", "DMN.188")	
  ROIs_Default_L<-c("HIPPOCAMPUS_LEFT", "DMN.223", "DMN.224", "DMN.196", "DMN.194", "DMN.227")
  
  ROIs_Frontoparietal_R<-c("THALAMUS_RIGHT", "CAUDATE_RIGHT", "FPN.252", "FPN.248", "FPN.242", "FPN.243", "FPN.245")
  ROIs_Frontoparietal_L<-c("THALAMUS_LEFT", "CAUDATE_LEFT", "FPN.275", "FPN.271", "FPN.265", "FPN.264", "FPN.267")
  
  ROIs_Cingulo_Opercular_R<-c("PUTAMEN_RIGHT", "CON.123", "CON.116", "CON.117", "CON.125", "CON.107")
  ROIs_Cingulo_Opercular_L<-c("PUTAMEN_LEFT", "CON.148", "CON.142", "CON.144", "CON.150", "CON.133")
  
  ROIs_Dorsal_attention_R<-c("THALAMUS_RIGHT", "DAN.316", "DAN.314")
  ROIs_Dorsal_attention_L<-c("THALAMUS_LEFT","DAN.327", "DAN.325")
  
  ROIs_Somatomotor_R<-c("HIPPOCAMPUS_RIGHT", "THALAMUS_RIGHT", "SOM.67", "SOM.57", "SOM.72", "SOM.75")
  ROIs_Somatomotor_L<-c("HIPPOCAMPUS_LEFT", "SOM.87", "SOM.86", "SOM.79", "SOM.88", "SOM.78", "SOM.93", "SOM.95")
  
  #ClinicalData<-ClinicalData %>% select(1:10,12:14,16,20:25,29:46)
  ClinicalData<-ClinicalData %>% select(1:10,12:20,22:24,28:71)
  ClinicalData_4Analysis_noHC <- ClinicalData[ClinicalData$SubjID1 %in% Subs4AnalysisnoHC$SubjID1,]
  
  for (sub in 1:length(ClinicalData_4Analysis_noHC$SubjID2)){ 
    ClinicalData$hamd17_suicide.Consult_bin[ClinicalData$SubjID2==ClinicalData$SubjID2[sub]] = ClinicalData$hamd17_suicide.Consult_bin[ClinicalData$SubjID1==paste(ClinicalData$SubjID2[sub],"01",sep="")]
    ClinicalData$hamd_total_17.Consult[ClinicalData$SubjID2==ClinicalData$SubjID2[sub]] = ClinicalData$hamd_total_17.Consult[ClinicalData$SubjID1==paste(ClinicalData$SubjID2[sub],"01",sep="")]
    ClinicalData$hamd3_suicide_TP1_bin[ClinicalData$SubjID2==ClinicalData$SubjID2[sub]] = ClinicalData$hamd3_suicide_TP1_bin[ClinicalData$SubjID1==paste(ClinicalData$SubjID2[sub],"01",sep="")]
    ClinicalData$hamd_suicide_bin_change[ClinicalData$SubjID2==ClinicalData$SubjID2[sub]] = ClinicalData$hamd_suicide_bin_change[ClinicalData$SubjID1==paste(ClinicalData$SubjID2[sub],"01",sep="")]
    ClinicalData$Response..HDRS17.[ClinicalData$SubjID2==ClinicalData$SubjID2[sub]] = ClinicalData$Response..HDRS17.[ClinicalData$SubjID1==paste(ClinicalData$SubjID2[sub],"01",sep="")]
    ClinicalData$Remission..HDRS17.[ClinicalData$SubjID2==ClinicalData$SubjID2[sub]] = ClinicalData$Remission..HDRS17.[ClinicalData$SubjID1==paste(ClinicalData$SubjID2[sub],"01",sep="")]
    ClinicalData$Response..HDRS6.[ClinicalData$SubjID2==ClinicalData$SubjID2[sub]] = ClinicalData$Response..HDRS6.[ClinicalData$SubjID1==paste(ClinicalData$SubjID2[sub],"01",sep="")]
    ClinicalData$Remission..HDRS6.[ClinicalData$SubjID2==ClinicalData$SubjID2[sub]] = ClinicalData$Remission..HDRS6.[ClinicalData$SubjID1==paste(ClinicalData$SubjID2[sub],"01",sep="")]
    ClinicalData$Response..QIDS.[ClinicalData$SubjID2==ClinicalData$SubjID2[sub]] = ClinicalData$Response..QIDS.[ClinicalData$SubjID1==paste(ClinicalData$SubjID2[sub],"01",sep="")]
    ClinicalData$Remission..QIDS.[ClinicalData$SubjID2==ClinicalData$SubjID2[sub]] = ClinicalData$Remission..QIDS.[ClinicalData$SubjID1==paste(ClinicalData$SubjID2[sub],"01",sep="")]
    
    ClinicalData$cont_age[ClinicalData$SubjID2==ClinicalData$SubjID2[sub]] = ClinicalData$cont_age[ClinicalData$SubjID1==paste(ClinicalData$SubjID2[sub],"01",sep="")]
    ClinicalData$demog_gender[ClinicalData$SubjID2==ClinicalData$SubjID2[sub]] = ClinicalData$demog_gender[ClinicalData$SubjID1==paste(ClinicalData$SubjID2[sub],"01",sep="")]
    ClinicalData$education[ClinicalData$SubjID2==ClinicalData$SubjID2[sub]] = ClinicalData$education[ClinicalData$SubjID1==paste(ClinicalData$SubjID2[sub],"01",sep="")]
    ClinicalData$duration_current_episode[ClinicalData$SubjID2==ClinicalData$SubjID2[sub]] = ClinicalData$duration_current_episode[ClinicalData$SubjID1==paste(ClinicalData$SubjID2[sub],"01",sep="")]
    ClinicalData$duration_lifetime._illness[ClinicalData$SubjID2==ClinicalData$SubjID2[sub]] = ClinicalData$duration_lifetime._illness[ClinicalData$SubjID1==paste(ClinicalData$SubjID2[sub],"01",sep="")]
    ClinicalData$X.hamd_total.change[ClinicalData$SubjID2==ClinicalData$SubjID2[sub]] = ClinicalData$X.hamd_total.change[ClinicalData$SubjID1==paste(ClinicalData$SubjID2[sub],"01",sep="")]
    ClinicalData$X.QIDSchange[ClinicalData$SubjID2==ClinicalData$SubjID2[sub]] = ClinicalData$X.QIDSchange[ClinicalData$SubjID1==paste(ClinicalData$SubjID2[sub],"01",sep="")]
    ClinicalData$X.HDRS6[ClinicalData$SubjID2==ClinicalData$SubjID2[sub]] = ClinicalData$X.HDRS6[ClinicalData$SubjID1==paste(ClinicalData$SubjID2[sub],"01",sep="")]
    
    ClinicalData$SI_HDRS.QIDS_TP1[ClinicalData$SubjID2==ClinicalData$SubjID2[sub]] = ClinicalData$SI_HDRS.QIDS_TP1[ClinicalData$SubjID1==paste(ClinicalData$SubjID2[sub],"01",sep="")]
    ClinicalData$SI_HDRS.QIDS.IDSC_TP1[ClinicalData$SubjID2==ClinicalData$SubjID2[sub]] = ClinicalData$SI_HDRS.QIDS.IDSC_TP1[ClinicalData$SubjID1==paste(ClinicalData$SubjID2[sub],"01",sep="")]
    ClinicalData$SI_HDRS.QIDS_change[ClinicalData$SubjID2==ClinicalData$SubjID2[sub]] = ClinicalData$SI_HDRS.QIDS_change[ClinicalData$SubjID1==paste(ClinicalData$SubjID2[sub],"01",sep="")]
    ClinicalData$SI_HDRS.QIDS.IDSC_TP1_change[ClinicalData$SubjID2==ClinicalData$SubjID2[sub]] = ClinicalData$SI_HDRS.QIDS.IDSC_TP1_change[ClinicalData$SubjID1==paste(ClinicalData$SubjID2[sub],"01",sep="")]
    ClinicalData$SI_HDRS.QIDS.IDSC_TP1_percentChange[ClinicalData$SubjID2==ClinicalData$SubjID2[sub]] = ClinicalData$SI_HDRS.QIDS.IDSC_TP1_percentChange[ClinicalData$SubjID1==paste(ClinicalData$SubjID2[sub],"01",sep="")]
    ClinicalData$SI_HDRS.QIDS_percentChange[ClinicalData$SubjID2==ClinicalData$SubjID2[sub]] = ClinicalData$SI_HDRS.QIDS_percentChange[ClinicalData$SubjID1==paste(ClinicalData$SubjID2[sub],"01",sep="")]
    
    
    
  }
  
  ClinicalData_4Analysis <- ClinicalData[ClinicalData$SubjID1 %in% Subs4Analysis$SubjID1,]
  ClinicalData_4Analysis_matchBetaSubs <- ClinicalData_4Analysis[ClinicalData_4Analysis$SubjID1 %in% SubswBetas$SubjID1,]
  
  #2 - Create R tables for all the stats#################################################################################################################################
  p_table=list()
  p_table_roi=list()
  p_table_net_roi=c()
  p_table_net=c()
  
  Table3_Long<-data.frame()
  #Table1_ClinicalData_4Analysis_wBetas<-data.frame(matrix(nrow=152*3, ncol=0))
  #Table2_ClinicalData_4Analysis_wBetaschange<-data.frame(matrix(nrow=28*3, ncol=0))
  Table1_ClinicalData_4Analysis_wBetas<-data.frame()
  Table2_ClinicalData_4Analysis_wBetaschange<-data.frame()
  for (roi in 1:length(PPIROIs)) {
    
    Table1_ClinicalData_4Analysis_wBetas_tmp1<-data.frame(matrix(nrow=152, ncol=0))
    Table2_ClinicalData_4Analysis_wBetaschange_tmp1<-data.frame(matrix(nrow=28, ncol=0))
    Table1_ClinicalData_4Analysis_wBetas_tmp2<-data.frame(matrix(nrow=152, ncol=0))
    Table2_ClinicalData_4Analysis_wBetaschange_tmp2<-data.frame(matrix(nrow=28, ncol=0))
    
    for (net in 1:length(Networks)) {
      for (h in 1:length(Hemi)) {
        
      ROInames<-eval(parse(text=paste("ROIs","_",Networknames[net],"_",Hemi[h],sep="")))
      Betas <- read.delim(paste("Rtest/Betas/MERGEDROIs_AvNoGoGo_",PPIROIs[roi],"_AvBOLD_",Networks[net],"_",Hemi[h],".txt",sep=""), header=FALSE)
      colnames(Betas) <- ROInames
      Betas <- cbind(SubswBetas, Betas)
      Betas_4Analysis <- Betas[Betas$SubjID1 %in% Subs4Analysis$SubjID1,]
      rownames( Betas_4Analysis) <- Betas_4Analysis$SubjID1
      ClinicalData_4Analysis_wBetas<-cbind2(ClinicalData_4Analysis_matchBetaSubs,Betas_4Analysis %>% select(2:dim(Betas)[2]))
      
      ClinicalData_SubswTP1_TP3 <- ClinicalData[ClinicalData$SubjID1 %in% SubswTP1_TP3$SubjID1,]
      SubswTP1_TP3$SubjID2 <- ClinicalData_SubswTP1_TP3$SubjID2
      SubsIDnoTP<-subset(ClinicalData_SubswTP1_TP3[(ClinicalData_SubswTP1_TP3$Timepoint==1 & ClinicalData_SubswTP1_TP3$Diagnose_Group==1),])
      SubsIDnoTP<-SubsIDnoTP[ClinicalData_4Analysis_wBetas$SubjID2 %in% SubsIDnoTP$SubjID2,] 
      SubsIDnoTP<-SubsIDnoTP[complete.cases(SubsIDnoTP), ]
      BetasChange<-c()
      for (sub in 1:dim(SubsIDnoTP)[1]) {
        tmp1<-ClinicalData_4Analysis_wBetas[ClinicalData_4Analysis_wBetas$SubjID1==paste(SubsIDnoTP$SubjID2[sub],"01",sep=""),]
        tmp1 <- tmp1[,67:dim(tmp1)[2]]
        tmp3<-ClinicalData_4Analysis_wBetas[ClinicalData_4Analysis_wBetas$SubjID1==paste(SubsIDnoTP$SubjID2[sub],"03",sep=""),]
        tmp3 <- tmp3[,67:dim(tmp3)[2]]
        BetasChange <- rbind(BetasChange,as.numeric(tmp1)-as.numeric(tmp3))
      }
      
      rownames(BetasChange) <- SubsIDnoTP$SubjID1
      nodeschange<-paste(ROInames, "change", sep="")
      colnames(BetasChange)<- c(nodeschange)
      
      ClinicalData_4Analysis_matchBetaSubs <- data.frame(ClinicalData_4Analysis_matchBetaSubs)
      Betas_4Analysis <- data.frame(Betas_4Analysis)
      ClinicalData_4Analysis_4Betaschange <- ClinicalData_4Analysis[ClinicalData_4Analysis$SubjID1 %in% SubsIDnoTP$SubjID1,]
      Betas_TP1 <- Betas[Betas$SubjID1 %in% SubsIDnoTP$SubjID1,]
      
      l1<-1:dim(ClinicalData_4Analysis_matchBetaSubs)[1]
      Hemcol1<-rep(Hemi[h],length(l1))
      SeedROI1<-rep(PPIROIs[roi],length(l1))
      SeedROIcode1<-rep(roi,length(l1))
      Netcol1<-rep(Networks[net],length(l1))
      Netcode1<-rep(net,length(l1))
      
      l2<-1:dim(ClinicalData_4Analysis_4Betaschange)[1]
      Hemcol2<-rep(Hemi[h],length(l2))
      SeedROI2<-rep(PPIROIs[roi],length(l2))
      SeedROIcode2<-rep(roi,length(l2))
      Netcol2<-rep(Networks[net],length(l2))
      Netcode2<-rep(net,length(l2))
      
      ClinicalData_4Analysis_tmp1<-cbind(ClinicalData_4Analysis_matchBetaSubs,SeedROI1,SeedROIcode1)
      #Table1_ClinicalData_4Analysis_wBetas_tmp1<-cbind(Table1_ClinicalData_4Analysis_wBetas_tmp1,Betas_4Analysis[2:dim(Betas)[2]])
      Table2_ClinicalData_4Analysis_wBetaschange_tmp1<-cbind(Table2_ClinicalData_4Analysis_wBetaschange_tmp1,Betas_TP1[2:dim(Betas)[2]],BetasChange)
      
      ClinicalData_4Analysis_tmp<-cbind(ClinicalData_4Analysis_matchBetaSubs,SeedROI1,SeedROIcode1,Hemcol1,Netcol1,Netcode1)
      Table1_ClinicalData_4Analysis_wBetas_tmp<-join(ClinicalData_4Analysis_tmp, Betas_4Analysis)
      Table2_ClinicalData_4Analysis_wBetaschange_tmp<-cbind(ClinicalData_4Analysis_4Betaschange, SeedROI2,SeedROIcode2,Hemcol2,Netcol2,Netcode2,Betas_TP1, BetasChange)
      
      
      for (i in 1:(dim(Betas)[2]-1)) {
        tmp<-data.frame()
        tmp1<-data.frame()
        Nodecol3<-rep(ROInames[i],length(l1))
        Nodecode3<-rep(i,length(l1))
        tmp1<- Table1_ClinicalData_4Analysis_wBetas_tmp %>% select(1:66)
        tmp<-cbind(tmp1, SeedROI1,SeedROIcode1,Hemcol1,Netcol1, Netcode1,Nodecol3,Nodecode3,Table1_ClinicalData_4Analysis_wBetas_tmp[71+i])
        colnames(tmp)<-c(colnames(Table1_ClinicalData_4Analysis_wBetas_tmp %>% select(1:66)),c("SeedROI","SeedROIcode","Hemi","Network","Networkcode","Node","Nodecode","Betas"))
        Table3_Long<-rbind(Table3_Long,tmp)
      }
      
      ##Prelim Statistics!! Target is LMM###########################################################################
      prelim_stats <- list()
      prelim_ps <- list()
      betas_means <- list()
      betas_means <- list()
      for (i in 1:(dim(Betas)[2]-1)) {
        currdata <- data.frame(ClinicalData_4Analysis_wBetas$SubjID2,ClinicalData_4Analysis_wBetas$Timepoint,ClinicalData_4Analysis_wBetas$Diagnose_Group,ClinicalData_4Analysis_wBetas$Response..HDRS17.,ClinicalData_4Analysis_wBetas$Remission..HDRS17., ClinicalData_4Analysis_wBetas$Response..HDRS6.,ClinicalData_4Analysis_wBetas$Remission..HDRS6.,ClinicalData_4Analysis_wBetas$Response..QIDS.,ClinicalData_4Analysis_wBetas$Remission..QIDS., ClinicalData_4Analysis_wBetas$hamd17_suicide.Consult_bin,ClinicalData_4Analysis_wBetas[,66+i])
        colnames(currdata) <- c("subjid","timepoint","diagnosis","response_HDRS17", "remission_HDRS17","response_HDRS6", "remission_HDRS6", "response_QIDS", "remission_QIDS", "SuicideConsult","betas")
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
      
      DVnames<-colnames(Betas %>% select(2:dim(Betas)[2]))
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
      
      
      
      }
      p_table_net[[net]]<- p_table
  }
    p_table_net_roi[[roi]]<- p_table_net
    
    Table1_ClinicalData_4Analysis_wBetas_tmp2<-cbind(ClinicalData_4Analysis_tmp1, Table1_ClinicalData_4Analysis_wBetas_tmp1)
    Table2_ClinicalData_4Analysis_wBetaschange_tmp2<-cbind(ClinicalData_4Analysis_4Betaschange,SeedROI2, SeedROIcode2,Table2_ClinicalData_4Analysis_wBetaschange_tmp1)
    
    Table1_ClinicalData_4Analysis_wBetas<-rbind.data.frame(Table1_ClinicalData_4Analysis_wBetas,Table1_ClinicalData_4Analysis_wBetas_tmp2)
    Table2_ClinicalData_4Analysis_wBetaschange<-rbind.data.frame(Table2_ClinicalData_4Analysis_wBetaschange,Table2_ClinicalData_4Analysis_wBetaschange_tmp2)
    
  }
  
  #write.csv(Table1_ClinicalData_4Analysis_wBetas,paste("Rtest/stats/Table1_Seed2Nodes_Betas_wide.csv",sep=""))
  write.csv(Table2_ClinicalData_4Analysis_wBetaschange,paste("Rtest/stats/Table2_Seed2Nodes_BetasChange_wide.csv",sep=""))
  write.csv(Table3_Long,paste("Rtest/stats/Table3_Seed2Nodes_Betas_Long.csv",sep=""))
  write.csv(p_table_roi, paste("Rtest/stats/p_table_hemi_roi.csv",sep=""))