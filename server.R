server <- function(input, output){
  crime.data <- reactive({
    return(read.csv("data/report.csv",  fileEncoding="UTF-8-BOM"))
  })
}