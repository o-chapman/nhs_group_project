
ui <- dashboardPage(skin = "purple",
                    dashboardHeader(title = "Epic dashboard"),

                    # Sidebar content
                    dashboardSidebar(

                      sidebarMenu(

                        # lots of icons we can use here: https://fontawesome.com/icons/categories/medical-health
                        menuItem("Overview", tabName = "overview", icon = icon("book-medical"),
                                 badgeLabel = " ", badgeColor = "green"),
                        menuItem("Temporal", tabName = "temporal", icon = icon("chart-line"),
                                 badgeLabel = "temp", badgeColor = "yellow"),
                        menuItem("Geographic", tabName = "geographic", icon = icon("globe"),
                                 badgeLabel = "temp", badgeColor = "orange"),
                        menuItem("Demographic", tabName = "demographic", icon = icon("hospital-user"),
                                 badgeLabel = "temp", badgeColor = "red")
                      )
                    ),

                    # Body content
                    dashboardBody(

                      # First overview tab
                      tabItems(


                        # Overview tab content
                        tabItem(tabName = "overview",
                                h2("Overview tab content"),


                                fluidRow(
                                  infoBoxOutput("info_box_mean", width = 4),
                                  infoBoxOutput("info_box_max", width = 4),
                                  infoBoxOutput("info_box_min", width = 4)

                                ),

                                fluidRow(
                                  checkboxGroupInput(
                                    "year_input", "Select Year" , c("2020", "2021"),
                                    selected = c("2020", "2021"),
                                    inline = T
                                  )
                                ),


                                #Main visual (tabset with plots showing diff in
                                #KPI's in Winter)
                                fluidRow(

                                  tabsetPanel(

                                    #Bed capacity
                                    tabPanel("Bed Capacity",

                                      plotOutput("overview_beds_plot")

                                    ),

                                    #Admissions
                                    tabPanel("Admissions",

                                      plotOutput("overview_admissions_plot")

                                    ),

                                    #Length of stay
                                    tabPanel("Length of stay",

                                      plotOutput("overview_los_plot")

                                    ),

                                    #
                                    tabPanel("Deaths (from?)",

                                      plotOutput("overview_deaths_plot")

                                    )

                                  )


                                )



                        ),

                        # Temporal tab content
                        tabItem(tabName = "temporal",
                                h2("Temporal tab content")
                                # Boxes need to be put in a row (or column)

                        ),

                        # Geographic tab content
                        tabItem(tabName = "geographic",
                                h2("Geographic tab content"),
                                fluidRow(
                                  tabBox(title =  textOutput("title"),
                                         id = "geotabs",
                                         width = 12,
                                         tabPanel(value = "area", "Region Data", leafletOutput("heatmap")),
                                         tabPanel(value = "point", "Hospital Data", leafletOutput("hospital_plot")))),
                                fluidRow(
                                  box(radioButtons("map_data",
                                                   "Investigate Winter Increase",
                                                   choices = c(
                                                     "Mortality" = "winter_mortality_increase",
                                                     "Wait Time Tariff Overflow" = "winter_target_wait_time_overshoot_increase",
                                                     "Beds Filled" = "winter_beds_increase"))
                                      )


                                )),
    

                        # Demographic tab content
                        tabItem(tabName = "demographic",
                                h2("Demographic tab content"),
                                fluidRow(
                                  tabBox(
                                    title = "Test Title",
                                    id = "demotab_1",
                                    width = 12,
                                    tabPanel(value = "simd",
                                      "SIMD Plot", 
                                             plotlyOutput("simd_plot")),
                                    tabPanel(value = "age",
                                      "Age Plot",
                                             plotlyOutput("age_plot")),
                                    tabPanel(value = "sex",
                                      "Sex Plot",
                                             plotlyOutput("sex_plot"))
                                  ))
                                )

                        )
                      )
)    
