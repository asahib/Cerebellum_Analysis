
# Library
library(fmsb)

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

#PPIROI<-c("DAN_VIIbL", "SMN_VIIIA_BR", "SMN_V_VIR")
PPIROI<-c("SMN_V_VIR")
task="carit"
cope="cope3"
Networks <- c("Default", "Frontoparietal", "Cingulo-Opercular", "Dorsal-attention","Somatomotor")

for (roi in 1:length(PPIROI)) {
    
    Betas <- read.delim(paste("Rtest/Betas/SUM_AvNoGoGo_",PPIROI[roi],"_RL.txt",sep=""), header=FALSE)
    colnames(Betas) <- Networks
    Betas <- cbind(SubswBetas, Betas)
    Betas_4Analysis <- Betas[Betas$SubjID1 %in% Subs4Analysis$SubjID1,]
    
}

meantp1<-colMeans(Betas[1:42,2:6])
#meantp2<-colMeans(Betas[43:81,2:6])
#meantp3<-colMeans(Betas[82:121,2:6])
meanhc<-colMeans(Betas[122:152,2:6])
# Create data: note in High school for Jonathan:
#data <- rbind(meantp1,meantp2,meantp3,meanhc)
data <- rbind(meantp1,meanhc)
#Networks<-Networks[1:4]
colnames(data) <- Networks

# To use the fmsb package, I have to add 2 lines to the dataframe: the max and min of each topic to show on the plot!
data <- rbind(rep(max(data),length(Networks)) , rep(min(data),length(Networks)) , data)
data<-as.data.frame(data)
# Check your data, it has to look like this!
# head(data)

# The default radar chart 
radarchart(data, cglcol="gray", pcol=c(6,4),cglwd=2,plty=1,plwd=3)
