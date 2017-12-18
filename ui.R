library(shiny)
library(shinyjs)
library(shinydashboard)
library(shinyBS)
library(DT)
library(DiagrammeR)
library(googlesheets)
library(dplyr)

dashboardPage(
  
  dashboardHeader(title = "Gabriella Miller Kids First Data Tracker", titleWidth = "100%",
                  dropdownMenuOutput("messageMenu")),
                  # tags$li(a(href = 'mailto:ramanp@email.chop.edu',
                  #           icon("send-o"),
                  #           title = "Contact Us"),
                  #         class = "dropdown")),
  dashboardSidebar(disable = TRUE),
  dashboardBody(
    
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
    ),
    
    tags$script(HTML("$('body').addClass('fixed');")),
    
    div(style = "overflow-x: scroll"),
    
    fluidPage(
      fluidRow(
        box(title = "Data Tracker for GMKF", status = "warning", width = 9, collapsible = FALSE,
            collapsed = FALSE, solidHeader = FALSE, includeHTML("data/input.txt"), height = 200),
        box(title = "", status = "warning", width = 3, collapsible = FALSE, collapsed = FALSE, solidHeader = FALSE, height = 200,
            tags$a(href='https://d3b.center/kidsfirst/', target="_blank",
                   tags$img(src='Kids_First_Graphic_Horizontal_OL_FINAL.DRC.png', height = "100%", width = "100%"))
            ),
        box(title = 'Studies', status = 'danger', width = 12, height = 350, 
            dataTableOutput(outputId = "table", width = "auto", height = "auto")),
        bsTooltip(id = "table", title = "Click on row to see tracker", placement = "top", trigger = "hover", options = NULL),
        tabBox(title = '', id = "tabBox", selected = "Track Study", width = 12, height = 600, side = "left", 
               tabPanel(title = "Track Study", icon = icon("triangle-bottom", lib = "glyphicon"), grVizOutput(outputId = "indplot", width = "100%", height = 500),
                        actionButton("go", "Summary", align = "right")),
               bsModal("modalExample", "Summary of all studies", "go", size = "large",grVizOutput(outputId = "summplot", width = "100%", height = 500))
               # tabPanel(title = "Summary", icon = icon("triangle-bottom", lib = "glyphicon"), grVizOutput(outputId = "summplot", width = "100%", height = 500))
        )
      )
    )
  )
)
