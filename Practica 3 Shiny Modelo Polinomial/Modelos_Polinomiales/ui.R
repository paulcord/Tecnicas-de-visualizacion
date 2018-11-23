# Modelos polinomiales

library(ggplot2)
library(shiny)

shinyUI(fluidPage(
  titlePanel("Modelos Polinomiales"),
  sidebarLayout(
    sidebarPanel(
      numericInput('size', 'Tamaño muestra', 
                   value = 3, 
                   min = 3
                   ),
      numericInput('corr', 'Correlación', 
                   value = 0.1, 
                   min = 0.1,
                   max = 1,
                   step = 0.1
                   ),
      actionButton('run1', 'Generar muestra'),
      numericInput('poli', 'Orden Polinómico', 
                   value = 1, 
                   min = 1
                   ),
      actionButton('run2', 'Añadir modelo')
    ),
    
    mainPanel(
      plotOutput(
        'Dispersion'
      )
    )
  )
))
