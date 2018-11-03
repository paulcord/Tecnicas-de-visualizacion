# Practica 2 Dispersion - MTCARS #

library(ggplot2)
data(mtcars)
str(mtcars)

ggplot(mtcars) +
  geom_point(aes(x= mtcars$mpg, y=mtcars$disp)) +
  facet_grid(cyl~.)

noquote(names(mtcars))

library(shiny)


ui <- fluidPage(
  titlePanel('Gráfico de dispersión - Base de Datos Mtcars'),
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = 'X', 
                  label = 'X Variable', 
                  choices = names(mtcars),
                  multiple = TRUE,
                  selected = 'mpg'
                  ),
      selectInput(inputId = 'Y', 
                  label = 'Y Variable', 
                  choices = names(mtcars),
                  multiple = TRUE,
                  selected = 'disp'
                  ),
      checkboxGroupInput(inputId = 'check', 
                        label = 'Select Facet',
                        choices = names(mtcars),
                        selected = 'cyl'
                        )
      ),
    
    mainPanel(
      plotOutput('Dispersion')
    )
  )
)

server <- function(input, output) {
  output$Dispersion <- 
    renderPlot(
    ggplot(mtcars, aes_string(x= input$X, y=input$Y)) +
      geom_point() +
      facet_grid(input$check)
    )
}

shinyApp(ui, server)