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

}
