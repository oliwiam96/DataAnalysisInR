shinyUI(fluidPage(
  mainPanel(
    sidebarPanel(uiOutput('fish'),
                 sliderInput("range", 
                             label = "Rok:",
                             min = 1960, max = 2019,
                             value = 2019),
                 h3(textOutput("text")),
                 width = 10)
                
  )
))
