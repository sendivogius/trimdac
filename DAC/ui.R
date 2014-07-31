library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Pixel detector analyser!"),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(fluid=T, sidebarPanel(strong("Global settings"), width=2,
                                      sliderInput("DAC",
                                                  "TrimDAC value:",
                                                  min = 0,
                                                  max = 63,
                                                  value = 0),
                                      sliderInput("pixelRange",
                                                  "Pixels:",
                                                  min = 1,
                                                  max = 432,
                                                  value = c(1,432)),
                                      radioButtons("counters", "Counters", c("low", "high"), selected = "low", inline = TRUE),
                                      div(style="display:inline-block;width:45%;margin-right:10px",
                                          numericInput("row",
                                                       "Row:",
                                                       min = 1,
                                                       max = 24,
                                                       value = 1)),
                                      div(style="display:inline-block;width:45%;",
                                          numericInput("col",
                                                       "Col:",
                                                       min = 1,
                                                       max = 18,
                                                       value = 1)),
                                      sliderInput("thrcorr", "Correct to [mV]: ", min=00, max=1400, value=1200),
                                      selectInput("showMode", "Show mode", c("Values", "Peak positions", "Bad pixels"), selected = NULL, multiple = FALSE, selectize = TRUE, width = NULL),
                                      selectInput("peaksMode", "Peak detection algorithm", c("Max", "Gauss"), selected = NULL, multiple = FALSE, selectize = TRUE, width = NULL),
                                      checkboxInput("showLines", "Show lines", value=T),
                                      sliderInput("thresholdRange", "Threshold range", min=800, max=1400, value=c(800,1400)),
                                      sliderInput("bins", "Bins of histogram", min=10, max=432, value=50)
                                      
  ),
  
  
  # Show a plot of the generated distribution
  mainPanel(width=10,
            tabsetPanel(
              tabPanel("Correction",
                       h3("Overview", style="text-align: center; padding-right:200px"),
                       fluidRow(style="height:560px",
                         column(6,
                                plotOutput("thresholdOverviewUncorrected", clickId="uncorrectedClickId")
                         ),
                         column(6,
                                h4("Corrected"),
                                
                                checkboxInput("checkbox", label = "Choice A", value = TRUE))
                         
                       ),
                       hr(),
                       h3("Histograms", style="text-align: center; padding-right:200px"),
                       fluidRow(
                         column(6,
                                plotOutput("uncorrectedHistogram")
                         ),
                         column(6,
                                h4("Corrected")
                                
                         )
                       ),
                       hr(),
                       h3("Summary", style="text-align: center; padding-right:200px"),
                       fluidRow(
                         column(4),
                         column(4,
                                uiOutput("summaryTable")  
                         ),
                         column(4)
                       )
              ), 
              tabPanel("Pixel characteristic",
                       h3(textOutput("thresholdScansHeader"),style="text-align: center;"),
                       fluidRow(
                         column(2),
                         column(8,
                                plotOutput("thresholdScanUncorrected")
                         ),
                         column(2)
                       ),
                       h3(textOutput("DACcharacteristicHeader"), style="text-align: center;"),
                       plotOutput("pixelDACCharacteristic", clickId="DACClickId")             
              ), 
              tabPanel("Simulation", tableOutput("table"))
            )
  )
  )))
