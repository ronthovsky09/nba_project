#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(nbastatR)
library(plotly)
season2020 <- bref_players_stats(season = 2020)
season2020 <- season2020[season2020[, 'fg3aTotals'] >= 150,]
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    fit1 <- lm(formula = ratioBPM~pctFG3, data=season2020)
    model1pred <- reactive ({
        fgperc <- input$pct3/100
        predict(fit1, newdata = data.frame(pctFG3 = fgperc))
    })
    output$lineGraph <- renderPlotly({
        fig<- plot_ly(x = season2020$pctFG3, y = season2020$ratioBPM, xlab = "3Pt Percentage", ylab = "Ratio BPM", color = season2020$groupPosition, size = season2020$fg3aTotals)%>%
            add_markers(y=season2020$rationBPM) %>%
            add_lines(x = season2020$pctFG3, y = fitted(fit1))%>%
            add_trace(text = season2020$namePlayer, hovertemplate=paste('Player: %{text}', 
                                          '<br>3PT Pct: %{x}<br>', 
                                          'RatioBPM Pct: %{y}'))
        fig <- fig %>% add_markers(x=input$pct3/100, y=data.frame(predict(fit1,newdata = data.frame(pctFG3 = input$pct3/100)))[1,1], marker = list(color = 'black'))
        fig
})
    output$pred1 <- renderText({
        model1pred()
    })
    output$summary <- renderPrint({
        summary(fit1)
    })
}
)
