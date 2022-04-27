
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
                                  box(width = 4,
                                      checkboxGroupInput(
                                        "year_input", "Select Year" , c("2020", "2021"),
                                        selected = c("2020", "2021"),
                                        inline = T, 
                                      )
                                  )
                                ),
                                
                                fluidRow(
                                  tabBox(width = 12,
                                         id = "tabbox_id",
                                         #Main visual (tabset with plots showing diff in
                                         #KPI's in Winter)
                                         
                                         #Admissions
                                         tabPanel("Admissions",
                                                  value = "admissions",
                                                  
                                                  plotOutput("overview_admissions_plot")
                                         ),
                                         
                                         #Bed capacity
                                         tabPanel("Bed Capacity",
                                                  value = "beds",
                                                  
                                                  plotOutput("overview_beds_plot")
                                                  
                                         ),
                                         
                                         #Length of stay
                                         tabPanel("Length of stay",
                                                  value = "los",
                                                  
                                                  plotOutput("overview_los_plot")
                                                  
                                         )
                                  ) 
                                ),  
                                
                                fluidRow(
                                  box(width = 12,
                                         
                                         infoBoxOutput("infobox_winter_mean", width = 4),
                                         infoBoxOutput("infobox_winter_max", width = 4),
                                         infoBoxOutput("infobox_winter_min", width = 4)
                                  )       
                                ),  
                                
                                fluidRow(
                                  box(width = 12,

                                         infoBoxOutput("infobox_other_mean", width = 4),
                                         infoBoxOutput("infobox_other_max", width = 4),
                                         infoBoxOutput("infobox_other_min", width = 4)
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
