drawUncorrectedData <- function(values, thresholds, DAC, highlight=NA, pixno=NA){
  DACindex <- DAC+1
  data <- values[DACindex,,]
  image.plot(thresholds, 1:ncol(data), data, 
             col=gray.colors(1000,0,1),
             xlab='Threshold value [mV]', ylab='Pixel number', 
             main=paste('Threshold scan result for ', DAC, 'DAC value')
  )
  
  
  if(highlight)
  {
    max <- apply(data, 2, which.max)
    maxThr <- thresholds[max]
    properMaxThr <- maxThr[maxThr != thresholds[1]]
    avg <- mean(properMaxThr)
    std <- sqrt(var(properMaxThr))
    abline(v=avg, col=2)  
    abline(v=c(avg-std,avg+std), col=3)
  }
}