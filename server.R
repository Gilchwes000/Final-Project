library("ggplot2")
library(dplyr)
library("maps")
library(shiny)
source("spatial_utils.R")
#Package to abbreviate the states to 2 letters. 
#install.packages("openintro")
library("openintro")
crime.data <- read.csv("data/report.csv",  fileEncoding="UTF-8-BOM")
state.map <- map_data("state")
View(crime.data)
crime.data$agency_code <- substr(crime.data$agency_code, 0, 2)
state.name <- state2abbr(state.map$region)
state.map <- state.map %>% mutate(state.name)
data.state.map <- left_join(state.map, crime.data, by = c("state.name" = "agency_code"))

server <- function(input, output){
  
  #Drawing map based on the crime data depending on user's input year. 
  output$Map <- renderPlot({
    year.map <- data.state.map %>% select(state.name, violent_crimes, report_year, lat, long, group)
    year.specific <- year.map %>% filter(report_year == input$year)
    year.specific$violent_crimes <- cut(year.specific$violent_crimes, breaks = c(NA, 0, 5000, 10000, 15000, 20000, 30000, 50000,
                                                           70000, 100000, 200000), 
                         labels = c("0 ~ 5000", "5000 ~ 10000", "10000 ~ 15000", 
                                    "15000 ~ 20000", "20000 ~ 30000", "30000 ~ 50000", "50000 ~ 70000", 
                                    "70000 ~ 100000", "100000 and more")
    )
    ggplot(data = year.specific) +
      geom_polygon(mapping = aes(x = long, y = lat, group = group, fill = year.specific$violent_crimes)) + 
      scale_fill_brewer(palette = 14) +
      coord_quickmap() + 
      borders("state", xlim = c(-130, -60), ylim = c(20, 50)) +
      theme_bw() + 
      theme(panel.border = element_blank(), panel.grid.major = element_blank(),
                         panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))
  })
}
