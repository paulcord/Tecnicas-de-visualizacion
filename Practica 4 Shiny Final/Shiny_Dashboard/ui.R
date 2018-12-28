library(shiny)
library(shinydashboard)
library(tidyverse)
library(MASS)

shinyUI(
  dashboardPage(
    dashboardHeader(
      title = "Ejercicio combinando prácticas kmeans / modelos polinomiales"
    ),
    dashboardSidebar(
      sidebarMenu(
        menuItem("GIF", tabName = "gif", icon = icon("camera", lib = "glyphicon")),
        menuItem("Modelo", tabName = "modelo", icon = icon("signal", lib = "glyphicon"))
      )
    ),
    dashboardBody(
      tabItems(
        tabItem(tabName = "gif", uiOutput("htmlpic")),
        tabItem(tabName = "modelo",
                fluidRow(
                  box(uiOutput("grafico")),
                  box(
                    selectInput("tipo", "Tipo de modelo", choices = c("Polinomial", "Kmeans")),
                    uiOutput("elementos")
                  )
                )
        )
      )
    )
  )
)

