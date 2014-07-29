library(shiny)
library(parallel)
library(fields)

#source("readTrimDACs.R")
source("parReadTrimDACs.R")
source("drawingImages.R")
source("plots1D.R")
source("findPeaks.R")
source("helpers.R")

data_all <- parReadTrimDACs('D:\\TrimDAC scan\\Mod003 - trimDAC Scan - TrimRef -1-2-  Icomp- GND CSA -dis BLR - 0 - GND refDAC - 4u')
lowPeaksMax <- findPeaksMax(data_all$low)
highPeaksMax <- findPeaksMax(data_all$high)
lowPeaksGauss <-NA
highPeaksGauss <- NA
oldpar <- par(mar=c(0,0,0,0))


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  ## Reacives ###
  pixelIndex <- reactive({
    calculatePixelIndex(input$row, input$col)
  })
  
  data <- reactive({
    if(input$counters == "low")
      data_all$low
    else
      data_all$high
  })
  
  peaks <- reactive({
    if(input$counters == "low"){
      if(input$peaksMode == "Max")
        lowPeaksMax #precalculated
      else{
        if(is.na(lowPeaksGauss)){
          print("CALC")
          lowPeaksGauss <- findPeaksGauss(data_all$low) #lazy loading
        }
        lowPeaksGauss
      }
    }
    else{
      if(input$peaksMode == "Max")
        highPeaksMax #precalculated
      else{
        if(is.na(highPeaksGauss))
          highPeaksGauss <- findPeaksGauss(data_all$high) #lazy loading
        highPeaksGauss
      }}})
  
  
  output$thresholdScansHeader <- renderText({ 
    paste("Threshold scans (DAC=", input$DAC, ", pixel=", pixelIndex()-1,")")
  })
  
  output$DACcharacteristicHeader <- renderText({ 
    paste("DAC characteristic (pixel=", pixelIndex()-1,")")
  })
  ####################################################################################################
  
  ## 1D plots ########################################################################################
  output$thresholdScanUncorrected <- renderPlot({ 
    plotThresholdScan(data(), pixelIndex(), input$DAC, input$thresholdRange, input$showLines, input$peaksMode)
  })
  
  output$pixelDACCharacteristic <- renderPlot({
    trimDACchar(peaks(), pixelIndex())
  })
  ####################################################################################################
  
  ## 2D plots ########################################################################################
  output$thresholdOverviewUncorrected <- renderPlot({ 
    drawUncorrectedData(data(), input$DAC, input$thresholdRange, input$showLines)
  })
  ####################################################################################################
  
  
  })