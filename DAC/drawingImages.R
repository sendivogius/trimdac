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

drawBadPixels <- function(peaks){
  bad <- apply(peaks, 2, function(x) {!all(is.na(x))})
  dim(bad) <- c(18,24)
  par(pty="s")
  par(mar=c(2,0,2,3))
  colors = c(rgb(1,0,0,1), rgb(0,1,0,1))
  image(1:18,1:24,bad, col=colors,
        main="Bad pixels",
        ylim=c(24.5,0.5), 
        xlim=c(0.5,18.5),
        axes = F,
  )
 brk <- c(0, 0.5,1)
  
  axis(1,at=1:18)
  axis(2,at=1:24, las=2)
 image.plot(bad, legend.only=T, col=colors,legend.shrink=0.4, breaks=brk, lab.breaks=c("bad", "", "good"))
  
}

n <- 5000
colors <- hsv(rep(0.19,n), rep(1,n), seq(0,1,length=n))
drawDetector <- function(scanData, DACs, threshold){
  data <- sapply(1:432, function(i) {
    array(scanData$counts[DACs[i],,i])
  })
  data[is.na(data)] <- 0
  thr <- abs(scanData$thresholds - threshold)
  thrInd <- which.min(thr)
  pixValues <- data[thrInd,]
  
  ##  takes long time to compute ~200ms so don't use it   
  #   #approximation needed hence scan can be done by 2mV and plotting by 1mV
  #   pixValues <- apply(data, 2, function(scan){
  #     a <- approx(scanData$thresholds, scan, threshold)
  #     a$y
  #   })
  zl <- c(0,max(scanData$counts))
  dim(pixValues) <- c(18,24)
  
  par(pty="s")
  par(mar=c(2,0,2,3))
  image(1:18, 1:24, pixValues,
        col=colors, 
        main=paste(threshold, "mV"), 
        xlab="", 
        ylab="", 
        lwd=2,  
        ylim=c(24.5,0.5), 
        xlim=c(0.5,18.5), 
        zlim=zl,
        axes=F
        
  )
  axis(1,at=1:18)
  axis(2,at=1:24, las=2)
  image.plot(pixValues, legend.only=T, col=colors, zlim=zl)
}
