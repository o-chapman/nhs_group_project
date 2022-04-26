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

                        tabItem(tabName = "overview",
                                h2("Overview tab content"),
                                
                                # Row with slider for tabset plots
                                fluidRow(
                                  
                                  sliderInput("date_range_slider",
                                              "Date range:",
                                              min = date_limits[1],
                                              max = date_limits[2],
                                              value = date_limits)     
                                  
                                  
                                ),
                                
                                #Main visual (tabset with plots showing diff in
                                #KPI's in Winter)
                                fluidRow(
                                  
                                  tabsetPanel(
                                    
                                    #Bed capacity
                                    tabPanel("Bed Capacity",
                                      
                                      plotlyOutput("overview_beds_plotly")
                                      
                                    ),
                                    
                                    #Admissions
                                    tabPanel("Admissions",
                                      
                                      plotlyOutput("overview_admissions_plotly")
                                      
                                    ),
                                    
                                    #Length of stay
                                    tabPanel("Length of stay",
                                      
                                      plotlyOutput("overview_los_plotly")
                                      
                                    ),
                                    
                                    #
                                    tabPanel("Deaths (from?)",
                                      
                                      plotlyOutput("overview_deaths_plotly")

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
