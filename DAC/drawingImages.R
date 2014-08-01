drawUncorrectedData <- function(scanData, DACs, range, showLines=F, pixRange){
  #DACs dac index for each pixel
  data <- sapply(1:432, function(i) {
    array(scanData$counts[DACs[i],,i])
  })
  data[is.na(data)] <- 0
  
  #title - if all same values DAC, otherwise correction
  if(all(!is.na(DACs)) && min(DACs) == max(DACs))
    title <- paste('Threshold scans result for ', DACs[1]-1, 'DAC value')
  else
    title <- paste('Threshold scans after correction')
  
  cutData <- cutData(data, scanData$thresholds, range, pixRange)
  
  image.plot(cutData$thresholds, cutData$pixels, cutData$data, 
             col=gray.colors(1000,0,1),
             main=title,
             xlab='Threshold value [mV]', 
             ylab='Pixel number',
             xlim=range
  )

  #calculates on original data, not cutted
  if(showLines==T)
  {
    maxInd <- apply(data, 2, which.max)
    maxInd[maxInd==1] <- NA
    maxVal <- scanData$thresholds[maxInd]
    sum <- calcSummary(maxVal)  
    abline(v=sum$mean, col=2)  
    abline(v=c(sum$mean-sum$std,sum$mean+sum$std), col=3)
  }
}

drawPeaksPositions <- function (scanData, peaks, DACs, range, showLines, pixRange){
  ind <- cbind(DACs, 1:432)
  data <- peaks[ind]
  
  #title
  if(all(!is.na(DACs)) && min(DACs) == max(DACs))
    title <- paste('Peaks positions result for ', DACs[1]-1, 'DAC value')
  else
    title <- paste('Peaks position after correction')
  
  pixels <- length(scanData$counts[1,1,])
  scans <- length(scanData$thresholds)
  m <- matrix(rep(0,scans*pixels), scans, pixels)
  image.plot(scanData$thresholds, 1:pixels, m, 
        col=gray.colors(2,0,1),
        xlab='Threshold value [mV]', 
        ylab='Pixel number',
        xlim=range,
        ylim=pixRange,
        main=title
  )
  
  if(showLines==T)
  {
    sum <- calcSummary(data)
    abline(v=sum$mean, col=2)  
    abline(v=c(sum$mean-sum$std,sum$mean+sum$std), col=3)
  }
  
  points(data, 1:pixels, col=0, pch='.')
}