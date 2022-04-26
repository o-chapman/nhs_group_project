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
      distinct(hb, geometry) %>%
      right_join(diff_data_areas, by = "hb") %>% 
      select(hb, geometry, input$map_data) %>% 
      rename("value" = input$map_data)
  )

  # Generate colour palate based on filter domain.

  pal <- reactive(colorBin("YlOrRd", domain = beds_geom_filtered()$value, bins = nrow(beds_geom_filtered())))
 
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
                  label= ~ value)


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





}
