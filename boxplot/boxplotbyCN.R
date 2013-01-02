args.orig <- commandArgs()
args.orig
setwd("/apps/apache2/cgi-bin/boxplot")
set.seed (42)
probeset.id <- gsub ("--", "", args.orig[9])
diseases <- gsub ("--", "", args.orig[10])
genesymbol <- gsub ("--", "", args.orig[13])
checksum <- gsub ("--", "", args.orig[11])
scale <- gsub("--", "", args.orig[12])
showall <- gsub ("--", "", args.orig[14])

if (scale == "na"){
scale <- "log2"
} 

if (is.na(showall)){
showall <- "TRUE"
}

showall <- as.logical(showall)
showall

if (scale == ""){
  scale<- "log2"
}


diseases <- gsub ("T-ALL", "TALLETP", diseases)

#if (diseases == "TALLETP"){
#probeset.id <- "1007_PM_s_at"
#}

#diseases <- strsplit (diseases, ",")
#diseases <- unlist(diseases)

#diseases

#if (probeset.id != "1007_s_at"){
#  probeset.id <- "1007_s_at"                                       
#}

#probesets <- unlist(strsplit(probeset.id,split=","))

#load (paste("data/", substring(probeset.id, 1,2), "/", probeset.id, ".RData", sep=""))

if (diseases %in% c("MB", "T-ALL", "TALLETP")){
diseases <- gsub ("TALLETP", "T-ALL", diseases)
ge.data <- read.csv (paste("../data/", diseases, "/", substring(probeset.id, 1,2), "/", probeset.id, ".csv", sep=""), as.is=TRUE, stringsAsFactors=FALSE, row.names=1)
}

ge.data

#cn.data <- read.csv ("CNVData.csv", as.is=TRUE, stringsAsFactors=FALSE)

load("../RData/20120509TALLMBRBmutdata.RData")
#cn.data <- read.csv ("Mutation Data for TALL MB and RB - 5_9_12.csv", as.is=TRUE, stringsAsFactors=FALSE)

#cn.data <- subset(cn.data, cn.data$Gene.Symbol == genesymbol)
cn.data <- subset(cn.data, cn.data$gene == genesymbol)

#cn.data <- subset(cn.data, cn.data$Type == "CNV")
cn.data <- subset(cn.data, cn.data$type == "CNV")

head (cn.data)


#cn.data <- cn.data[,c("Donor", "Class")]
cn.data <- cn.data[,c("donor", "class")]
colnames (cn.data) <- c("Donor", "Class")

amp.samples <- unlist (cn.data[cn.data$Class=="AMP","Donor"])
del.samples <- unlist (cn.data[cn.data$Class=="DEL","Donor"])

cn.data

#names (myx)



if (diseases == "MB"){
load ("../RData/20121217mbanno.RData")
pretty.name <- "MB"
diseases <- gsub ("A", "G3", diseases)
diseases <- gsub ("C", "G4", diseases)
}

if (diseases %in% c("T-ALL", "TALLETP")){
load ("../RData/talletp.RData")
pretty.name <- "T-ALL"
}

#load ("20120322gedata.RData")
ls()

myx <- unlist(ge.data[1,])
#pt.anno <- pt.anno[pt.anno$Subtype == "T-ALL", ]
#myy <- factor(pt.anno$Subtype, levels=diseases)

#myz <- rep ("Diploid", times=length (myx))

myz <- ifelse (names(myx) %in% amp.samples, "Gain", ifelse(names(myx) %in% del.samples, "Loss", "Diploid"))

#myx <- myx[!is.na(myy)]
#myz <- myz[!is.na(myy)]
#myy <- myy[!is.na(myy)]

length(myx)
#length(myy)
length(myz)



#myz

#myx

#myy

#min(myx ~ myy)
##########
drawFigure <- function (x,y,scale,probeset.id,genesymbol,myshowall){
  if (scale=="log2"){
    x <- log2(x)
  }
  y <- factor (y, levels=c("Loss", "Diploid", "Gain"))
  boxplot (x~y, outline=!myshowall, pch=16, outcol=rgb(1,0,0,0.75), ylim=c(min(x),max(x)), ylab=probeset.id, main=paste(pretty.name, ": ", genesymbol, ": ", probeset.id, sep=""))
  if(myshowall){stripchart(x~y, add=TRUE, vert=TRUE, method="jitter", col=rgb(1,0,0,0.75), pch=16)}
}
############

if (scale == "log2"){
png (file=paste ("../../htdocs/geneExpressionbyCN/Rimages/", checksum, ".png", sep=""), width=1200, height=600)
drawFigure (myx, myz, scale="log2", probeset.id, genesymbol, myshowall=showall)
dev.off()

pdf (file=paste ("../../htdocs/geneExpressionbyCN/Rimages/", checksum, ".pdf", sep=""), width=18, height=9)
drawFigure (myx, myz, scale="log2", probeset.id, genesymbol, myshowall=showall)
dev.off()

svg(file=paste ("../../htdocs/geneExpressionbyCN/Rimages/", checksum, ".svg", sep=""), width=18, height=9)
drawFigure (myx, myz, scale="log2", probeset.id, genesymbol, myshowall=showall)
dev.off()
}            


if (scale == "lin"){
png (file=paste ("../../htdocs/geneExpressionbyCN/Rimages/", checksum, ".png", sep=""), width=1200, height=600)
drawFigure (myx, myz, scale="lin", probeset.id, genesymbol, myshowall=showall)
dev.off()

pdf (file=paste ("../../htdocs/geneExpressionbyCN/Rimages/", checksum, ".pdf", sep=""), width=18, height=9)
drawFigure (myx, myz, scale="lin", probeset.id, genesymbol, myshowall=showall)
dev.off()

svg(file=paste ("../../htdocs/geneExpressionbyCN/Rimages/", checksum, ".svg", sep=""), width=18, height=9)
drawFigure (myx, myz, scale="lin", probeset.id, genesymbol, myshowall=showall)
dev.off()
}

if (scale == "z-score"){
png (file=paste ("../../htdocs/geneExpressionbyCN/Rimages/", checksum, ".png", sep=""), width=1200, height=600)
drawFigure (myx, myz, scale="z-scale", probeset.id, genesymbol, myshowall=showall)
dev.off()

pdf (file=paste ("../../htdocs/geneExpressionbyCN/Rimages/", checksum, ".pdf", sep=""), width=18, height=9)
drawFigure (myx, myz, scale="z-scale", probeset.id, genesymbol, myshowall=showall)
dev.off()

svg(file=paste ("../../htdocs/geneExpressionbyCN/Rimages/", checksum, ".svg", sep=""), width=18, height=9)
drawFigure (myx, myz, scale="z-scale", probeset.id, genesymbol, myshowall=showall)
dev.off()
}
            
