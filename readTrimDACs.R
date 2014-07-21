readTrimDACs <- function(directory){
  files <- list.files(path=directory, pattern="*.csv$")
  
  #filename format DDDS.csv
  #                ^^^^
  #                ///|
  #         DAC value  \
  #                    scan mode (h-high, l-low)
  
  DACs <- length(files)/2
  
  #read first file to get info about num of pixels and thresholds
  
  data <- read.csv(paste(directory, "//", files[1], sep=""), header=F)
  pixels <- ncol(data)-1
  scans <- nrow(data)
  
  #allocate memory for data
  high <- matrix(1:(DACs*pixels*scans))
  dim(high) <- c(DACs,scans,pixels)
  low <- high
  high_threshold_val <- array()
  low_threshold_val <- array()
  
  for(f in files){
    print(paste('reading ', f))
    DACValueIndex <- as.numeric(substring(f,1,3)) + 1 #DAC values start with 0, R indexing with 1
    mode <- substring(f,4,4) #l or h
    data <- read.csv(paste(directory, "//", f, sep=""), header=F)
    data <- as.matrix(data)
    
    thr <- data[,1]
    val <- data[,-1]
    
     if(thr[1] > thr[2]){
       val <- val[nrow(val):1,]
       thr <- rev(thr)
   }
    
    if(mode == 'l'){
      low[DACValueIndex,,] <- val
      low_threshold_val <- thr
    }
    if(mode == 'h'){
      high_threshold_val <- thr
      high[DACValueIndex,,] <- val
    }
    
  }
  list(low_val = low_threshold_val, high_val = high_threshold_val, low = low, high = high)
}

