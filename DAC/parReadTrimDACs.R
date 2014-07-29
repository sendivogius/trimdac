parReadTrimDACs <- function(directory){
  cl <- makeCluster(2)
  out <- parLapply(cl, c("l","h"), readMode, directory)
  stopCluster(cl)
  names(out) <- c("low", "high")
  list(low=out[[1]], high=out[[2]])
}


readMode <- function(mode, directory){
  print(mode)
  print(directory)
  files <- list.files(path=directory, pattern=paste("*", mode,".csv$", sep=""))
  
  DACs <- length(files)
  paste("*", mode,".csv$", sep="")
  
  #read first file to get info about num of pixels and thresholds
 data <- read.csv(paste(directory, "//", files[1], sep=""), header=F)
 pixels <- ncol(data)-1  #first column is threshold value so not counting it
 scans <- nrow(data)
  
  #allocate memory for data
  counts <- array(1:(DACs*pixels*scans), c(DACs,scans,pixels))
 thresholds <- array(1:scans)
  
  for(f in files){
    DACValueIndex <- as.numeric(substring(f,1,3)) + 1 #DAC values start with 0, R indexing with 1
    mode <- substring(f,4,4) #l or h
    data <- read.csv(paste(directory, "//", f, sep=""), header=F)
    data <- as.matrix(data)
    
    t <- data[,1]
    c <- data[,-1]
    
    if(t[1] > t[2]){
      c <- c[scans:1,]
      t <- rev(t)
    }
    
    counts[DACValueIndex,,] <- c
    thresholds <- t
  }
  
  list(thresholds=thresholds, counts=counts)
}