server <- function(input, output) {
  
  ## TAB 1
  
  admissions_dt_react <- reactive({
    
    admissions_dt %>%
      filter(year %in% input$year_input)
    
  })
  
  ## INFO BOXES
  
  output$info_box_max <- renderInfoBox({
    
    
  })
  
  ## PLOTS
  
  output$overview_admissions_plot <- renderPlot({
    
    validate(
      need(input$year_input, "Please tick a year above")
    )
    admissions_dt_react() %>%
      ggplot() +
      aes(x = date, y = avg_admissions_by_week) +
      geom_line(color = "steelblue", size = 1.5) +
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
      geom_col(fill = "turquoise", alpha = 0.8) +
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
      geom_col(fill = "turquoise", alpha = 0.8) +
      coord_cartesian(ylim = c(30, 70)) +
      labs(x = "",
           y = "Length of stay\n") +
      theme_minimal() 
    
  })
  
  ## WINTER INFO BOX
  
  infobox_predata_winter <- reactive(
        
    if (input$tabbox_id == "admissions"){
      validate(
        need(input$year_input, "")
      )
      d_mean <- mean((admissions_dt %>% filter(year %in% input$year_input, season == "Winter"))$avg_admissions_by_week) %>% round()
      d_min <- min((admissions_dt %>% filter(year %in% input$year_input, season == "Winter"))$avg_admissions_by_week) %>% round()
      d_max <- max((admissions_dt %>% filter(year %in% input$year_input, season == "Winter"))$avg_admissions_by_week) %>% round()
      return(c(d_mean, d_min, d_max))
    } else if (input$tabbox_id == "beds") {
      validate(
        need(input$year_input, "")
      )
      d_mean <- mean((beds_season_subset %>% filter(year %in% input$year_input, season == "Winter"))$avg_daily_beds_perc) %>% round()
      d_min <- min((beds_season_subset %>% filter(year %in% input$year_input, season == "Winter"))$avg_daily_beds_perc) %>% round()
      d_max <- max((beds_season_subset %>% filter(year %in% input$year_input, season == "Winter"))$avg_daily_beds_perc) %>% round()
      return(c(d_mean, d_min, d_max))
    } else if (input$tabbox_id == "los") {
      validate(
        need(input$year_input, "")
      )
      d_mean <- mean((los_season_subset %in% filter(year %in% input$year_input))$avg_los_day)
      d_min <- min((los_season_subset %>% filter(year %in% input$year_input))$avg_los_days)
      d_max <- max((los_season_subset %>% filter(year %in% input$year_input, season == "Winter"))$avg_los_days)
      return(c(d_mean, d_min, d_max))
    }
  )
  
  output$infobox_winter_mean <- renderInfoBox(
    infoBox("Mean Value (Winter)",
            paste(infobox_predata_winter()[1]),
            icon = icon("list"),
            color = "red"
    )
  )
  
  output$infobox_winter_min <- renderInfoBox(
    infoBox("Mean Value (Winter)",
            paste(infobox_predata_winter()[2]),
            icon = icon("list"),
            color = "red"
    )
  )
  
  output$infobox_winter_max <- renderInfoBox(
    infoBox("Mean Value (Winter)",
            paste(infobox_predata_winter()[3]),
            icon = icon("list"),
            color = "red"
    )
  )
  
  ## !WINTER INFO BOX
  
  infobox_predata_winter <- reactive(
    
    if (input$tabbox_id == "admissions"){
      validate(
        need(input$year_input, "")
      )
      d_mean <- mean((admissions_dt %>% filter(year %in% input$year_input, season != "Winter"))$avg_admissions_by_week) %>% round()
      d_min <- min((admissions_dt %>% filter(year %in% input$year_input, season != "Winter"))$avg_admissions_by_week) %>% round()
      d_max <- max((admissions_dt %>% filter(year %in% input$year_input, season != "Winter"))$avg_admissions_by_week) %>% round()
      return(c(d_mean, d_min, d_max))
    } else if (input$tabbox_id == "beds") {
      validate(
        need(input$year_input, "")
      )
      d_mean <- mean((beds_season_subset %>% filter(year %in% input$year_input, season != "Winter"))$avg_daily_beds_perc) %>% round()
      d_min <- min((beds_season_subset %>% filter(year %in% input$year_input, season != "Winter"))$avg_daily_beds_perc) %>% round()
      d_max <- max((beds_season_subset %>% filter(year %in% input$year_input, season != "Winter"))$avg_daily_beds_perc) %>% round()
      return(c(d_mean, d_min, d_max))
    } else if (input$tabbox_id == "los") {
      validate(
        need(input$year_input, "")
      )
      d_mean <- mean((los_season_subset %in% filter(year %in% input$year_input))$avg_los_day)
      d_min <- min((los_season_subset %>% filter(year %in% input$year_input))$avg_los_days)
      d_max <- max((los_season_subset %>% filter(year %in% input$year_input, season!= "Winter"))$avg_los_days)
      return(c(d_mean, d_min, d_max))
    }
  )
  
  output$infobox_not_winter_mean <- renderInfoBox(
    infoBox("Mean Value (other seasons)",
            paste(infobox_predata_winter()[1]),
            icon = icon("list"),
            color = "blue"
    )
  )
  
  output$infobox_not_winter_min <- renderInfoBox(
    infoBox("Mean Value (other seasons)",
            paste(infobox_predata_winter()[2]),
            icon = icon("list"),
            color = "blue"
    )
  )
  
  output$infobox_not_winter_max <- renderInfoBox(
    infoBox("Mean Value (other seasons)",
            paste(infobox_predata_winter()[3]),
            icon = icon("list"),
            color = "blue"
    )
  )
  
}
