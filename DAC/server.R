library(shiny)
data <- readTrimDACs('D:\\TrimDAC scan\\Mod003 - trimDAC Scan - TrimRef -1-2-  Icomp- GND CSA -dis BLR - 0 - GND refDAC - 4u')



# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  ## Text outputs ####################################################################################
  output$uncorrectedText <- renderText({ 
    paste("Uncorrected (DAC=", input$DAC, ")")
  })
  
  output$thresholdScansHeader <- renderText({ 
    paste("Threshold scnas (DAC=", input$DAC, ", pixel=", calcPixelNo(input$row, input$col),")")
  })
  
  output$DACcharacteristicHeader <- renderText({ 
    paste("DAC characteristic (pixel=", calcPixelNo(input$row, input$col),")")
  })
  ####################################################################################################
 
  ## 1D plots ########################################################################################
  output$thresholdScanUncorrected <- renderPlot({ 
    plot(data$low_val, data$low[input$DAC+1,,calcPixelNo(input$row, input$col)], xlab="threshold value [mV]", ylab="counts", type='l')
  })
  ####################################################################################################
  

})

calcPixelNo <- function(row, col){
  (col-1)*24+row
}