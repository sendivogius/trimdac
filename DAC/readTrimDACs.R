readTrimDACs <- function(directory){
  files <- list.files(path=directory, pattern="*.csv$")
  
  #filename format DDDS.csv
  #                ^^^^
  #                ///|
  #         DAC value  \
  #                    scan mode (h-high, l-low)
  
  DACs <- length(files)/2 #each DAC scan is stored in 2 files
  
  #read first file to get info about num of pixels and thresholds
  data <- read.csv(paste(directory, "//", files[1], sep=""), header=F)
  pixels <- ncol(data)-1  #first column is threshold value so not counting it
  scans <- nrow(data)
  
  #allocate memory for data
  high_counts <- array(1:(DACs*pixels*scans), c(DACs,scans,pixels))
  low_counts <- high_counts
  high_thresholds <- array(1:scans)
  low_thresholds <- high_thresholds
  
  for(f in files){
   # print(paste('reading ', f))
    DACValueIndex <- as.numeric(substring(f,1,3)) + 1 #DAC values start with 0, R indexing with 1
    mode <- substring(f,4,4) #l or h
    data <- read.csv(paste(directory, "//", f, sep=""), header=F)
    data <- as.matrix(data)
    
    thresholds <- data[,1]
    counts <- data[,-1]
    
    if(thresholds[1] > thresholds[2]){
      counts <- counts[scans:1,]
      thresholds <- rev(thresholds)
    }
    
    if(mode == 'l'){
      low_counts[DACValueIndex,,] <- counts
      low_thresholds <- thresholds
    }
    if(mode == 'h'){
      low_counts[DACValueIndex,,] <- counts
      low_thresholds <- thresholds
      
    }
  }
  
  list(low=list(thresholds=low_thresholds, counts=low_counts),
       high=list(thresholds=high_thresholds, counts=high_counts)
  )
}