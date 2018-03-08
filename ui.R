library("shiny")
library("dplyr")
library("ggplot2")
data <- read.csv("data/report.csv", stringsAsFactors = FALSE, fileEncoding = "UTF-8-BOM")
years <- unique(data$report_year)
city <- data$agency_jurisdiction[1:69]
crimeTypes <- c("Total Crimes", "Homicides", "rapes", "assaults", "robberies")

ui <- fluidPage(
  navbarPage("Violent Crime Analyzation",
             tabPanel("Overview", 
                      h2("Project Summary"), 
                      p("The data presented and analysed here goes over the violent crimes from the last 40 years. The data can be manipulated by year 
                      and city to view changes in crime rates, safest locations and other valuable data and trends based upon the FBI’s data. This information is publically 
                      available but is near impossible to analyse without use of computers and visual aids (which we have provided), because of the sheer amount of data. The 
                      tabs at the top of the screen will guide users through the majority of the information present in a neat and organized fashion."),
                      br(),
                      h2("Data"), 
                      p("   The data set our group is choosing to analyze contains 40 years worth of analyzed FBI data on violent crimes. 
                        The reason this data is not from the FBI themselves but instead The Marshall Project is because the FBI is already 
                        in charge of collecting data from over 18,000 police agencies and to insure consistency over such a large frame is out of scope. 
                        The Marshall Project, a nonprofit online journalism organization saw this as an opportunity and has worked to produce an analyzed
                        report for 68 police jurisdictions each with a population of at least 250,000. The crimes which the FBI classifies violent 
                        crimes and therefore collected data on were: rape, homicide, robbery, or assault. Each of these are listed along with a per
                        capita value for each of the 68 police jurisdictions. We downloaded the data itself from kaggle: 
                        https://www.kaggle.com/marshallproject/crime-rates/data"),
                      br(),
                      h2("Questions:"),
                      tags$ol(
                        tags$li("Does the stereotypical view that due to our current level of media consumption violence has risen within the population hold 
                           true when compared to this national database?"),
                        tags$li("For families looking into large cities, what would be the safest option given current rates of crimes and trends of crime in 
                           the past few years."),
                        tags$li("Do larger cities have a higher per capita crime rate than smaller cities? "),
                        tags$li("What type of crime is most common, and does that change over the years or from city to city? If the answer does change, 
                           why is that and does population affect those changes?")
                      ),
                      br(),
                      h2("Why important"),
                      p("The importance of everyone's safety cannot be overstated and is a basic right of everyone, with the large amount of crimes and 
                        shootings being reported nationwide people are feeling less safe, the goal of this analysis is to show people where the majority 
                        of crimes are taking place, as well as trends for crime rates in large cities. The type of violent crimes being committed are also 
                        of importance as some are targeted more towards a particular gender or demographic. The rates and trends are some of the most 
                        important aspects of our analysis as they show not only current rates, but where rates are projected to be in the years to come."),
                      br(),
                      h2("Contributors"),
                      tags$ul(
                        tags$li("Wesley Gilchrist"),
                        tags$li("Matthew Vogt"),
                        tags$li("Diana Dominic"),
                        tags$li("MinSeok Choi")
                      )
                      ),
             tabPanel("Violent Crime Trend", "bb"),
             tabPanel("Safest Cities", "cc"),
             tabPanel("Population Effect on Crimes", "dd"),
             tabPanel("Most Common Crimes", 
                      h2("Crime rates over the years (All Data is Per Capita)"),
                      sidebarPanel(  
                        selectizeInput("yearChoice", "Choose a year:", choices = years),
                        selectizeInput("cityChoice", "Choose a City:", choices = city),
                        plotlyOutput("plot2")
                      ),
                      mainPanel(
                        plotlyOutput("plot"),
                        verbatimTextOutput("extraInfo")         
                        )
                      
  ), 
  tags$head(tags$style("p, ul, ol{
                       font-size: 16px;
                       }
                       body {
                        background-color: #933A16;
                        color: black;
                       }"
                      )
            )
  )
)