
calculatePixelIndex <- function(row, col){
  #pixel Index
  (row-1)*18+col
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

getSummaryTable <- function(peaks, DAC, digits=2){
  DACindex <- DAC+1
  data <- peaks[DACindex,]
  sumUncorrected <- calcSummary(data)
  #summCorrected <- 
    
  text <- '<div id="summaryTable" class="shiny-html-output shiny-bound-output">
      <table class="data table table-bordered table-condensed">
      <tbody>
      <tr> <th> uncorrected </th> <th> parameter </th> <th> corrected </th>  </tr>
      <tr> <td style="text-align: right;"> _UNC_MIN_ </td> <td style="text-align: center;"> Min </td> <td> 1.00 </td> </tr>
    <tr> <td style="text-align: right;"> _UNC_MEAN_ </td> <td style="text-align: center;"> Mean </td> <td> 2.00 </td> </tr>
    <tr> <td style="text-align: right;"> _UNC_STD_ </td> <td style="text-align: center;"> Std </td> <td> 2.00 </td> </tr>
    <tr> <td style="text-align: right;"> _UNC_MAX_ </td> <td style="text-align: center;"> Max </td> <td> 2.00 </td> </tr>
    </tbody>
      </table>
      </div>'
  text <- sub("_UNC_MIN_", format(round(sumUncorrected$min,digits), nsmall=digits), x=text)
  text <- sub("_UNC_MEAN_", format(round(sumUncorrected$mean,digits), nsmall=digits), x=text)
  text <- sub("_UNC_STD_", format(round(sumUncorrected$std,digits), nsmall=digits), x=text)
  text <- sub("_UNC_MAX_", format(round(sumUncorrected$max,digits), nsmall=digits), x=text)
  
  HTML(text)
}