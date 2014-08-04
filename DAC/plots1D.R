plotTrimDACchar <- function(peakForDACs){
  if(!all(is.na(peakForDACs))){
    plot(0:63, peakForDACs, xlab="DAC value", ylab="peak position [mV]", type='o', xaxt="n")
    axis(1, at=seq(0,63,4))
  }
  else
  {
    plot(NA,NA,axes=F,xlim=c(0,10),ylim=c(0,1),xlab="",ylab="")
    text(5,1,labels="Can't calculate DAC characteristic", cex=1.5)
  }
}

plotThresholdScan <- function(data, pixelIndex, DAC, range, showLines, peakMode="Max"){
  DACindex <- DAC+1;
  scan <- data$counts[DACindex,,pixelIndex]
  par <- NA;
  #must calculate before plot to get ylim range
  
  if(showLines && peakMode != "Max"){
    par <- approxThresholdScan(scan, data$threshold, T)
  }
  
  plot(data$thresholds, scan, 
       xlab="threshold value [mV]", 
       ylab="counts", 
       type='l', 
       xlim=range,
       ylim=range(c(scan,par[3]), na.rm=T)
  )
  
  if(showLines){
    max_ind <-  which.max(scan)
    x <- data$thresholds[max_ind]
    y <- max(scan)
    if(peakMode != "Max" && max_ind != 1){
      th2 <- seq(par[1]-5*par[2],par[1]+5*par[2], length.out=50)
      appr <- par[3] * exp(-0.5 * ((th2 - par[1])/par[2])^2)
      lines(th2, appr, col="blue", type="l")
      x<-par[1]
      y<-par[3]
    } 
    if(max_ind != 1)
      points(x,y, pch='*', col="red") 
  }
}

plotHistogram <- function(peaks, DACs, bins, showLines)
{
  ind <- cbind(DACs, 1:432)
  data <- peaks[ind]
  
  h <- hist(data, 
       breaks=bins, 
       col="blue", 
       xlab="peak position [mV]", 
       ylab="number", 
       density=20, 
       angle=45, 
       prob=F, 
       main="",
       xaxt='n')
  axis(side=1, at=seq(1000,1400,10), lab=seq(1000,1400,10))

  if(showLines){
    m <- mean(data,na.rm=T)
    s <- sqrt(var(data,na.rm=T))
    mult <- (h$count/h$density)[1]
    curve(mult*dnorm(x, mean=m, sd=s), col="darkblue", lwd=1,add=T, yaxt='n', to=m-s)
    curve(mult*dnorm(x, mean=m, sd=s), col="darkblue", lwd=1,add=T, yaxt='n', from=m+s)
    curve(mult*dnorm(x, mean=m, sd=s), col="green", lwd=2,add=T, yaxt='n', from=m-s, to=m+s)
  }
}
