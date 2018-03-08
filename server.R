library("ggplot2")
library(dplyr)
library("maps")
library(shiny)
source("spatial_utils.R")
#Package to abbreviate the states to 2 letters. 
#install.packages("openintro")
library("openintro")
crime.data <- read.csv("data/report.csv",  fileEncoding="UTF-8-BOM") %>% na.omit()
state.map <- map_data("state")
state.name <- state2abbr(state.map$region)
state.map <- state.map %>% mutate(state.name)

#Combined cities data to the map data. 
cities <- us.cities
crime.data$agency_jurisdiction <- gsub(",","",crime.data$agency_jurisdiction)
cities.crime <- left_join(cities, crime.data, by = c("name" = "agency_jurisdiction"))
state.map <- left_join(state.map, cities.crime, by = c("state.name" = "country.etc", "state.name" = "country.etc"))
server <- function(input, output){
   t <- reactive({
    type <- switch(input$type, 
                   homicides = "homicides",
                   rapes = "rapes",
                   assaults = "assaults",
                   robberies = "robberies",
                   ViolentCrimes = "violent_crimes")
  })
  
  #Drawing map based on the crime data depending on user's input year, and type of crime. 
  output$Map <- renderPlot({
    year.map <- state.map %>% select(state.name, t(), report_year, lat.x, long.x, lat.y, long.y, group)
    year.specific <- year.map %>% filter(report_year == input$year)
    NumberOfCrimes <- year.specific[[t()]]
    ggplot(data = year.specific) +
      geom_polygon(mapping = aes(x = long.x, y = lat.x, group = group), fill = "snow2") + 
      geom_point(aes(x = long.y, y = lat.y, size = NumberOfCrimes), alpha = .5) +
      scale_fill_brewer(palette = 14) +
      coord_quickmap() + 
      borders("state", xlim = c(-130, -60), ylim = c(20, 50)) +
      theme_bw() + 
      theme(panel.border = element_blank(), panel.grid.major = element_blank(),
                         panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"), 
            line = element_blank(),
            title = element_blank())
  })
}
