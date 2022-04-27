
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
                                    title = textOutput("title_demo"),
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
                                  )),
                                fluidRow(
                                box(tags$h5(HTML("Understanding the intersectionality of demographics with winter hospital activity statistics is key to making sure the NHS can deliver services to people that need it the most. These graphs show activity by <i>SIMD 5 quintiles</i>, a scale which measures the 5 quintiles of the Scottish Index of Multiple Deprivation, Age, and Gender.<br><b>Click on the legend to select/deselect desired lines on plot</b>")), width = 12),
                                ))
                        

                        )
                      )
)
