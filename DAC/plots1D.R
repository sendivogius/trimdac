plotTrimDACchar <- function(peakPositions, pixelIndex){
  thr <- peakPositions[,pixelIndex]
  
  if(!all(is.na(thr))){
    plot(thr, xlab="DAC value", ylab="peak position [mV]", type='l', xaxt="n")
    axis(1, at=seq(0,63,9))
  }
  else
  {
    plot(NA,NA,axes=F,xlim=c(0,10),ylim=c(0,1),xlab="",ylab="")
    text(5,1,labels="Can't calculate DAC characteristic", cex=1.5)
  }
}

plotThresholdScan <- function(data, pixelIndex, DAC, range, showLines, peakMode){
  DACindex <- DAC+1;
  scan <- data$counts[DACindex,,pixelIndex]
  par <- NULL;
  #must calculate before plot to get ylim range
  if(showLines && peakMode != "Max"){
    par <- approxThresholdScan(scan, data$threshold, T)
  }
  plot(data$thresholds, scan, 
       xlab="threshold value [mV]", 
       ylab="counts", 
       type='l', 
       xlim=range,
       ylim=range(c(scan,par[3]))
  )
  
  if(showLines){
    x <-  data$thresholds[which.max(scan)]
    y <- max(scan)
    if(peakMode != "Max"){
      th2 <- seq(par[1]-5*par[2],par[1]+5*par[2], length.out=50)
      appr <- par[3] * exp(-0.5 * ((th2 - par[1])/par[2])^2)
      lines(th2, appr, col="blue", type="l")
      x<-par[1]
      y<-par[3]
    }  
    points(x,y, pch='*', col="red") 
  }
}
