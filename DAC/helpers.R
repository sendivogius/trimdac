
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