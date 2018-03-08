library("dplyr")
library(plotly)

crime.data <- read.csv("data/report.csv",  fileEncoding="UTF-8-BOM")
locations <- unique(crime.data$agency_jurisdiction)
cities <- locations[locations != "United States"]
selected.data <- filter(crime.data, agency_jurisdiction == "United States")

server <- function(input, output){
  
  output$yearly.trend.per.city <- renderPlotly({
    selected.data <- filter(crime.data, agency_jurisdiction == input$'city-select')
    p <- plot_ly(selected.data, x = ~report_year, y = ~crimes_percapita, name = input$'city-select', type = 'scatter', mode = 'lines',
                 line = list(color = 'rgb(205, 12, 24)', width = 4)) %>%
      layout(title = input$'city-select')
  })
  
  output$yearly.trend <- renderPlotly({
    selected.data <- filter(crime.data, agency_jurisdiction == "United States")
    p <- plot_ly(selected.data, x = ~report_year, y = ~crimes_percapita, name = "United States", type = 'scatter', mode = 'lines',
                 line = list(color = 'rgb(205, 12, 24)', width = 4)) %>%
      layout(title = "United States Crimes Per Capita Data")
  })
}
