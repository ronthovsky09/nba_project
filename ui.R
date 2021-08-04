#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Does Higher 3 Point Percentage Affect +/-"),
    sidebarLayout(
        sidebarPanel(
            sliderInput("pct3",
                        "3 Point Percentage",
                        min = 10,
                        max = 60,
                        value = .25)
        ),

        # Show a plot of the generated distribution
        mainPanel(plotlyOutput('lineGraph'), 
                  h3('Predicted Plus Minus:'),
                  textOutput("pred1"),
                  textOutput('summary'))
    )
))
