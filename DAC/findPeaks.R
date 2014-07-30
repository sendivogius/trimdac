findPeaksMax <- function(scanData){
  
  m <- apply(scanData$counts, c(1,3), which.max)
  m[m==1] <- NA
  d <- dim(m)
  m <- scanData$thresholds[m]
  dim(m) <- d
  m 
}

findPeaksGauss <- function(scanData){
  cl <- makeCluster(2)
  m <- parApply(cl, scanData$counts, c(1,3), approxThresholdScan, scanData$thresholds)
  stopCluster(cl)
  m
}

approxThresholdScan <- function(counts, thrValues, allPar=F){
  mi <- which.max(counts) 
  if(mi == 1)
    NA
  else{
    fitGauss <- function(par,x, y){
      appr <- par[3] * exp(-0.5 * ((x - par[1])/par[2])^2)
      sum((y - appr)^2)
    }
    m <- max(counts)
    o <- optim(c(thrValues[mi], 1, m), fitGauss, method="BFGS", control=list(reltol=1e-9), y=counts, x=thrValues)
    if(allPar)
      o$par
    else
      o$par[1] #only peak postion
  }
}
