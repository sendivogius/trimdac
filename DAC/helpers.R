
calcPixelIndex <- function(row, col){
  #row, col starts from 1
  #pixel index 1-432
  (row-1)*18+col
}

calcPixelRowCol <- function(index){
  row <- ceiling(index/18)
  col <- index-18*(row-1)
  list(row=row, col=col)
}


calcSummary <- function(data){
  list(
    min=min(data, na.rm=T), 
    max=max(data, na.rm=T), 
    mean=mean(data, na.rm=T), 
    median=median(data, na.rm=T), 
    std=sqrt(var(data, na.rm=T))
  )
}

getSummaryTable <- function(peaks, DAC, correction, digits=2){
  DACindex <- DAC+1
  data <- peaks[DACindex,]
  sumUncorrected <- calcSummary(data)
  
  ind <- cbind(correction, 1:432)
  dataCorr <- peaks[ind]
  sumCorrected <- calcSummary(dataCorr)
    
  text <- '<div id="summaryTable" class="shiny-html-output shiny-bound-output">
      <table class="data table table-bordered table-condensed">
      <tbody>
      <tr> <th> uncorrected </th> <th> parameter </th> <th> corrected </th>  </tr>
      <tr> <td style="text-align: right;"> _UNC_MIN_ </td> <td style="text-align: center;"> Min </td> <td> _COR_MIN_ </td> </tr>
    <tr> <td style="text-align: right;"> _UNC_MEAN_ </td> <td style="text-align: center;"> Mean </td> <td> _COR_MEAN_ </td> </tr>
    <tr> <td style="text-align: right;"> _UNC_STD_ </td> <td style="text-align: center;"> Std </td> <td> _COR_STD_ </td> </tr>
    <tr> <td style="text-align: right;"> _UNC_MED_ </td> <td style="text-align: center;"> Std </td> <td> _COR_MED_ </td> </tr>
    <tr> <td style="text-align: right;"> _UNC_MAX_ </td> <td style="text-align: center;"> Max </td> <td> _COR_MAX_ </td> </tr>
    </tbody>
      </table>
      </div>'
  text <- sub("_UNC_MIN_", format(round(sumUncorrected$min,digits), nsmall=digits), x=text)
  text <- sub("_UNC_MEAN_", format(round(sumUncorrected$mean,digits), nsmall=digits), x=text)
  text <- sub("_UNC_STD_", format(round(sumUncorrected$std,digits), nsmall=digits), x=text)
  text <- sub("_UNC_MED_", format(round(sumUncorrected$median,digits), nsmall=digits), x=text)
  text <- sub("_UNC_MAX_", format(round(sumUncorrected$max,digits), nsmall=digits), x=text)
  
  text <- sub("_COR_MIN_", format(round(sumCorrected$min,digits), nsmall=digits), x=text)
  text <- sub("_COR_MEAN_", format(round(sumCorrected$mean,digits), nsmall=digits), x=text)
  text <- sub("_COR_STD_", format(round(sumCorrected$std,digits), nsmall=digits), x=text)
  text <- sub("_COR_MED_", format(round(sumCorrected$median,digits), nsmall=digits), x=text)
  text <- sub("_COR_MAX_", format(round(sumCorrected$max,digits), nsmall=digits), x=text)
  
  
  HTML(text)
}


calcCorrection <- function(peaksPositions, thresholdValue){
  sapply(1:432, function(pixInd){
    data <- peaksPositions[,pixInd]
    if(!all(is.na(data)))
       which.min(abs(data-thresholdValue))
     else
      NA
         
  })
}

bestCorrection <- function(peaks){
  sapply(1150:1250, function(th) {
    corr <- calcCorrection(peaks, th)
    ind <- cbind(corr, 1:432)
    data <- peaks[ind]
    sum <- calcSummary(data)
    sum$std
    })
}