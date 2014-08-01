library(shiny)
library(parallel)
library(fields)

source("readTrimDACsPar.R")
source("drawingImages.R")
source("plots1D.R")
source("findPeaks.R")
source("helpers.R")

directory <- "data"

data_all <- readTrimDACsPar(directory)
lowPeaksMax <- findPeaksMax(data_all$low)
highPeaksMax <- findPeaksMax(data_all$high)

peaksFile <- paste(directory, "//peaksGauss.RData", sep="")
if(file.exists(peaksFile)){
  peaks <- load(peaksFile)
  #   print("readed peaks")
} else {
  lowPeaksGauss <- findPeaksGauss(data_all$low)
  highPeaksGauss <- findPeaksGauss(data_all$high)
  save(lowPeaksGauss, highPeaksGauss, file=peaksFile)
  #   print("calc and saved")
}

oldpar <- par(mar=c(0,0,0,0))


# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  ## Reacives ###
  pixelIndex <- reactive({
    calcPixelIndex(input$row, input$col)
  })
  
  data <- reactive({
    if(input$counters == "low"){
      data_all$low
    } else {
      data_all$high
    }
  })
  
  peaks <- reactive({
    if(input$counters == "low"){
      if(input$peaksMode == "Max"){
        lowPeaksMax
      } else {
        lowPeaksGauss
      }
    }
    else{
      if(input$peaksMode == "Max"){
        highPeaksMax #precalculated
      } else {
        highPeaksGauss
      }
    }
  })
  
  correction <- reactive({
    calcCorrection(peaks(), input$thrcorr)
  })
  
  peaksForDACs <- reactive({
    peaks()[,pixelIndex()]
  })
  
  observe({
    pixel <- input$uncorrectedClickId
    # print(pixel)
    if(   !is.null(pixel)
          && pixel$x >= input$thresholdRange[1] && pixel$x <= input$thresholdRange[2]
          && pixel$y >= input$pixelRange[1] && pixel$y <= input$pixelRange[2]){
      
      pixelIndex <- round(pixel$y)
      pixelrc <- calcPixelRowCol(pixelIndex)
      updateNumericInput(session, "col", value=pixelrc$col)
      updateNumericInput(session, "row", value=pixelrc$row)
    }
  })
  
  observe({
    pixel <- input$DACClickId
    #  print(pixel$y)
    if( !(is.null(pixel) || all(is.na(peaksForDACs())))){
      DAC <- round(pixel$x)
      ran <- range(peaksForDACs(), na.rm=T)
      #  print(ran)
      if(DAC >= 0 && DAC <= 63
         && abs(DAC-pixel$x) <= 0.3
         && pixel$y <= ran[2]+1 && pixel$y >= ran[1]-1){
        updateSliderInput(session, "DAC", value=DAC)
      }
    }
    
  })
  
  output$thresholdScansHeader <- renderText({ 
    
    paste("Threshold scans (DAC=", input$DAC, ", pixel=", pixelIndex(),")")
    
  })
  
  output$DACcharacteristicHeader <- renderText({ 
    paste("DAC characteristic (pixel=", pixelIndex(),")")
  })
  #   
  #   ####################################################################################################
  #   
  #   ## 1D plots ########################################################################################
  output$thresholdScanUncorrected <- renderPlot({ 
    plotThresholdScan(data(), pixelIndex(), input$DAC, input$thresholdRange, input$showLines, input$peaksMode)
  }, width=738)
  
  output$pixelDACCharacteristic <- renderPlot({
    plotTrimDACchar(peaksForDACs())
  })
  
  output$uncorrectedHistogram <- renderPlot({
    plotHistogram(peaks(),  rep(input$DAC+1, 432), input$bins, input$showLines)
  })
  output$correctedHistogram <- renderPlot({
    plotHistogram(peaks(), correction(), input$bins, input$showLines)
  })
  #   ####################################################################################################
  #   
  #   ## 2D plots ########################################################################################
  output$thresholdOverviewUncorrected <- renderPlot({
    if(input$showMode == "Values")
      drawUncorrectedData(data(), rep(input$DAC+1, 432), input$thresholdRange, input$showLines, input$pixelRange)
    else
      drawPeaksPositions(data(), peaks(), rep(input$DAC+1, 432), input$thresholdRange, input$showLines, input$pixelRange)
  },height=564)
  
  output$thresholdOverviewCorrected <- renderPlot({
    if(input$showMode == "Values")
      drawUncorrectedData(data(), correction(), input$thresholdRange, input$showLines, input$pixelRange)
    else
      drawPeaksPositions(data(), peaks(), correction(), input$thresholdRange, input$showLines, input$pixelRange)
  }, height=564)
  
  output$simulationUncorrected <- renderPlot({
    if(input$showMode == "Values")
      drawDetector(data(), rep(input$DAC+1,432), input$simulationThreshold)
    else
      drawBadPixels(peaks())
  })
  
  output$simulationCorrected <- renderPlot({
      drawDetector(data(), correction(), input$simulationThreshold)
  #   ####################################################################################################
  })
  
  output$downloadData <- downloadHandler(
    filename = function() { 
      paste("corr", input$counters, input$thrcorr,  '.txt', sep='_') 
    },
    content = function(file) {
      write.table(correction(), file, quote=F, row.names=F, col.names=F)
    })
  
  observe({
    input$findBestCorr
    bc <- bestCorrection(peaks())
    updateSliderInput(session, "thrcorr", value=bc)
  })
  
  observe({
    input$findBestCorr2
    bc <- bestCorrection2(peaks())
    updateSliderInput(session, "thrcorr", value=bc)
  })
  
  output$summaryTable <- renderTable({
    DACindex <- input$DAC+1
    data <- peaks()[DACindex,]
    su <- calcSummary(data)
    
    ind <- cbind(correction(), 1:432)
    dataCorr <- peaks()[ind]
    sc <- calcSummary(dataCorr)
    
    uncorrected = formatC(c(su$min, su$mean, su$std, su$median, su$max), digits=2, format='f')
    names=c("min", "mean", "std", "median", "max")
    corrected=formatC(c(sc$min, sc$mean, sc$std, sc$median, sc$max), digits=2, format='f')
    data.frame(uncorrected, names, corrected, stringsAsFactors=F)
    
  }, include.rownames=F)
  
  #   not working, input$DAC causes to not update images when DAC changes
  #   output$summaryTable <- renderUI({
  #     d <- input$DAC
  #     p <- peaks()
  #     c <- correction()
  #     isolate(getSummaryTable(p, d, c))
  #     })
})