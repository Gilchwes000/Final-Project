library("rlang")
library("ggplot2")
library("plotly")
library("shiny")


data <- read.csv("data/report.csv", stringsAsFactors = FALSE, fileEncoding = "UTF-8-BOM")
years <- unique(data$report_year)
city <- data$agency_jurisdiction[1:69]
crimeTypes <- c("Total Crimes", "Homicides", "rapes", "assaults", "robberies")
server <- function(input, output){
  
 
   YearReact <- reactive({
    return(input$yearChoice)
  })
  
   CityReact <- reactive({
     return(input$cityChoice)
   })
   
   
  output$plot <- renderPlotly({
    cityData <- data[grep(CityReact(), data$agency_jurisdiction),] 
    yearData <- filter(cityData, report_year == YearReact())
    specificInfo <- (select(yearData, crimes_percapita:robberies_percapita))
    finalInfo <- as.numeric(as.vector(specificInfo[1,]))
    p<- plot_ly(
     x = crimeTypes,
     y = finalInfo,
     name = "Bar Graph", 
     type = "bar") %>%
     layout(
       title = paste("Crime Rates for", CityReact(), "in", YearReact()),
       scene = list(
         xaxis = list(title = "Crimes"),
         yaxis = list(title = "Crimes Per")
       ))
  })
  
  output$extraInfo <- renderText({
    
    paste("The above information shows the occurence levels of crimes in " , CityReact(), " as of ", YearReact(), 
"Showing  which crime is most common for the given city and given year.
As you scroll through and explore, the types of crimes being commited do not change drastically, 
although some cities have drastic changes in levels of crime (see graph to the left)
Assaults and roberies remain the two most common type of violent crime in america, where rape 
and homicide remain at a much lower rate. The majority of observed cities, as well as in America
the rates of crime have gone down since the 80's and 90's.")
    
  })
     
  output$plot2 <- renderPlotly({
    cityData <- data[grep(CityReact(), data$agency_jurisdiction),] 
    specificInfo <- (select(cityData, crimes_percapita))
    overall <- specificInfo$crimes_percapita[1:41]
    plots <- plot_ly(
      x = years,
      y = overall,
      name = "Scatter", 
      type = "scatter",
      mode = "line") %>%
      layout(
        title = paste("Crime Rates over the years
                      for", CityReact()),
        scene = list(
          xaxis = list(title = "Crimes"),
          yaxis = list(title = "Crimes Per")
        ))
    
    
  })
   
}
