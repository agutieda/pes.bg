#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$distPlot <- renderPlot({

        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white')

    })
    output$output2=renderText({
        as.character(input$alink)
        
    })
    output$ActionB=renderText({
        as.character(input$action)
        
    })
    output$output3=renderText({
        as.character(input$`hola nene`)
        
    })
    output$output4=renderText({
        as.character(input$chkb)
        
    })
    output$output5=renderText({
        as.character(input$Fecha)
        
    })
    output$output6=renderText({
        as.character(input$rangeDate)
        
    })
    output$output7=renderText({
        as.character(input$numero)
        
    })
    
    

})
