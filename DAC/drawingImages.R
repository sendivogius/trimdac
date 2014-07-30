drawUncorrectedData <- function(scanData, DAC, range, showLines=F, pixRange){
  DACindex <- DAC+1
  data <- scanData$counts[DACindex,,]
  image.plot(scanData$thresholds, 1:ncol(data), data, 
             col=gray.colors(1000,0,1),
             main=paste('Threshold scan result for ', DAC, 'DAC value'),
             xlab='Threshold value [mV]', 
             ylab='Pixel number', 
             xlim=range,
             ylim=pixRange
  )

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

drawPeaksPositions <- function (scanData, peaks, DAC, range, showLines, pixRange){
  DACindex <- DAC+1
  data <- peaks[DACindex,]
  pixels <- length(scanData$counts[1,1,])
  scans <- length(scanData$thresholds)
  m <- matrix(rep(0,scans*pixels), scans, pixels)
  image.plot(scanData$thresholds, 1:pixels, m, 
        col=gray.colors(2,0,1),
        xlab='Threshold value [mV]', 
        ylab='Pixel number',
        xlim=range,
        ylim=pixRange
  )
  
  if(showLines==T)
  {
    sum <- calcSummary(data)
    abline(v=sum$mean, col=2)  
    abline(v=c(sum$mean-sum$std,sum$mean+sum$std), col=3)
  }
  
  points(data, 1:pixels, col=0, pch='.')
}