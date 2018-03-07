library("dplyr")
library(plotly)

crime.data <- read.csv("data/report.csv",  fileEncoding="UTF-8-BOM")
cities <- unique(crime.data$agency_jurisdiction)

server <- function(input, output){
  
  output$yearly.trend <- renderPlotly({
    selected.data <- filter(crime.data, agency_jurisdiction == input$city-select)
    plot <- plot_ly(
      x = selected.data$report_year,
      y = selected.data$violent_crimes,
      type = "histogram"
    )
    return(plot)
  })
}