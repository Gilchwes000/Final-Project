library("shiny")
library(plotly)
crime.data <- read.csv("data/report.csv",  fileEncoding="UTF-8-BOM")
cities <- unique(crime.data$agency_jurisdiction)

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
             tabPanel("Violent Crime Trend", 
                      h2("Is violent crime in the US really on the rise?"),
                      br(),
                      sidebarLayout(
                        sidebarPanel(
                          p("A recent spike in the number of violent crimes along
                            with greater new coverage of such crimes has led to a majority of Americans believing
                            that crime is on the rise. This although is not a completely unusual trend, over the past 20 years
                            or so Americans have thought this, with the exception a time period between 1999 and 2001 (Gallup). 
                            ")
                          ),
                        mainPanel(
                          tags$img(src="http://content.gallup.com/origin/gallupinc/GallupSpaces/Production/Cms/POLL/wzvtbhtlxkgekbwdjg_fww.png",
                                   alt="US crime perception"),
                          p(tags$a(href="http://content.gallup.com/origin/gallupinc/GallupSpaces/Production/Cms/POLL/wzvtbhtlxkgekbwdjg_fww.png",
                                   "Graph"), "taken from Gallup.com")
                        )
                      ),
                      br(),
                      plotlyOutput("yearly.trend"),
                      br(),
                      p("Looking at the past 40 years worth of data on violent crimes, we can see that despite the very recent
                        increase, as a whole crime in America has decreased. This contrasts the misconception that crime is 
                        on the rise and we live in a more dangerous country than it was previously. Compared to the late 1980's
                        and early 1990's the amount of violent crime is drastically smaller. The small rise we have seen recently
                        pales in comparison to the rise in violent crime from 1985 to 1991. If you hover over the graph
                        it lists the year and that years per capita crime rate in the United States."),
                      br(),
                      sidebarPanel(
                        selectizeInput("city-select", "City", choices=cities, selected = cities[1])
                      ),
                      mainPanel(
                        plotlyOutput("yearly.trend.per.city")
                      ),
                      p("This graph shows the yearly per capita crime rate for a specific city. The selection box is searchable
                        and the graph has the same hover functionality as the prevoius graph.")
             ),
             tabPanel("Safest Cities", "cc"),
             tabPanel("Population Effect on Crimes", "dd"),
             tabPanel("Most Common Crimes", "dd")
  ), 
  tags$head(tags$style("p, ul, ol{
                       font-size: 18px;
                      }
                      label {
                        color: black;
                      }
                      
                       body, .well {
                        background-color: #47494d;
                        color: white;
                       }"
                      )
            )
  )