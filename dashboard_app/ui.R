ui <- dashboardPage(skin = "purple", 
                    dashboardHeader(title = "Epic dashboard"),
                    
                    # Sidebar content
                    dashboardSidebar(
                      
                      sidebarMenu(
                        
                        # lots of icons we can use here: https://fontawesome.com/icons/categories/medical-health
                        menuItem("Winter Crisis!", tabName = "crisis", icon = icon("chart-line"), 
                                 badgeLabel = "cool!", badgeColor = "green"),
                        menuItem("Covid Map!", tabName = "map", icon = icon("globe"), 
                                 badgeLabel = "also cool!", badgeColor = "green")
                      )
                    ),
                    
                    # Body content
                    dashboardBody(
                      
                      tabItems(
                        
                        # Crisis tab content
                        tabItem(tabName = "crisis",
                                h2("Crisis tab content"),
                                # Boxes need to be put in a row (or column)
                                fluidRow(
                                  box(plotOutput("plot1", height = 250)),
                                  
                                  box(
                                    title = "Controls",
                                    sliderInput("slider", "Number of observations:", 1, 100, 50)
                                  )
                                )
                        ),
                        
                        # Map tab content
                        tabItem(tabName = "map",
                                h2("Map tab content")
                        )
                      ),
                    )
)