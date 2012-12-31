
data <- read.csv("SJHYPO_GEP_matrix_GPL570.csv", as.is=TRUE, stringsAsFactors=FALSE)

rownames (data) <- data$ID_REF

data$ID_REF <- NULL

dir.create("./HYPO", showWarnings = FALSE)

for (i in 1:nrow(data)){
  probe.path <- substr(rownames(data)[i], 1, 2)
  
  dir.create(file.path("./HYPO", probe.path), showWarnings = FALSE)
  clean.probe <- gsub ("/", "_", rownames(data)[i])
  write.csv (data[i,], file=paste("./HYPO/", probe.path, "/", clean.probe, ".csv", sep=""))
}


