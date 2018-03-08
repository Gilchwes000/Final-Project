# load necessary libraries
library("shiny")
library("plotly")
library("shinythemes")
library("ggplot2")
library("leaflet")
#library("shinycssloaders)

#home  LEAFLETMAP    wes    mat    him   scatterspecific  

# set up and structure data
crime.data <- read.csv("data/report.csv", stringsAsFactors = FALSE, fileEncoding = "UTF-8-BOM")
cities <- unique(crime.data$agency_jurisdiction)
years <- unique(crime.data$report_year)
crimeTypes <- c("Total Crimes", "Homicides", "rapes", "assaults", "robberies")



ui <- fluidPage(
  theme = shinytheme('flatly'),
  navbarPage(title = HTML("<em>Violent Crimes Across America</em>"),
             
             tabPanel("Home",
                      #BANNER!!!!!!!! :)
                      # fluidRow(
                      #   column(width = 12, img(src="banner.png", style = "display: block; margin-left: auto; margin-right: auto; width: 100%;"))
                      # ),
                      h2("Project Overview"), 
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
                      h2("Significance"),
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
             
             # Section 1: Leaflet Interactive Map
             
             
             # Section 2: Overall Crime Trends
             tabPanel("Overall Crime Trends", 
                      h2("Violent Crime on the Rise?"),
                      br(),
                      sidebarLayout(
                        sidebarPanel(
                          h4("Increased media coverage of violent crimes today has led a majority of Americans to believe 
                            that overall crime is on the rise.  This recent understanding, however, is not so recent, as Americans 
                            have expresesed the same beliefs for almost the past twenty years, with the exception of the years from
                            1999 to 2001 (Gallup).")
                          ),
                        
                        # crime perception patterns
                        mainPanel(
                          tags$img(src="http://content.gallup.com/origin/gallupinc/GallupSpaces/Production/Cms/POLL/wzvtbhtlxkgekbwdjg_fww.png",
                                   alt="US crime perception"),
                          p(tags$a(href="http://content.gallup.com/origin/gallupinc/GallupSpaces/Production/Cms/POLL/wzvtbhtlxkgekbwdjg_fww.png",
                                   "Graph"), "taken from Gallup.com")
                        )
                          ),
                      br(),
                      
                      # yearly trends for overall USA data
                      plotlyOutput("yearly.trend"),
                      br(),
                      h3("Looking at the past 40 years worth of data on violent crimes, we can see that despite the very recent
                        increase, crime in America has decreased as a whole. This disproves the misconception that crime is 
                        on the rise and we live in an increasingly dangerous country. Compared to the late 1980's
                        and the early 1990's, the number of violent crimes committed is drastically smaller. The small rise we have
                        seen recently pales in comparison to the rise in violent crime from 1985 to 1991. Hover over the graph
                        to view a list of the year and the corresponding per capita crime rate for the US."),
                      br(),
                      
                      # display input city choices
                      sidebarPanel(
                        selectizeInput("city-select", "City", choices=cities, selected = cities[1])
                      ),
                      
                      # yearly trends by city
                      mainPanel(
                        plotlyOutput("yearly.trend.per.city")
                      ),
                      h3("This graph shows the yearly per capita crime rate for a specific city. The selection box is searchable
                        and the graph has the same hover functionality as the prevoius graph.")
                      ),
             
            
             # Section 3: Most Common Crimes
             tabPanel("Most Common Crimes", 
                      h2("Per Capita Crime Rates Across the Years"),
                      
                      # display input choices of year and city and produce plot
                      sidebarPanel(  
                        selectizeInput("yearChoice", "Choose a year:", choices = years),
                        selectizeInput("cityChoice", "Choose a City:", choices = cities),
                        plotlyOutput("lineplot")
                      ),
                      
                      # main panel with bar graph output and concluding text
                      mainPanel(
                        plotlyOutput("barplot"),
                        h3("The graph above shows the occurence levels of crimes in the selected city and year, easily displaying the most common crimes
                            for the selected inputs. As you scroll through the years and cities, the counts of the different types of crimes do not change
                            drastically, although some cities have drastic changes in levels of crime (see graph to the left). Assaults and roberies remain 
                            the two most common type of violent crime in america, where rape and homicide remain at a much lower rate. The majority of 
                            observed cities, as well as in the US overall, the rates of crime have gone down since the 80's and 90's.")
                      )
             ),
             
             # Section 4: Basic Map 
             tabPanel("US Map of Crime Data", 
                      sidebarLayout(
                        sidebarPanel(
                          sliderInput("mapyear",
                                      "Year Selection",
                                      value = 1975,
                                      min = 1975,
                                      max = 2014,
                                      sep = ""),
                          radioButtons("maptype", "Type of Crime:",
                                       c("Homicides" = "homicides",
                                         "Rapes" = "rapes",
                                         "Assaults" = "assaults",
                                         "Robberies" = "robberies",
                                         "ViolentCrimes" = "ViolentCrimes"
                                       ))
                        ),
                        mainPanel(
                          h2("Map Analyzation based on Violent Crime"),
                          p("This map visualization contains different types of crimes depedning on user's preferred year in each cities. 
                            As the dot of city gets bigger, that means the number of crimes gets higher. Dots represents the number of type 
                            of crimes.")
                          
                          ) 
                        ),
                      plotOutput("mapb"),
                      br(),
                      p("In the map, there is a trend overtime that cities by the coast have highest crime rate in United States. 
                        ")),
             
             
             
             
             
             # section 5: comparing robberies and rapes, but also with total crimes
             tabPanel("Comparing Crimes: Robberies and Rapes Across America", 
                      sidebarLayout(
                        
                        # display user input option
                        sidebarPanel(
                          sliderInput("year10", h3("Select Year:"),
                                  min = 1975,
                                  max = 2014,
                                  step = 1,
                                  value = 2014,
                                  sep = "",
                                  animate = TRUE
                          )
                        ),
                        
                        # display scatter plot
                        mainPanel(
                          plotlyOutput("robrap"))
                      ))
  )
  
  
  
  # tags$head(tags$style("p, ul, ol{
  #                      font-size: 16px;
  #                      }
  #                      body {
  #                       background-color: #3685B5;
  #                       color: black;
  #                      }"
  #                     )
  #           )
  )