server <- function(input, output) {



  set.seed(122)
  histdata <- rnorm(500)

  output$plot1 <- renderPlot({
    data <- histdata[seq_len(input$slider)]
    hist(data)


  })



  # --------------------------REACTIVE MAP COMPONENTS---------------------------

  source("helpers.R")


  # Make filters from input
  beds_geom_filtered <-reactive(
    beds_geom %>%
      distinct(hb, geometry, name.x) %>%
      right_join(diff_data_areas, by = "hb") %>% 
      select(hb, geometry, input$map_data, name.x) %>% 
      rename("value" = input$map_data)
  )

  # Generate colour palate based on filter domain.

  rc1 <- reactive(colorRampPalette(colors = c("blue3", "yellow"))(sum(beds_geom_filtered()$value < 0)))
  
  
  rc2 <- reactive(colorRampPalette(colors = c("yellow", "red3"))(sum(beds_geom_filtered()$value >= 0)))
  
  rampcols <- reactive(c(rc1(), rc2()))
  
  pal <- reactive(colorBin(rampcols(), domain = beds_geom_filtered()$value, bins = nrow(beds_geom_filtered())))
 
  output$heatmap <- renderLeaflet({
    beds_geom_filtered() %>%
      st_as_sf() %>%
      leaflet() %>% 
      addProviderTiles("CartoDB.Positron",
                       options= providerTileOptions(opacity = 0.99)) %>%
      addPolygons(fillColor = ~ pal()(value),
                  weight = 1,
                  opacity = 1,
                  color =  ~ value,
                  fillOpacity = 0.8,
                  label= ~ paste(name.x, ":", value)) %>% 
      addLegend(position = "bottomright", pal = pal(), values = beds_geom_filtered()$value,
                opacity = 1)


  })

  output$hospital_plot <- renderLeaflet({
    hospitals %>%
      filter(location %in% diff_data_hospitals$hospital_code) %>% 
      leaflet() %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      # addProviderTiles(providers$CartoDB.Voyager) %>%
      addCircleMarkers(lng = ~x,
                       lat = ~y,
                       color = "purple",
                       fillOpacity = 0.5,
                       radius = 5,
                       popup = ~paste0(location_name, "<br>", address_line, "<br>",
                                       postcode))
                       
  })





  
  #---------------------------MAP DETAIL PLOT COMPONENtS
  
  detailmap_pre <- reactive(
    beds_geom_filtered %>% 
      ggplot(aes(x = name.x, y = value)) +
      geom_col()
    
  )
  
  output$detailmap <- renderPlotly({
    ggplotly(detailmap_pre())
    
  })
}

