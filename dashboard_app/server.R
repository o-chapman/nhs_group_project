server <- function(input, output) {

  set.seed(122)
  histdata <- rnorm(500)



  output$plot1 <- renderPlot({

    data <- histdata[seq_len(input$slider)]
    hist(data)

  })



  output$info_box_mean <- renderInfoBox({
    infoBox(
      title = "Mean",
      value = mean(test_data),
      subtitle = "mean value in test data",
      icon = icon("calculator"),
      color = "purple",
      fill = TRUE
    )
  })

  output$info_box_max <- renderInfoBox({
    infoBox(
      title = "Max",
      value = max(test_data),
      subtitle = "max value in test data",
      icon = icon("shower"),
      color = "purple",
      fill = T
    )
  })

  output$info_box_min <- renderInfoBox({
    infoBox(
      title = "Min",
      value = min(test_data),
      subtitle = "min value in test data",
      icon = icon("sort-amount-desc"),
      color = "purple",
      fill = TRUE
    )
  })

  output$year_input <- {(
    renderText(input$year)
  )}


  ## TAB 1

  admissions_dt_react <- reactive({



  })

  output$overview_beds_plotly <- renderPlotly({

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

  output$overview_admissions_plotly <- renderPlotly({

    ggplotly(admissions_dt %>%
               ggplot() +
               aes(x = date, y = avg_admissions_by_week) +
               geom_line(color = "steelblue") +
               winter_shading[1] +
               winter_shading[2] +
               scale_x_date(name = "", limits = c(as.Date("2020-01-01", "%Y-%m-%d"), as.Date("2022-02-20", "%Y-%m-%d")), date_breaks = "3 months",
                            date_minor_breaks = "1 month", date_labels = "%b %y") +
               labs(y = "Average Admissions(weekly)") +
               theme_minimal()
    )

  })

  output$overview_los_plotly <- renderPlotly({

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

  output$overview_deaths_plotly <- renderPlotly({

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


}
