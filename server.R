#install.packages(leaflet)
library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)
#library(leaflet)
library(stringr)

crime.data <- read.csv("data/report.csv",  fileEncoding="UTF-8-BOM")


shinyServer(function(input, output){

  #Section 3: City/Population Crime Rates
  clean.data <- reactive({
    city.data <- crime.data %>%
    na.omit() %>%
    filter(report_year == input$year3) %>%
    select(population, "Homicides" = homicides_percapita, "Rapes" = rapes_percapita,
           "Assaults" = assaults_percapita, "Robberies" = robberies_percapita) %>%
    gather(key = crime,
           value = number,
           Homicides, Rapes, Assaults, Robberies)
  })
  output$citymap <- renderPlot({
    ggplot(data = clean.data()) +
      geom_smooth(mapping = aes(x = population, y = number), color = "purple", fill = "gold") +
      ggtitle("Per Capita Crime Distribution by City Size") +
      labs(x = "City Size",y = "Number of Crimes") +
      facet_wrap(~crime)
  })
})
