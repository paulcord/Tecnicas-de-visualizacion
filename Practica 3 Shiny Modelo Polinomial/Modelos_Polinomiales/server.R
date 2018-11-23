library(shiny)
library(MASS)

shinyServer(function(input, output) {
  
  df <- reactiveValues()
  
  observeEvent(input$run1, {
    data = as.data.frame(mvrnorm(n = input$size, mu = c(0, 0), 
                   Sigma = matrix(c(1, input$corr, input$corr, 1), nrow = 2), 
                   empirical = TRUE))
    df$datos <- data
  })
  
  observeEvent(input$run2, {
    polymodel <- lm(formula = df$datos[,2] ~ poly(x = df$datos[,1], degree = input$poli))
    # Grafica de salida
    df$modelos <- 
      ggplot(df$datos, aes(x = df$datos[,1], y = df$datos[,2])) +
      geom_point() + 
      xlab('X') + 
      ylab('Y') + 
      geom_line(aes(y = fitted(polymodel)))
  })
  
  output$Dispersion <- renderPlot({
    df$modelos
  })
    
})