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
                      
                      tabItems(
                        
                        # Overview tab content
                        tabItem(tabName = "overview",
                                h2("Overview tab content")
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
                                h2("Geographic tab content"), 
                                
                                fluidRow(
                                  tabBox(
                                  title = "Select map type",
                                  # The id lets us use input$tabset1 on the server to find the current tab
                                  id = "tabset1", height = "250px",
                                  tabPanel("Tab1", "First tab content"),
                                  tabPanel("Tab2", "Tab content 2")
                                )
                                ),
                                
                                fluidRow(
                                  box(status = "info", 
                                      leafletOutput("hospital_plot", height = 500, width = "100%"), width = 12)
                                )
                        ),
                        
                        # Demographic tab content
                        tabItem(tabName = "demographic",
                                h2("Demographic tab content")
                        )
                      ),
                    )
)