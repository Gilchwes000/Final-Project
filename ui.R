#Group AB5
#info201 Final Project

# load necessary libraries
library("shiny")
library("plotly")
library("shinythemes")
library("ggplot2")

# set up and structure data
crime.data <- read.csv("data/report.csv", stringsAsFactors = FALSE, fileEncoding = "UTF-8-BOM")
cities <- unique(crime.data$agency_jurisdiction)
years <- unique(crime.data$report_year)
crimeTypes <- c("Total Crimes", "Homicides", "rapes", "assaults", "robberies")

ui <- fluidPage(
  theme = shinytheme('flatly'),
  navbarPage(title = HTML("<em>Violent Crimes in American Cities</em>"),
             
             # Section 1: Summary Page
             tabPanel("Home",
                      fluidRow(
                         column(width = 12, img(src="pic.png", style = "display: block; margin-left: auto; margin-right: auto; width: 100%;"))
                      ),
                      
                      fluidRow(
                        column(width = 4, offset = 1, 
                               h2(HTML("<strong>Overview</strong>")), 
                        p("The data presented and analyzed in our project covers violent crimes across America from the last 40 years.   With the data
                        separated by each major city, we can filter by year and specific crimes to demonstrate overall trends in the American violent
                        crime rates.  With further analysis, we can determine the safest cities, and relationships between the various violent crime 
                        from this FBI dataset.  The information from this data set is available on the web, but due to the sheer amount of data, is 
                        near impossible to analyze without the use of computers and visual aids.  Thus, we have provided a neat and organized visual 
                        presentation of the data separated by tabs."),
                        br(),
                        h2(HTML("<strong>The Data</strong>")), 
                        p("The Marshall Project has put together this data contain forty years' worth of data on four major crimes classified violent.
                          The FBI collects this data through a voluntary program, in which more than 18,000 separate police agencies from different 
                          jurisdictions opt in to share data.  This process of data collection is not only inconsistent and out-of-date, but also extremely 
                          slow to produce.  As a result, The Marshall Project, a non-profit online journalism organization sought to put together a better 
                          data set, ultimately narrowing down on four major violet crimes (homicide, rape, robbery, and assault) in 68 police jurisdictions
                          with populations of 250,000 or greater.  We discovered this data set on Kaggle.")
                        
                        ),
                        column(6, offset = 1,
                               h2(HTML("<strong>The Questions</strong>")),
                               tags$ol(
                                tags$li("Does the commonly-held belief based on popular media that violence has risen within our population hold true
                                when investigating the dataset?"),
                                tags$li("What type of crime is most common, and does that change over the years or from city to city? If the answer
                                does change, why is that and does population affect those changes?"),
                                tags$li("How do the four defined violent crimes relate to each other? If a city has a high rate of one, can we assume
                                a high rate for another as well?"),
                                tags$li("Where would be the safest places to move given current rates of crimes and trends of crime in the past few
                                years?  Do larger cities generally have a higher per capita crime rate than smaller cities?")
                               ),
                               br(),
                               h2(HTML("<strong>Significance</strong>")),
                        p("These crime statistics of various US cities are extremely significant to consider and understand, as the importance
                        of individual's safety cannot be stated and is a basic human right.  With large number of violent crimes being reported 
                        nationwide, people feel less safe in the different cities.  The goal of this analysis is to analyze and report where the
                        majority of crimes are taking place, the general trends across the years, and how different crimes relate to each other 
                        in the varying cities.  The types of crimes committed are just as significant as some are targeted towards people of a 
                        particular gender or demographic.  These visual presentations of the crime data set are crucial, as they not only show 
                        the current state of our cities in a visually pleasing way, but also imply project rates for the years to come.")
                      ))
                      ),
             
             
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
             
             # Section 4: Comparing Robberies and Homicides
             tabPanel("Comparing Crimes: Robbery and Homicide", 
                      h2("How Robberies and Homicides Relate Across America"),
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
                          plotlyOutput("robrap"),
                          h3("The animation visualizaing the counts of robberies and homicides committed not only plots
                            the relationship between the two crimes, but also clearly identifies the cities at the two extremes for each 
                             crime individually.  Additionally, the point sizes and colors indidicate overall crime rates. From the plot, in recent
                             years, Detroit has placed consistently in the high extremes for both robberies and homicides while oakland has high robberries, 
                             and New Orleans tends to have high homicides. As for the general trend, with the exception of the few cities with extreme
                             values, there is a positive relationship between robberies and homicides.  As the number of robberies increase in cities,
                             so do the number of homicides.")
                        )  
                      )
              ),
             
             # Section 5: Safest Cities Overall
             tabPanel("Safest Cities Overall", 
                      h2("Population Effect on City Crime Rates"),
                      br(),
                      sidebarPanel(
                        sliderInput("year3", h3("Select Year:"),
                                    min = 1975,
                                    max = 2014,
                                    step = 1,
                                    value = 2014,
                                    sep = "",
                                    animate = TRUE
                        )
                      ),
                      mainPanel(
                        plotOutput("citymap")),
                      h3("As the split graphs above show, the count of rapes and homicides commited stays constant across the varying populations
                         of the cities.  Assaults and Robberies, however, fluctuate quite frequently across the years, varying from both positive and
                         negative trends. Because assaults and robberies are the most frequent crimes in almost every city across the US, this fluctuation
                         is expected.  However, for a majority of the years, the trend leans positive.  Thus, from this FBI collected data, there is no
                         clear set pattern between populations and the various crime rates")),
             br(),
             hr(),
             p("INFO 201 | WINTER 2017 | Diana Dominic, Wesley Gilchrist, Matthew Vogt, MinSeok Choi", align = "center"),
             p("Link to ", a("GitHub Repository", href = "https://github.com/Gilchwes000/Final-Project"), align = "center")
  )
)