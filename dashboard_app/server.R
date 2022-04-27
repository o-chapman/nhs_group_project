server <- function(input, output) {

 ## TAB 1

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
  
  admissions_dt_react <- reactive({
    
    admissions_dt %>%
      filter(year %in% input$year_input)
    
  })
  
  output$overview_admissions_plot <- renderPlot({

    admissions_dt_react() %>%
      ggplot() +
      aes(x = date, y = avg_admissions_by_week) +
      geom_line(color = "steelblue") +
      winter_shading[1] +
      winter_shading[2] +
      scale_x_date(name = "",
                   #limits = c(as.Date("2020-01-01", "%Y-%m-%d"), as.Date("2022-02-20", "%Y-%m-%d")),
                   limits = c(min(admissions_dt_react()$date), max(admissions_dt_react()$date)),
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

  })


#----------Plots for Pre & Post Covid Tab----------

  output$emergency_admissions_plot <- renderPlot({
    
    emergency_admissions %>% 
      ggplot() +
      geom_line(aes(x = week_ending, y = average_2018_2019, group = 1, colour = "2018 - 2019")) + 
      geom_line(aes(x = week_ending, y = count, group = 1, colour = "2020 - 2021")) +
      scale_color_manual(name = "Time period", values = c("2018 - 2019" = "#74add1", "2020 - 2021" = "#f46d43")) +
      labs(y = "Number of patients\n",
           title = "Weekly emergency admissions to hospital\n") +
      theme_light() +
      theme(title = element_text(size = 14),
            axis.text = element_text(size = 12),
            axis.title.x = element_blank(),
            axis.title.y = element_text(size = 12))
    
  })
  
  output$a_e_attendance_plot <- renderPlot({
    
    a_e_attendance %>% 
      ggplot() +
      geom_line(aes(x = week_ending, y = average_2018_2019, group = 1, colour = "2018 - 2019")) + 
      geom_line(aes(x = week_ending, y = count, group = 1, colour = "2020 - 2021")) +
      scale_color_manual(name = "Time period", values = c("2018 - 2019" = "#74add1", "2020 - 2021" = "#f46d43")) +
      labs(y = "Number of patients\n",
           title = "Weekly A&E department attendance\n") +
      theme_light() +
      theme(title = element_text(size = 14),
            axis.text = element_text(size = 12),
            axis.title.x = element_blank(),
            axis.title.y = element_text(size = 12))
    
  })

  output$deaths_weekly_plot <- renderPlot({
    
    deaths_weekly %>% 
      ggplot() +
      geom_line(aes(x = week_ending, y = average_2015_2019, group = 1, colour = "2015 - 2019")) + 
      geom_line(aes(x = week_ending, y = count, group = 1, colour = "2020 - 2021")) +
      scale_color_manual(name = "Time period", values = c("2015 - 2019" = "#74add1", "2020 - 2021" = "#f46d43")) +
      labs(y = "Number of deaths\n",
           title = "Weekly number of deaths\n") +
      theme_light() +
      theme(title = element_text(size = 14),
            axis.text = element_text(size = 12),
            axis.title.x = element_blank(),
            axis.title.y = element_text(size = 12))
    
  })

}
