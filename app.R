library(dplyr)
library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(mainPanel(sidebarPanel(
  uiOutput('fish'),
  sliderInput(
    "range",
    label = "Rok:",
    min = 1960,
    max = 2019,
    value = 2019
  ),
  h3(textOutput("text")),
  width = 10
)))


# Define server logic required to draw a histogram
server <- function(input, output) {
  data <- read.csv("sledzie.csv", na.string = "?")
  
  for (i in 1:ncol(data)) {
    data[is.na(data[, i]), i] <- mean(data[, i], na.rm = TRUE)
  }
  
  numberOfYears = 60
  rowsInYear = ceiling(nrow(data) / 60)
  data_years <- data %>%  mutate(year = floor(X / rowsInYear) + 1)
  
  plot_data <-
    data_years %>% group_by(year) %>% summarize(mean_length = mean(length))
  
  
  output$text <- renderText({
    year = as.integer(input$range) - 1959
    length = plot_data[year,]$mean_length
    
    paste("Średnia długość śledzia: ", round(length, 2), "cm")
  })
  
  output$fish <- renderUI({
    year = as.integer(input$range) - 1959
    length = plot_data[year,]$mean_length
    image_width = length * 15
    
    img(src = "sledz.jpg", width = image_width)
  })
}

# Run the application
shinyApp(ui = ui, server = server)
