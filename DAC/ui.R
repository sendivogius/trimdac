library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Pixel detector analyser!"),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(sidebarPanel(strong("Global settings"),
                             sliderInput("DAC",
                                         "TrimDAC value:",
                                         min = 0,
                                         max = 63,
                                         value = 1),
                             radioButtons("mode", "Counters", c("low", "high"), selected = "low", inline = TRUE),
                             numericInput("row",
                                          "Row:",
                                          min = 1,
                                          max = 24,
                                          value = 1),
                             numericInput("col",
                                          "Col:",
                                          min = 1,
                                          max = 18,
                                          value = 1),
                             sliderInput("thrcorr", "Correct to [mV]: ", min=800, max=1400, value=1200),
                             selectInput("show", "Show mode", c("Values", "Peak positions"), selected = NULL, multiple = FALSE, selectize = TRUE, width = NULL),
                             checkboxInput("showLines", "Show lines", value=T)
  ),
  
  
  # Show a plot of the generated distribution
  mainPanel(
    tabsetPanel(
      tabPanel("Correction",
               h3("Overview"),
               fluidRow(
                 column(6,
                        h4(textOutput("uncorrectedText"))
                        #image1,
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
               fluidRow(
                 column(6,
                        h4("Uncorrected"),
                        plotOutput("thresholdScanUncorrected")
                 ),
                 column(6,
                        h4("Corrected")
                        
                 )
               ),
               h3(textOutput("DACcharacteristicHeader")),
               fluidRow(
                 column(6,offset=3,
                        h4("Uncorrected")
                        #image1,
                 )
               )
      ), 
      tabPanel("Simulation", tableOutput("table"))
    )
  )
  )))
