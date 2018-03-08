# load necessary libraries
library("shiny")
library("dplyr")
library("ggplot2")
library("plotly")
#library(leaflet)
library("stringr")
library("openintro")
library("maps")

# set up and structure data
crime.data <- read.csv("data/report.csv", stringsAsFactors = FALSE, fileEncoding = "UTF-8-BOM")
years <- unique(crime.data$report_year)
crimeTypes <- c("Total Crimes", "Homicides", "rapes", "assaults", "robberies")


shinyServer(function(input, output){
  # section 1: USA map with city crime numbers
  
  
  
  
  
  # section 2: overall violent crime patterns
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
  
  
  # Section 3: most common crimes committed
  # reactive variables for input year and city
  YearReact <- reactive({
    return(input$yearChoice)
  })
  
  CityReact <- reactive({
    return(input$cityChoice)
  })
  # render bar graph of violence type and values for given year and city
  output$barplot <- renderPlotly({
    cityData <- crime.data[grep(CityReact(), crime.data$agency_jurisdiction),] 
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
  # renders line graph for all years for given city
  output$lineplot <- renderPlotly({
    cityData <- crime.data[grep(CityReact(), crime.data$agency_jurisdiction),] 
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
  
  # Section 4: map visual of user input year and type of crime
  # set up different data sets
  cities <- us.cities
  crimes.data <- crime.data %>% na.omit()
  state.map <- map_data("state")
  state.name <- state2abbr(state.map$region)
  state.map <- state.map %>% mutate(state.name)
  
  # combine data sets
  crimes.data$agency_jurisdiction <- gsub(",","", crimes.data$agency_jurisdiction)
  cities.crime <- left_join(cities, crimes.data, by = c("name" = "agency_jurisdiction"))
  state.map <- left_join(state.map, cities.crime, by = c("state.name" = "country.etc", "state.name" = "country.etc"))
  # declare input as reactive var
  t <- reactive({
      type <- switch(input$maptype, 
                     homicides = "homicides",
                     rapes = "rapes",
                     assaults = "assaults",
                     robberies = "robberies",
                     ViolentCrimes = "violent_crimes")
  })
  # plot map visual with input year and crime type 
  output$mapb <- renderPlot({
    year.map <- state.map %>% select(state.name, t(), report_year, lat.x, long.x, lat.y, long.y, group)
    year.specific <- year.map %>% filter(report_year == input$mapyear)
    NumberOfCrimes <- year.specific[[t()]]
    
    # # plot map
    # ggplot(data = world.new, aes(x = long, y = lat)) +
    #   geom_polygon(aes(group = group, fill = KT),
    #                color = "black", size = 0.25) +
    #   labs(title = paste("Below is a choropleth map of CO2 emissions above",
    #                      input$kt, "for the year", input$year, "."),
    #        x = "Longitude",
    #        y = "Latitude") + 
    #   scale_fill_distiller(name="Emission(in kt)", palette = "RdPu") 
    # 
    
    
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
  
  # Section 5: Comparing Robberies and Rapes
  c <- reactive({
  compare.data <- crime.data %>%
    filter(report_year == input$year10)
  })
  #create scatter plot 
  output$robrap <- renderPlotly({
    correct.data <- c()
    plot_ly(correct.data,
            x = ~robberies_percapita,
            y = ~rapes_percapita,
            type = "scatter",
            mode = "markers",
            size = ~population,
            color = ~crimes_percapita,
            hoverinfo = "text",
            name = "pop",
            text = ~paste("City and State: ", agency_jurisdiction,
                          "</br>Year: ",  report_year,
                          "</br>Population: ", population,
                          "</br>Violent Crime Count: ", violent_crimes,
                          "</br>Robberies Per Capita: ", robberies_percapita,
                          "</br>Rapes Per Capita: ", rapes_percapita
             )) %>%
      # all titles
      layout(title = paste("<b>", input$year10, "Robberies versus Rapes per Capita</b>"),
             xaxis = list(title = "Robberies Per Capita"),
             yaxis = list(title = "Rapes per Capita")) %>%
      # produce arrow markets with label for each city, state data point
      add_annotations(x = correct.data$robberies_percapita,
                      y = correct.data$rapes_percapita,
                      text = correct.data$agency_jurisdiction,
                      xref = "x",
                      yref = "y",
                      showarrow = TRUE,
                      arrowhead = 1,
                      arrowsize = .4,
                      ax = 20,
                      ay = -20,
                      opacity = 0.8,
                      font = list(family = "sans serif",
                        size = 12)
      )
    })
    
  
})
