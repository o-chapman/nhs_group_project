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
      filter(specialty_name == "General Medicine") %>%
      filter(quarter == "2021Q2")
  )

  # Generate colour palate based on filter domain.

  pal <- reactive(
    colorNumeric(
      palette = colorRampPalette(c('red', 'blue'))(nrow(beds_geom_filtered())),
      domain = beds_geom_filtered()$percentage_occupancy)
  )

  output$heatmap <- renderLeaflet({
    beds_geom_filtered() %>%
      st_as_sf() %>%
      leaflet() %>% 
      addProviderTiles("CartoDB.Positron",
                       options= providerTileOptions(opacity = 0.99)) %>%
      addPolygons(fillColor = ~ pal()(beds_geom_filtered()$percentage_occupancy),
                  weight = 1,
                  opacity = 1,
                  color =  ~ pal()(beds_geom_filtered()$percentage_occupancy),
                  fillOpacity = 0.8,
                  label=~paste(name))

  })

  output$hospital_plot <- renderLeaflet({
    hospitals %>%
      leaflet() %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      # addProviderTiles(providers$CartoDB.Voyager) %>%
      addCircleMarkers(lng = ~x,
                       lat = ~y,
                       color = "purple",
                       fillOpacity = 0.5,
                       radius = 2,
                       popup = ~paste0(location_name, "<br>", address_line, "<br>",
                                       postcode))
                       
  })





}
