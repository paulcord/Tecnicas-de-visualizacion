#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

#Shyny iu (interfaz) los que se ve
#Shiny server (servidor) los comandos


#install.packages("shiny")
library(shiny)
library(ggplot2) #Para que se cargue la base cars

# Define UI for application that draws a histogram
ui <- fluidPage( #contenedor que alberga todo
   
   # Application title
   titlePanel("Old Faithful Geyser Data vs MPG Data"), #titulo (dentro de fluidPage)
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout( #Contenedor despues del título
      sidebarPanel( #Objeto 1 dentro del Layout
         sliderInput("bins", #nombre que se conecta con input de abajo
                     "Number of bins - Geyser:",
                     min = 1,
                     max = 50,
                     value = 30),
         sliderInput("bins1", #nombre que se conecta con input de abajo
                     "Number of bins - MPG:",
                     min = 1,
                     max = 10,
                     value = 4),
         checkboxInput("change", 
                       label = "See Faithful Geyser Data",
                       value = TRUE)
      ),
      
      # Show a plot of the generated distribution
      mainPanel( #Objeto 2 dentro del Layout
         plotOutput("distPlot") #clave que conceta con output de abajo
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) { #siempre tengo entradas y salidas 
   
   output$distPlot <- renderPlot({ #rendertext o lo q se quiera generar
      # generate bins based on input$bins from ui.R
      x     <- faithful[, 2] 
      bins  <- seq(min(x), max(x), length.out = input$bins + 1) #cada vez que cambie la entradas
      y     <- as.numeric(unlist(mpg[, 5])) # Se quito el tipo lista y se hizo numérica
      binsy <- seq(min(y), max(y), length.out = input$bins1 + 1)
      # draw the histogram with the specified number of bins
      if(input$change == TRUE){
        hist(x, breaks = bins,
             col = 'darkgray',
             border = 'white',
             xlab = 'Waiting time to next eruption',
             main = 'Old Faithful Geyser Data') 
      }
      else
        hist(y, breaks = binsy,
             col = 'darkgray',
             border = 'white',
             xlab = 'cyl',
             main = 'MPG Data')
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

