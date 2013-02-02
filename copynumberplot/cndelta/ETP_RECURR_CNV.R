rm(list=ls())
setwd("C:/Documents and Settings/spaugh/Desktop/cndelta/")
library (gplots)


pdf(file="20120109_ETP_RECURR_cnv_corr.pdf", width=20, height=20)


cnvdata <- read.csv("tall_gistic_cna_20120109", as.is=TRUE, stringsAsFactors=FALSE)
cnvdata$copy_number <- cnvdata$copy_number_change



cnvdata <- cnvdata[,c("donor", "chromosome", "chromstart", "chromend", "copy_number")]



cnvdata[cnvdata$donor == "SJTALL010" & cnvdata$chromosome == "9",]

cnvdata$chromstart <- as.numeric(cnvdata$chromstart)
cnvdata$chromend <- as.numeric(cnvdata$chromend)
cnvdata$copy_number <- as.numeric(cnvdata$copy_number)







genome <- "hg18"

#drawPCGPcnvdata <- function (cnvdata){

###Test to see which genome version we are using and set chromsome lengths##
if (genome=="hg18"){
chr.length <- structure(list(chr = c("1", "2", "3", "4", "5", "6", "7", "8", 
"9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", 
"20", "21", "22", "X", "Y"), length = c(247249719, 242951149, 
199501827, 191273063, 180857866, 170899992, 158821424, 146274826, 
140273252, 135374737, 134452384, 132349534, 114142980, 106368585, 
100338915, 88827254, 78774742, 76117153, 63811651, 62435964, 
46944323, 49691432, 154913754, 57772954)), .Names = c("chr", 
"length"), row.names = c(NA, -24L), class = "data.frame")
}




#####Calculate where to put the chromsome labels###

chr.length$genomic.pos <- cumsum(chr.length$length)

genomic.pos <- chr.length[,"genomic.pos"]
genomic.pos <- c(0, genomic.pos)
genomic.pos <- genomic.pos[1:(length(genomic.pos)-1)]
chr.length$genomic.pos <- genomic.pos

label.pos <- NA
label.pos[1] <- genomic.pos[2]/2
for (i in 2:24){
label.pos[i] <- (genomic.pos[i+1]+genomic.pos[i])/2
}
label.pos[24] <- (genomic.pos[24]+chr.length[24,"length"]+genomic.pos[24])/2
#########








###here we merge in the chromsome locations#####

colnames (cnvdata) <- c("patient", "chr", "chromstart", "chromend", "copy_number")
cnvdata <- merge (cnvdata, chr.length)

cnvdata[,"chromstart"] <- as.numeric(as.character(cnvdata[,"chromstart"]))
cnvdata[,"chromend"] <- as.numeric(as.character(cnvdata[,"chromend"]))

cnvdata$genomic.start <- cnvdata$chromstart + cnvdata$genomic.pos
cnvdata$genomic.end <- cnvdata$chromend + cnvdata$genomic.pos


group.cols2 <- c(rgb(0,100,0, max=255), bluered(19), rgb(252,15,192, max=255))



color.cutoffs <- c(-2, seq(-1.8,1.8,by=0.2), max(cnvdata[,"copy_number"]))


cbind (group.cols2, color.cutoffs)

cnvdata$col <- apply (cnvdata, 1, function(x){group.cols2[findInterval(x["copy_number"], color.cutoffs)]})

cbind (color.cutoffs, group.cols2)

findInterval(1.8, color.cutoffs)
cnvdata$patientnum <- substr(cnvdata$patient, nchar (cnvdata$patient)-2,nchar (cnvdata$patient))
cnvdata$patientnum <- as.numeric(cnvdata$patientnum)


cnvdata <- cnvdata[order(cnvdata$patientnum),]

cnvdata$patientnum <- as.factor(cnvdata$patientnum)
cnvdata$patientnum <- as.numeric(cnvdata$patientnum)



cnvdata <- cnvdata[order(cnvdata$patientnum, cnvdata$genomic.start),]


#cnvdata <- subset (cnvdata, cnvdata$seg_mean < -2 | cnvdata$seg_mean > 2)
######
par (mar=c(0,0,0,0), las=1)
plot (0,0,type="n", axes=FALSE)


par (mar=c(4.5,5.6,3.1,1))
par (fig=c(0,1,0,1), new=T)


xlimmin <- 0
#-(chr.length[chr.length$chr == 1,"length"]/5)
xlimmax <- sum (chr.length$length)
groupmin <- -(chr.length[chr.length$chr == 1,"length"]/5)
groupmax <- 0


plot (0, type="n", xlab="", ylab="", ylim=c(length(unique(cnvdata$patientnum))+0.5,0.5), xlim=c(xlimmin, xlimmax), yaxs="i", xaxs="i", axes=FALSE)
rect (0,length(unique(cnvdata$patientnum))+0.5,sum (chr.length$length),0.5, col="white", ljoin=1)


for (i in 1:nrow(cnvdata)){
rect (cnvdata[i,"genomic.start"], cnvdata[i,"patientnum"]-0.5, cnvdata[i,"genomic.end"], cnvdata[i,"patientnum"]+0.5, col=cnvdata[i,"col"], border=NA, ljoin=1)
}




rect (0,length(unique(cnvdata$patientnum))+0.5,sum (chr.length$length),0.5)



chr.labels <- c(1:22,"X", "Y")
for (i in 1:length(label.pos)){
text(label.pos[i], 0, chr.labels[i], xpd=TRUE)
}

axis(3, at=c(genomic.pos, sum (chr.length$length)), labels=NA)


labels.xaxis <- cnvdata[,c("patient", "patientnum")]
labels.xaxis <- unique (labels.xaxis)


axis (2, at=labels.xaxis$patientnum, labels=labels.xaxis$patient, tick=FALSE)

par (mar=c(0,0.5,0,0.5))
par(fig=c(0.02, 0.15, 0.01, 0.04), new=T)

plot (1, type="n", xlim=c(0,length(group.cols2)), xaxs="i", ylim=c(0,3), yaxs="i", axes=FALSE)

for (i in 1:length(group.cols2)){
rect (i-1,1,i,2, col=group.cols2[i], border=NA)
}
text (0.5, 0.5, "-2", xpd=TRUE)
text (10.5, 0.5, "0")
text (20.5, 0.5, expression("" >= "2"), xpd=TRUE)
#return(list(group.cols2,color.cutoffs))
text (10.5, 2.5, "Copy Number Change")
#}




dev.off()
