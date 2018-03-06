server <- function(input, output){
  dataInput <- reactive({
   data <- read.csv("data/report.csv", stringsAsFactors = FALSE, fileEncoding = "UTF-8-BOM")
   return(data)
  })
   
  
}