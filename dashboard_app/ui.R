ui <- dashboardPage(skin = "purple", 
                    dashboardHeader(title = "Epic dashboard"),
                    dashboardSidebar(
                      
                      sidebarMenu(
                        menuItem("Winter Crisis!", tabName = "tab one", icon = icon("stats", lib = "glyphicon"), 
                                 badgeLabel = "cool!", badgeColor = "green"),
                        menuItem("Covid Map!", icon = icon("globe", lib = "glyphicon"), tabName = "tab two",
                                 badgeLabel = "also cool!", badgeColor = "green")
                      )
                      
                    ),
                    dashboardBody(
                      
                      tabItems(
                        tabItem(tabName = "tab one",
                                h2("Crisis tab content")
                        ),
                        
                        tabItem(tabName = "tab two",
                                h2("Map tab content")
                        )
                      ),
                      # Boxes need to be put in a row (or column)
                      fluidRow(
                        box(plotOutput("plot1", height = 250)),
                        
                        box(
                          title = "Controls",
                          sliderInput("slider", "Number of observations:", 1, 100, 50)
                        )
                      )
                    )
)
