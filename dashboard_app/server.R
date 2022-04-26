server <- function(input, output) {


 #--------- OVERVIEW TAB ------------

  output$overview_beds_plot <- renderPlot({

    beds_season_subset %>%
      filter(year %in% input$year_input) %>%
      ggplot() +
      aes(x = date, y = avg_daily_beds_perc, label = str_c(round(avg_daily_beds_perc), "%")) +
      geom_text(nudge_y = 1.2, alpha = 0.8) +
      geom_col(fill = "turquoise", alpha = 0.8) +
      coord_cartesian(ylim = c(60, 80)) +
      labs(x = "") +
      theme_minimal()
  })

  output$overview_admissions_plot <- renderPlot({

    admissions_dt %>%
      filter(year %in% input$year_input) %>%
      ggplot() +
      aes(x = date, y = avg_admissions_by_week) +
      geom_line(color = "steelblue") +
      winter_shading[1] +
      winter_shading[2] +
      winter_shading[3] +
      scale_x_date(name = "",
                   limits = c(as.Date("2020-01-01", "%Y-%m-%d"), as.Date("2022-02-20", "%Y-%m-%d")),
                   date_breaks = "3 months",
                   date_minor_breaks = "1 month",
                   date_labels = "%b %y") +
      labs(y = "Average Admissions(weekly)") +
      theme_minimal()
  })

  output$overview_los_plot <- renderPlot({

    ggplotly(admissions_dt %>%
               ggplot() +
               aes(x = date, y = avg_admissions_by_week) +
               geom_line(color = "steelblue") +
               scale_x_date(name = "", limits = c(as.Date("2020-01-01", "%Y-%m-%d"), as.Date("2022-02-20", "%Y-%m-%d")), date_breaks = "3 months",
                            date_minor_breaks = "1 month", date_labels = "%b %y") +
               labs(y = "Average Admissions(weekly)") +
               theme_minimal()
    )

  })

  output$overview_deaths_plot <- renderPlot({

    ggplotly(admissions_dt %>%
               ggplot() +
               aes(x = date, y = avg_admissions_by_week) +
               geom_line(color = "steelblue") +
               scale_x_date(name = "", limits = c(as.Date("2020-01-01", "%Y-%m-%d"), as.Date("2022-02-20", "%Y-%m-%d")), date_breaks = "3 months",
                            date_minor_breaks = "1 month", date_labels = "%b %y") +
               labs(y = "Average Admissions(weekly)") +
               theme_minimal()
    )



  set.seed(122)
  histdata <- rnorm(500)

  output$plot1 <- renderPlot({
    data <- histdata[seq_len(input$slider)]
    hist(data)


  })



  # ----------------------GEOGRAPHIC TAB---------------------------

  source("helpers.R")


  # Make filters from input
  beds_geom_filtered <-reactive(
    beds_geom %>%
      distinct(hb, geometry, name) %>%
      right_join(diff_data_areas, by = "hb") %>%
      select(hb, geometry, input$map_data, name) %>%
      rename("value" = input$map_data)
  )


  hospitals_filtered <-reactive(
    hospitals %>%
      filter(location %in% diff_data_hospitals$hospital_code) %>%
      distinct(location, location_name, x, y) %>%
      rename("hospital_code" = location) %>%
      full_join(diff_data_hospitals, by = "hospital_code") %>%
      rename("winter_mortality_increase" = winter_deaths_increase) %>%
      select(location_name, x, y, input$map_data, hospital_code) %>%
      rename("value" = input$map_data)
  )

  # Generate colour palate based on filter domain.

  rc1 <- reactive(colorRampPalette(colors = c("green2", "yellow"))(sum(beds_geom_filtered()$value < 0)))


  rc2 <- reactive(colorRampPalette(colors = c("yellow", "red3"))(sum(beds_geom_filtered()$value >= 0)))


  rampcols <- reactive(c(rc1(), rc2()))

  rc3 <- reactive(colorRampPalette(colors = c("green2", "yellow"))(sum(hospitals_filtered()$value < 0)))


  rc4 <- reactive(colorRampPalette(colors = c("yellow", "red3"))(sum(hospitals_filtered()$value >= 0)))


  rampcols2 <- reactive(c(rc3(), rc4()))

  pal <- reactive(
    if (input$geotabs == "area") {


      (colorBin(rampcols(), domain = beds_geom_filtered()$value, bins = nrow(beds_geom_filtered())))

    } else {


      (colorBin(rampcols2(), domain = hospitals_filtered()$value, bins = nrow(hospitals_filtered())))
    }

  )


  title_text <- reactive( if (input$geotabs == "area") {
    paste("Regional Change Per 10,000 People in Winter")
  } else {
    paste("Change Per Hospital in Winter")
  }
  )

  output$title <- renderText(title_text())



  output$heatmap <- renderLeaflet({
    beds_geom_filtered() %>%
      st_as_sf() %>%
      leaflet() %>%
      addProviderTiles("CartoDB.Positron",
                       options= providerTileOptions(opacity = 0.99)) %>%
      addPolygons(fillColor = ~ pal()(value),
                  weight = 1,
                  opacity = 1,
                  color =  ~ pal()(value),
                  fillOpacity = 0.8,
                  label= ~ paste(name, ":", value)) %>%
      addLegend(position = "bottomright", pal = pal(), values = beds_geom_filtered()$value,
                opacity = 1)


})








  output$hospital_plot <- renderLeaflet({
    hospitals_filtered() %>%
      leaflet() %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      addCircleMarkers(lng = ~x,
                       lat = ~y,
                       color = ~ pal()(value),
                       fillOpacity = 0.5,
                       radius = ~ sqrt(abs(value)),
                       popup = ~paste0(location_name),
                       label= ~ paste(location_name, ":", value))



  })



}





  #---------------------------MAP DETAIL PLOT COMPONENtS






  # --------------------------DEMOGRAPHIC TAB -----
  }
