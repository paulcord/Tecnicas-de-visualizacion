library(shiny)
library(tidyverse)
library(MASS)

shinyServer(function(input, output) {
  # Widget imagen
  output$htmlpic <- renderUI({
    tags$img(src = "https://www.esri.com/arcgis-blog/wp-content/uploads/2018/03/sorry-we-just-cant-trust-you.png", # Clic derecho imagen internet -> Copiar direccion de la imagen 
             alt = "Data Joke", width = "826px", height = "465px") 
  })
  
  # Widget modelos
  
  # Selctores modelo Polinomial
  output$elementos <- renderUI(
    
    if (input$tipo == "Polinomial") {
      list(
        numericInput("n", "tamaño muestra", min = 1, value = 20), 
        numericInput("cor", "correlación", min = -1, max = 1, value = 0, step = 0.1),
        actionButton("muestra", "Nueva muestra"),
        numericInput("orden", "orden polinomial", min = 1, value = 1, step = 1),
        actionButton("modelo", "Generar modelo")
      )
    }
    
    # Selectores modelo Kmeans
    else {
      list(
        textInput("name", label = "Nombre del modelo"),
        selectInput("varx", "Variable X", choices = c("Sepal.Length",
                                                      "Sepal.Width",
                                                      "Petal.Length",
                                                      "Petal.Width")),
        selectInput("vary", "Variable Y", choices = c("Sepal.Length",
                                                      "Sepal.Width",
                                                      "Petal.Length",
                                                      "Petal.Width")),
        numericInput("nclusters", label = "# Clusters", min = 1, step = 1, value = 2),
        actionButton("run", "Run")
      )
    }
  )
  
  # Modelo Polinomial
  mySample <- eventReactive(
    input$muestra, 
    {
      datos <- as.data.frame(mvrnorm(input$n, c(0,0),
                                     Sigma = matrix(c(1, input$cor, input$cor, 1), nrow = 2)))
      colnames(datos) <- c("x", "y")
      datos
    })
  
  myFormula <- reactive({
    if (input$modelo) { 
      orden <- isolate(input$orden)
      formula(y ~ poly(x, orden))
    }
  })
  
  # Modelo Kmeans
  miModelo <- reactive({
    input$run
    iris %>% 
      select_(isolate(input$varx), isolate(input$vary)) %>%  
      kmeans(isolate(input$nclusters))
    
  })
  
  
  # Grafica ambos modelos (polinomial y kmeans)
    output$grafico <- renderUI({
     
      if (input$tipo == "Polinomial") {
        datos <- mySample()
        formu <- myFormula()
      
        grafica <- ggplot(datos, aes(x = x, y = y)) + 
        geom_point()
      
        output$poly <- renderPlot({
        grafica
        })
      
      if (!is.null(formu))
        output$poly <- renderPlot({
          grafica + geom_smooth(method = "lm", formula = formu)
        })
      
      plotOutput("poly")
        
      }
      
      else  {
        varx_iso <- isolate(input$varx)
        vary_iso <- isolate(input$vary)
        grafica1 <- ggplot(iris, aes_string(x = varx_iso, 
                                            y = vary_iso, 
                                            color = as.factor(miModelo()$cluster))) + geom_point()
        output$kmeans <- renderPlot({
          grafica1
        })
        
        plotOutput("kmeans")
      }
    })
    
})

