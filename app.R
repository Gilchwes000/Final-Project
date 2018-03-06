#Operates the shiny application by sourcing server.R and ui.R
library("shiny")
source('ui.R')
source('server.R')
shinyApp(ui = ui, server = server)
