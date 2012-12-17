args.orig <- commandArgs()
args.orig
set.seed(42)
probeset.id <- gsub ("--", "", args.orig[9])
diseases <- gsub ("--", "", args.orig[10])
genesymbol <- gsub ("--", "", args.orig[13])
checksum <- gsub ("--", "", args.orig[11])
scale <- gsub("--", "", args.orig[12])
showall <- gsub ("--", "", args.orig[14])
diseasegroup <- gsub ("--", "", args.orig[15])
diseasegroup

if (diseasegroup == "TALLETP"){
#probeset.id <- "1007_PM_s_at"
#pretty.name <- "ETP vs. T-ALL"
}

showall
#showall <- as.logical (showall)

if (is.na(showall)){
showall <- "TRUE"
}

showall <- as.logical (showall)

showall

if (scale == ""){
  scale<- "lin"
}

diseases <- strsplit (diseases, ",")
diseases <- unlist(diseases)

diseases <- gsub ("_", " ", diseases) 
diseases <- gsub ("UWNT", "U(WNT)", diseases)
diseases <- gsub ("USHH", "U(SHH)", diseases)

diseases

if (diseasegroup == "ALL"){
diseaseorder <- as.data.frame(cbind(c("Hyperdiploid", "TCF3-PBX1", "ETV6-RUNX1", "MLL", "BCR-ABL1", "Hypodiploid", "Other", "T-ALL", "CD10+ CD19+","CD34+"), c(1:10)), as.is=TRUE, stringsAsFactors=FALSE)
pretty.name <- "ALL"
}

if (diseasegroup == "MB"){
diseaseorder <- as.data.frame(cbind(c("WNT", "SHH", "A", "G3", "C", "G4", "U"), c(1:7)), as.is=TRUE, stringsAsFactors=FALSE)
#diseaseorder <- as.data.frame(cbind(c("WNT", "SHH", "A", "N", "U(WNT)", "U(SHH)", "C", "U"), c(1:8)), as.is=TRUE, stringsAsFactors=FALSE)
pretty.name <- "MB"
diseases <- gsub ("A", "G3", diseases)
diseases <- gsub ("C", "G4", diseases)
}

if (diseasegroup == "TALLETP"){
diseaseorder <- as.data.frame(cbind(c("ETP", "T"), c(1:2)), as.is=TRUE, stringsAsFactors=FALSE)
pretty.name <- "T-ALL vs. ETP" 
}


diseaseorder <- subset (diseaseorder, diseaseorder[,1] %in% diseases)

if (diseasegroup %in% c("ALL", "MB", "TALLETP")){
ge.data <- read.csv (paste("data/", diseasegroup, "/", substring(probeset.id, 1,2), "/", probeset.id, ".csv", sep=""), as.is=TRUE, stringsAsFactors=FALSE, row.names=1)
}

if (diseasegroup == "ALL"){
load ("20120322gedata.RData")
}

if (diseasegroup == "MB"){
#load ("mbanno.RData")
load ("20121217mbanno.RData")
}

if (diseasegroup == "TALLETP"){
load ("talletp.RData")
}

ls()

#myx <- unlist(ge.data[1,])
pt.int <- intersect (colnames (ge.data), pt.anno$PCGP_ID)
myx <- unlist (ge.data[1,pt.int])

pt.anno <- pt.anno[pt.anno$PCGP_ID %in% pt.int,]
rownames (pt.anno) <- pt.anno$PCGP_ID
pt.anno <- pt.anno[pt.int,]
myy <- factor(pt.anno$Subtype, levels=diseaseorder[,1], ordered=TRUE)

##########
drawFigure <- function (x,y,scale,probeset.id,genesymbol, myshowall){
  if (scale=="log2"){
    x <- log2(x)
  }
  if (length(unique(y[!is.na(y)]))>1){
  boxplot (x~y, outline=!myshowall, pch=16, outcol=rgb(1,0,0,0.75), ylim=c(min(x[!is.na(y)]),max(x[!is.na(y)])), ylab=probeset.id, main=paste(pretty.name, ": ", genesymbol, ": ", probeset.id, sep=""))
if(myshowall){  stripchart(x~y, add=TRUE, vert=TRUE, method="jitter", col=rgb(1,0,0,0.75), pch=16)}
}
  if (length(unique(y[!is.na(y)]))==1){
  boxplot (x~y, outline=!myshowall, pch=16, outcol=rgb(1,0,0,0.75), ylim=c(min(x[!is.na(y)]),max(x[!is.na(y)])), ylab=probeset.id, main=paste(pretty.name, ": ", genesymbol, ": ", probeset.id, sep=""))
if(myshowall){ stripchart(x~y, add=TRUE, vert=TRUE, method="jitter", col=rgb(1,0,0,0.75), pch=16)}
  axis(1, at=1, unique(y[!is.na(y)]))
}

}
############

if (scale == "log2"){
png (file=paste ("../htdocs/geneExpression/Rimages/", checksum, ".png", sep=""), width=1200, height=600)
drawFigure (myx, myy, scale="log2", probeset.id, genesymbol, myshowall=showall)
dev.off()

pdf (file=paste ("../htdocs/geneExpression/Rimages/", checksum, ".pdf", sep=""), width=18, height=9)
drawFigure (myx, myy, scale="log2", probeset.id, genesymbol, myshowall=showall)
dev.off()

svg(file=paste ("../htdocs/geneExpression/Rimages/", checksum, ".svg", sep=""), width=18, height=9)
drawFigure (myx, myy, scale="log2", probeset.id, genesymbol, myshowall=showall)
dev.off()
}            


if (scale == "lin"){
png (file=paste ("../htdocs/geneExpression/Rimages/", checksum, ".png", sep=""), width=1200, height=600)
drawFigure (myx, myy, scale="lin", probeset.id, genesymbol, myshowall=showall)
dev.off()

pdf (file=paste ("../htdocs/geneExpression/Rimages/", checksum, ".pdf", sep=""), width=18, height=9)
drawFigure (myx, myy, scale="lin", probeset.id, genesymbol, myshowall=showall)
dev.off()

svg(file=paste ("../htdocs/geneExpression/Rimages/", checksum, ".svg", sep=""), width=18, height=9)
drawFigure (myx, myy, scale="lin", probeset.id, genesymbol, myshowall=showall)
dev.off()
}

if (scale == "z-score"){
png (file=paste ("../htdocs/geneExpression/Rimages/", checksum, ".png", sep=""), width=1200, height=600)
drawFigure (myx, myy, scale="z-score", probeset.id, genesymbol, myshowall=showall)
dev.off()

pdf (file=paste ("../htdocs/geneExpression/Rimages/", checksum, ".pdf", sep=""), width=18, height=9)
drawFigure (myx, myy, scale="z-score", probeset.id, genesymbol, myshowall=showall)
dev.off()

svg(file=paste ("../htdocs/geneExpression/Rimages/", checksum, ".svg", sep=""), width=18, height=9)
drawFigure (myx, myy, scale="z-score", probeset.id, genesymbol, myshowall=showall)
dev.off()
}

            
