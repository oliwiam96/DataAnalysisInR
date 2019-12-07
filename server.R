library(dplyr)

shinyServer(function(input, output) {
  
  data <- read.csv("sledzie.csv", na.string="?")
  
  for(i in 1:ncol(data)){
    data[is.na(data[,i]), i] <- mean(data[,i], na.rm = TRUE)
  }
  
  numberOfYears = 60
  rowsInYear = ceiling( nrow(data) / 60)
  print(rowsInYear)
  data_years <- data %>%  mutate(year = floor(X/rowsInYear) + 1)
  
  plot_data <- data_years %>% group_by(year) %>% summarize(mean_length=mean(length))
  
  
  output$text <- renderText({ 
    year = as.integer(input$range) - 1959
    length = plot_data[year, ]$mean_length
    
    paste("Średnia długość śledzia: ", round(length, 2), "cm")
  })
  
  output$fish <- renderUI({
    year = as.integer(input$range) - 1959
    length = plot_data[year, ]$mean_length
    image_width = length*15
    
    img(src = "sledz.jpg", width = image_width)
  })
})