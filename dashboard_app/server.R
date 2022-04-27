server <- function(input, output) {

  #--------- OVERVIEW TAB ------------


  admissions_dt_react <- reactive({

    admissions_dt %>%
      filter(year %in% input$year_input)

  })
  
  overview_title <- reactive( if (input$tabbox_id == "admissions") {
    paste("Acute Admissions by Month")
    
  }
  else if (input$tabbox_id == "beds") {
    paste("Quarterly Bed Capacity")
  } else {
    paste("Quarterly Mean Length of Stay")
  }
  )
  
  output$title_overview <- renderText(overview_title())
  
  ## PLOTS

  output$overview_admissions_plot <- renderPlot({

    validate(
      need(input$year_input, "Please tick a year above")
    )
    admissions_dt_react() %>%
      ggplot() +
      aes(x = date, y = avg_admissions_by_week) +
      geom_line(color = "#605CA8", size = 1.5) +
      winter_shading[1] +
      winter_shading[2] +
      scale_x_date(name = "",
                   limits = c(min(admissions_dt_react()$date) - days(7), max(admissions_dt_react()$date) + days(7)),
                   date_breaks = "3 months",
                   date_minor_breaks = "1 month",
                   date_labels = "%b %y") +
      coord_cartesian(clip = "off") +
      labs(y = "Average Admissions(weekly)\n") +
      theme_minimal()

  })

  output$overview_beds_plot <- renderPlot({

    validate(
      need(input$year_input, "Please tick a year above")
    )
    beds_season_subset %>%
      filter(year %in% input$year_input) %>%
      ggplot() +
      aes(x = date, y = avg_daily_beds_perc, label = str_c(round(avg_daily_beds_perc), "%")) +
      geom_text(nudge_y = 1.2, alpha = 0.8) +
      geom_col(fill = "#605CA8", alpha = 0.8) +
      coord_cartesian(ylim = c(60, 80)) +
      labs(x = "",
           y = "Daily available beds (%)\n") +
      theme_minimal()

  })

  output$overview_los_plot <- renderPlot({

    validate(
      need(input$year_input, "Please tick a year above")
    )
    los_season_subset %>%
      filter(year %in% input$year_input) %>%
      ggplot() +
      aes(x = date, y = avg_los_days, label = str_c(avg_los_days, " days")) +
      geom_text(nudge_y = 1.2, alpha = 0.8) +
      geom_col(fill = "#605CA8", alpha = 0.8) +
      coord_cartesian(ylim = c(30, 70)) +
      labs(x = "",
           y = "Length of stay\n") +
      theme_minimal()

  })

  ## WINTER INFO BOX

  infobox_predata_winter <- reactive({

    if (input$tabbox_id == "admissions"){
      validate(
        need(input$year_input, "")
      )
      winter_mean <- mean((admissions_dt %>% filter(year %in% input$year_input, season == "Winter"))$avg_admissions_by_week) %>% round()
      winter_min <- min((admissions_dt %>% filter(year %in% input$year_input, season == "Winter"))$avg_admissions_by_week) %>% round()
      winter_max <- max((admissions_dt %>% filter(year %in% input$year_input, season == "Winter"))$avg_admissions_by_week) %>% round()
      return(c(winter_mean, winter_min, winter_max))
    } else if (input$tabbox_id == "beds") {
      validate(
        need(input$year_input, "")
      )
      winter_mean <- mean((beds_season_subset %>% filter(year %in% input$year_input, season == "Winter"))$avg_daily_beds_perc) %>% round()
      winter_min <- min((beds_season_subset %>% filter(year %in% input$year_input, season == "Winter"))$avg_daily_beds_perc) %>% round()
      winter_max <- max((beds_season_subset %>% filter(year %in% input$year_input, season == "Winter"))$avg_daily_beds_perc) %>% round()
      return(c(winter_mean, winter_min, winter_max))
    } else if (input$tabbox_id == "los") {
      validate(
        need(input$year_input, "")
      )
      winter_mean <- mean((los_season_subset %>% filter(year %in% input$year_input, season == "Winter"))$avg_los_days) %>% round(1)
      winter_min <- min((los_season_subset %>% filter(year %in% input$year_input, season == "Winter"))$avg_los_days) %>% round(1)
      winter_max <- max((los_season_subset %>% filter(year %in% input$year_input, season == "Winter"))$avg_los_days) %>% round(1)
      return(c(winter_mean, winter_min, winter_max))
    }
  })

  output$valuebox_winter_mean <- renderValueBox({
    valueBox(paste(infobox_predata_winter()[1]),
            "Mean Value (Winter)",
            icon = icon("snowflake"),
            color = "purple"
    )

  })

  output$valuebox_winter_min <- renderValueBox({
    valueBox(paste(infobox_predata_winter()[2]),
             "Mean Value (Winter)",
             icon = icon("snowflake"),
             color = "purple"
    )
    
  })

  output$valuebox_winter_max <- renderValueBox({
    valueBox(paste(infobox_predata_winter()[3]),
             "Mean Value (Winter)",
             icon = icon("snowflake"),
             color = "purple"
    )
    
  })

  ## !WINTER INFO BOX

  infobox_predata_other <- reactive({

    if (input$tabbox_id == "admissions"){
      validate(
        need(input$year_input, "")
      )
      other_mean <- mean((admissions_dt %>% filter(year %in% input$year_input, season != "Winter"))$avg_admissions_by_week) %>% round()
      other_min <- min((admissions_dt %>% filter(year %in% input$year_input, season != "Winter"))$avg_admissions_by_week) %>% round()
      other_max <- max((admissions_dt %>% filter(year %in% input$year_input, season != "Winter"))$avg_admissions_by_week) %>% round()
      return(c(other_mean, other_min, other_max))
    } else if (input$tabbox_id == "beds") {
      validate(
        need(input$year_input, "")
      )
      other_mean <- mean((beds_season_subset %>% filter(year %in% input$year_input, season != "Winter"))$avg_daily_beds_perc) %>% round()
      other_min <- min((beds_season_subset %>% filter(year %in% input$year_input, season != "Winter"))$avg_daily_beds_perc) %>% round()
      other_max <- max((beds_season_subset %>% filter(year %in% input$year_input, season != "Winter"))$avg_daily_beds_perc) %>% round()
      return(c(other_mean, other_min, other_max))
    } else if (input$tabbox_id == "los") {
      validate(
        need(input$year_input, "")
      )
      other_mean <- mean((los_season_subset %>%  filter(year %in% input$year_input, season != "Winter"))$avg_los_days) %>% round(1)
      other_min <- min((los_season_subset %>% filter(year %in% input$year_input, season != "Winter"))$avg_los_days) %>% round(1)
      other_max <- max((los_season_subset %>% filter(year %in% input$year_input, season != "Winter"))$avg_los_days) %>% round(1)
      return(c(other_mean, other_min, other_max))
    }
  })

  output$valuebox_other_mean <- renderValueBox({
    valueBox(paste(infobox_predata_other()[1]),
             "Mean Value (Other Seasons)",
             icon = icon("sun"),
             color = "teal"
    )
    
  })
  
  output$valuebox_other_min <- renderValueBox({
    valueBox(paste(infobox_predata_other()[2]),
             "Mean Value (other Seasons)",
             icon = icon("sun"),
             color = "teal"
    )
    
  })
  
  output$valuebox_other_max <- renderValueBox({
    valueBox(paste(infobox_predata_other()[3]),
             "Mean Value (Other Seasons)",
             icon = icon("sun"),
             color = "teal"
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
               theme_minimal())

    })



  # ---------GEOGRAPHIC TAB---------------------------

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

  #---------------------------MAP DETAIL PLOT COMPONENTS



  # ---------DEMOGRAPHIC TAB -----

  output$simd_plot <- renderPlotly({
  
    ggplotly(dep_date %>%
               group_by(date, simd_quintile) %>%
               summarise(avg_admissions = mean(number_admissions)) %>%
               ggplot() +
               aes(x = date, y = avg_admissions, colour = simd_quintile) +
               geom_line() +
               labs(x = "",
                    y = "Number of Admissions",
                    colour = "SIMD Quintile") +
              theme_minimal())
  
  })
  
  output$age_plot <- renderPlotly({
  
    ggplotly(age_date_clean %>%
               group_by(date, age_group) %>%
               summarise(avg_admissions = mean(number_admissions)) %>%
               ggplot() +
               aes(x = date, y = avg_admissions, colour = age_group) +
               geom_line() +
               labs(x = "",
                    y = "Number of Admissions",
                    colour = "") +
               theme_minimal())
  
  })
  
  output$sex_plot <- renderPlotly({
  
    ggplotly(sex_data_clean %>%
               group_by(date, sex) %>%
               summarise(avg_admissions = mean(number_admissions)) %>%
               ggplot() +
               aes(x = date, y = avg_admissions, colour = sex) +
               geom_line() +
               labs(x = "",
                    y = "Number of Admissions",
                    colour = "") +
               theme_minimal())
  
  })
  
  demo_title <- reactive( if (input$demotab_1 == "simd") {
    paste("Mean Weekly Admissions by SIMD")
  
  }
    else if (input$demotab_1 == "age") {
    paste("Mean Weekly Admissions by Age Group")
  } else {
    paste("Mean Weekly Admissions by Sex")
  }
  )
  
  output$title_demo <- renderText(demo_title())

  #----------COVID TAB----------

  output$emergency_admissions_plot <- renderPlot({
    
    emergency_admissions %>% 
      ggplot() +
      geom_line(aes(x = week_ending, y = average_2018_2019, group = 1, colour = "2018 - 2019"), lwd = 1.5) + 
      geom_line(aes(x = week_ending, y = count, group = 1, colour = "2020 - 2021"), lwd = 1.5) +
      scale_color_manual(name = "Time period", values = c("2018 - 2019" = "#605CA8", "2020 - 2021" = "tomato2")) +
      labs(y = "Number of patients\n",
           title = "Weekly Emergency Admissions to Hospital Over a Two Year Period\n") +
      scale_x_date(name = "",
                   breaks = seq(as.Date("2020-01-01"), as.Date("2022-04-01"), by = "2 months"), 
                   date_labels = "%b") +
      winter_shading[1] +
      winter_shading[2] +
      winter_shading[3] +
      theme_light() +
      theme(title = element_blank(),
            axis.text.x = element_text(size = 14),
            axis.text.y = element_text(size = 14),
            axis.title.x = element_blank(),
            axis.title.y = element_text(size = 16),
            legend.title = element_text(size = 16), 
            legend.text = element_text(size = 14))
    
  })
  
  output$a_e_attendance_plot <- renderPlot({
    
    a_e_attendance %>% 
      ggplot() +
      geom_line(aes(x = week_ending, y = average_2018_2019, group = 1, colour = "2018 - 2019"), lwd = 1.5) + 
      geom_line(aes(x = week_ending, y = count, group = 1, colour = "2020 - 2021"), lwd = 1.5) +
      scale_color_manual(name = "Time period", values = c("2018 - 2019" = "#605CA8", "2020 - 2021" = "#f46d43")) +
      labs(y = "Number of patients\n",
           title = "Weekly A&E Department Attendance Over a Two Year Period\n") +
      scale_x_date(name = "",
                   breaks = seq(as.Date("2020-01-01"), as.Date("2022-04-01"), by = "2 months"), 
                   date_labels = "%b") +
      winter_shading[1] +
      winter_shading[2] +
      winter_shading[3] +
      theme_light() +
      theme(title = element_blank(),
            axis.text.x = element_text(size = 14),
            axis.text.y = element_text(size = 14),
            axis.title.x = element_blank(),
            axis.title.y = element_text(size = 16),
            legend.title = element_text(size = 16), 
            legend.text = element_text(size = 14))
    
  })

  output$deaths_weekly_plot <- renderPlot({
    
    deaths_weekly %>% 
      ggplot() +
      geom_line(aes(x = week_ending, y = average_2015_2019, group = 1, colour = "2015 - 2019"), lwd = 1.5) + 
      geom_line(aes(x = week_ending, y = count, group = 1, colour = "2020 - 2021"), lwd = 1.5) +
      scale_color_manual(name = "Time period", values = c("2015 - 2019" = "#605CA8", "2020 - 2021" = "#f46d43")) +
      labs(y = "Number of deaths\n",
           title = "Weekly Number of Deaths Over a Two Year Period\n") +
      scale_x_date(name = "",
                   breaks = seq(as.Date("2020-01-01"), as.Date("2022-04-01"), by = "2 months"), 
                   date_labels = "%b") +
      winter_shading[1] +
      winter_shading[2] +
      winter_shading[3] +
      theme_light() +
      theme(title = element_blank(),
            axis.text.x = element_text(size = 14),
            axis.text.y = element_text(size = 14),
            axis.title.x = element_blank(),
            axis.title.y = element_text(size = 16),
            legend.title = element_text(size = 16), 
            legend.text = element_text(size = 14))
    
  })

  pre_post_title <- reactive( if (input$pre_post_id == "emergencies") {
    paste("Weekly Emergency Admissions to Hospital Over a Two Year Period")
    
  }
  else if (input$pre_post_id == "aeattendances") {
    paste("Weekly A&E Department Attendance Over a Two Year Period")
  } else {
    paste("Weekly Number of Deaths Over a Two Year Period")
  }
  )
  
  output$title_pre_post <- renderText(pre_post_title())
  
}
