#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Old Faithful Geyser Data"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30),
            actionButton("action",label="accion"),hr(), # agregas un boton de accion , todos estos botones deben programarse en el server
            actionLink("alink",label="Click me"), # agregas un boton para un enlace , este boton debe agregarse en el server
            checkboxGroupInput("hola nene",label="choose:",choices = c("tutti","Frutti","hola","adios")),hr(),# permite seleccionar multiples agrupados te devuelve un vector de varias opciones
            checkboxInput("chkb",label = "Acepto" ),hr(), # verdadero o falso da dos opciones para un input
           # dateInput("Fecha","Seleccione una fecha",value = Sys.Date(),min=Sys.Date()-15,max=Sys.date()+3),hr(),
            dateRangeInput("rangeDate","Seleccione Rango"),hr(),
           numericInput("numero","cuantos steps",value=3,min=0,max=10,step=0.1),
           submitButton("refresh")
            
            
        ),
  

        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("distPlot"),
            textOutput("ActionB"),
            textOutput("output2"),
            textOutput("output3"),
            textOutput("output4"),
            textOutput("output5"),
            textOutput("output6"),
            textOutput("output7"),
        )
    )
))
