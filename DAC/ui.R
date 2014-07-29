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
                                      sliderInput("thrcorr", "Correct to [mV]: ", min=800, max=1400, value=1200),
                                      selectInput("showMode", "Show mode", c("Values", "Peak positions"), selected = NULL, multiple = FALSE, selectize = TRUE, width = NULL),
                                      selectInput("peaksMode", "Peak detection algorithm", c("Max", "Gauss"), selected = NULL, multiple = FALSE, selectize = TRUE, width = NULL),
                                      checkboxInput("showLines", "Show lines", value=T),
                                      sliderInput("thresholdRange", "Threshold range", min=800, max=1400, value=c(900,1300))
                                      
  ),
  
  
  # Show a plot of the generated distribution
  mainPanel(width=10,
            tabsetPanel(
              tabPanel("Correction",
                       h3("Overview"),
                       fluidRow(
                         column(6,
                                plotOutput("thresholdOverviewUncorrected")
                         ),
                         column(6,
                                h4("Corrected"),
                                
                                checkboxInput("checkbox", label = "Choice A", value = TRUE))
                         
                       ),
                       hr(),
                       h3("Summary")
                       
              ), 
              tabPanel("Pixel characteristic",
                       h3(textOutput("thresholdScansHeader")),
                       plotOutput("thresholdScanUncorrected"),
                       h3(textOutput("DACcharacteristicHeader")),
                       plotOutput("pixelDACCharacteristic")             
              ), 
              tabPanel("Simulation", tableOutput("table"))
            )
  )
  )))
