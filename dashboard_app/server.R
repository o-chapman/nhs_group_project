server <- function(input, output) {
  
  library(tidyverse)
  library(sf)
  library(shiny)
  
  set.seed(122)
  histdata <- rnorm(500)
  
  output$plot1 <- renderPlot({
    data <- histdata[seq_len(input$slider)]
    hist(data)
    
    
  })
  
  
  
  # --------------------------REACTIVE MAP COMPONENTS---------------------------
  
  source("helpers.R")
  
  
  output$heatmap <- renderLeaflet({
    
    
  })
  
  
  # Make filters from input
  beds_geom_filtered <-ractive(
    beds_geom %>% 
    filter(specialty_name == "General Medicine") %>% 
    filter(quarter == "2021Q2")
  )
  
  # Generate colour palate based on filter domain.
  
  pal <- reactive(
    colorNumeric(
    palette = colorRampPalette(c('red', 'green'))(nrow(beds_geom_filtered())), 
    domain = beds_geom_filtered()$percentage_occupancy)
    )
  
  
  
}
