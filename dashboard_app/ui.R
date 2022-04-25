ui <- dashboardPage(skin = "blue", 
                    dashboardHeader(title = "Basic dashboard"),
                    dashboardSidebar(
                      menuItem("testing for tab 1", tabName = "tab_1", icon = icon("dashboard")),
                      menuItem("other tab", tabName = "tab_other", icon = icon("th"))
                    ),
                    dashboardBody(
                      
                      tabItems(
                        
                        tabItem(tabName = "tab_1",
                                fluidRow(width = 4,
                                         "Box content here",
                                         dateRangeInput("date_range_input",
                                                        "Date Range:",
                                                        start = as_date(""))
                                ),
                                
                                fluidRow(width = 8,
                                         plotOutput()
                                )
                        ),
                        
                        tabItem(tabName = "tab_other",
                                h2("other")
                        )
                      ))
)

