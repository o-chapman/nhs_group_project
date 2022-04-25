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

                      tabItems(

                        # Geographic tab content
                        tabItem(tabName = "overview",
                                h2("Overview tab content"),
                                
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
                                  tabBox(title = "Geo Data",
                                         id = "geotabs", 
                                         width = 12,
                                         tabPanel("Region Data", leafletOutput("heatmap")),
                                         tabPanel("Hospital Data"))),
                                fluidRow(
                                  box(radioButtons("map_type",
                                                   "Map Type",
                                                   choices = c("Health Board Area" = "hb", "Individual Hospital" = "hospital")))
                                  
                                )
                        ),
                        # Demographic tab content
                        tabItem(tabName = "demographic",
                                h2("Demographic tab content")
                        )
                      )
                    )
)
