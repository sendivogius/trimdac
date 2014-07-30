library(shiny)
library(parallel)
library(fields)

#source("readTrimDACs.R")
source("parReadTrimDACs.R")
source("drawingImages.R")
source("plots1D.R")
source("findPeaks.R")
source("helpers.R")

directory <- "data"

data_all <- parReadTrimDACs(directory)
lowPeaksMax <- findPeaksMax(data_all$low)
highPeaksMax <- findPeaksMax(data_all$high)

peaksFile <- paste(directory, "//peaksGauss.RData", sep="")
print(peaksFile)
if(file.exists(peaksFile)){
  peaks <- load(peaksFile)
  print("readed peaks")
} else {
  lowPeaksGauss <- findPeaksGauss(data_all$low)
  highPeaksGauss <- findPeaksGauss(data_all$high)
  save(lowPeaksGauss, highPeaksGauss, file=peaksFile)
  print("calc and saved")
}

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
        lowPeaksMax
      else{
        lowPeaksGauss
      }
    }
    else{
      if(input$peaksMode == "Max")
        highPeaksMax #precalculated
      else{
        highPeaksGauss
      }
    }
  })
  
  
  output$thresholdScansHeader <- renderText({ 
    paste("Threshold scans (DAC=", input$DAC, ", pixel=", pixelIndex()-1,")")
  })
  
  output$DACcharacteristicHeader <- renderText({ 
    paste("DAC characteristic (pixel=", pixelIndex()-1,")")
  })
  
  output$summaryTable <- renderUI(
    getSummaryTable(peaks(), input$DAC)
  )
  ####################################################################################################
  
  ## 1D plots ########################################################################################
  output$thresholdScanUncorrected <- renderPlot({ 
    plotThresholdScan(data(), pixelIndex(), input$DAC, input$thresholdRange, input$showLines, input$peaksMode)
  }, width=738)
  
  output$pixelDACCharacteristic <- renderPlot({
    plotTrimDACchar(peaks(), pixelIndex())
  })
  
    output$uncorrectedHistogram <- renderPlot({
    plotHistogram(peaks(), input$DAC, input$bins, input$showLines)
  })
  ####################################################################################################
  
  ## 2D plots ########################################################################################
  output$thresholdOverviewUncorrected <- renderPlot({
    if(input$showMode == "Values")
      drawUncorrectedData(data(), input$DAC, input$thresholdRange, input$showLines, input$pixels)
    else if (input$showMode == "Peak positions")
      drawPeaksPositions(data(), peaks(), input$DAC, input$thresholdRange, input$showLines, input$pixels)
  }, height=564)
  ####################################################################################################
  
  
})