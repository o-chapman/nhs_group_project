
ui <- dashboardPage(skin = "purple",
                    dashboardHeader(title = "Epic dashboard"),

                    # Sidebar content
                    dashboardSidebar(

                      sidebarMenu(

                        # lots of icons we can use here: https://fontawesome.com/icons/categories/medical-health
                        menuItem("Overview", tabName = "overview", icon = icon("book-medical"),
                                 badgeLabel = "temp", badgeColor = "green"),
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
                                    inline = T, 
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
                                h2("Temporal tab content"),
                                # Boxes need to be put in a row (or column)
                                fluidRow(
                                  box(plotOutput("plot1", height = 250)), # Placeholder stuff

                                  box(
                                    title = "Controls",
                                    sliderInput("slider", "Number of observations:", 1, 100, 50)
                                  )
                                )
                        ),

                        # Geographic tab content
                        tabItem(tabName = "geographic",
                                h2("Geographic tab content")
                        ),

                        # Demographic tab content
                        tabItem(tabName = "demographic",
                                h2("Demographic tab content")
                        )
                      ),
                    )
)
