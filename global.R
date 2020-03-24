# Chapter 0. Load packages ----
library(shiny)
library(shinyWidgets)
library(bs4Dash)
library(plotly)
library(echarts4r)
library(shinyTime)
library(kableExtra)
library(DT)
library(imager)
library(scales)
library(shinyjs)
library(dygraphs)
library(shinyalert)
library(lattice)
library(shinycssloaders)
library(openxlsx)


# Chapter 1. Probability of default ----
pd_tab <- bs4TabItem(tabName = "pd",
                     fluidPage(
                       useShinyalert(),
                       useShinyjs(),
                       sidebarLayout(
                         position = "right",
                         
                         
                         sidebarPanel =  sidebarPanel(
                           width = 2,
                           h6(icon("wrench"), strong("Customizations")),
                           hr(),
                           fileInput("pd_input", label = "Choose file", accept = c(".csv", ".xlsx")),
                           selectInput("delay", "Delay in defaults",
                                       choices = c("No delay" = 1, "3 mons, 6 mons, 9 mons" = 2, "between one to twelve months" = 3 )
                                       ),
                           uiOutput("prob_bttn"),
                           numericInput("itr", "No of simulations", value = 1000, max = 10000, step = 500),
                           selectInput("bylvl", "Default rate level", choices = c("Monthly", "Yearly")),
                           sliderInput("prob", "probabilities", value = c(0,0.5,1), min = 0, max = 1)
                           
                         ),
                         
                         
                         mainPanel = mainPanel(width = 10,
                                               )
                       )
                     ))
                  
# Chapter 2. Loss given default ----
lgd_tab <- bs4TabItem(tabName = "lgd")

# Chapter 3. Exposure at default ----
ead_tab <-  bs4TabItem(tabName = "ead")

# Chapter 4. User guide
guide_tab <- bs4TabItem(tabName = "user_guide")



