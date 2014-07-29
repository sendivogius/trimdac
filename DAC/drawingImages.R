drawUncorrectedData <- function(scanData, DAC, range, highlight=F){
  DACindex <- DAC+1
  data <- scanData$counts[DACindex,,]
  image.plot(scanData$thresholds, 1:ncol(data), data, 
             col=gray.colors(1000,0,1),
             main=paste('Threshold scan result for ', DAC, 'DAC value'),
             xlab='Threshold value [mV]', 
             ylab='Pixel number', 
             xlim=range
  )

  if(highlight==T)
  {
    maxInd <- apply(data, 2, which.max)
    maxInd[maxInd==1] <- NA
    maxVal <- scanData$thresholds[maxInd]
    avg <- mean(maxVal, na.rm=T)
    std <- sqrt(var(maxVal, na.rm=T))
    abline(v=avg, col=2)  
    abline(v=c(avg-std,avg+std), col=3)
  }
}