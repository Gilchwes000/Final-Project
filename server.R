library("dplyr")
server <- function(input, output){
  crime.data <- reactive({
    return(read.csv("data/report.csv",  fileEncoding="UTF-8-BOM"))
  })
  
  output$yearly.trend <- renderDataTable({
    group_by(crime.data(), agency_code) %>%
      summarise(location = agency_jurisdiction[1], mean_number_violent_crimes = mean(violent_crimes), 
                years_listed = n()) %>%
      return()
  })
}