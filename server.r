source("simulate.r", local = TRUE)

shinyServer(function(input, output, session) {
  
  simData <- data.frame(Simulation = c("Points", "Games", "Tiebreakers", "Sets", "Matches"))
  simData$Won <- 3
  simData$Total <- 0
  
  views <- as.numeric(read.table("viewFile.txt", header = FALSE)[1, 1]) + 1
  write(views, file = "viewFile.txt")
  
  output$count <- renderText({
    paste("Views:", views, sep = " ")
  })
  
  values <- reactive({
    invalidateLater(1000 + 70 * input$delay, session)
    for (i in 1:input$delay) {
      simData <<- as.data.frame(simMatch(input$winP1, simData)[2])
    }
    simData
  })
  
  observe({
    num <- input$winP1
    simData$Won <<- 0
    simData$Total <<- 0
  })
  
  output$simResults <- renderTable({
    data <- values()
    for (i in 1:nrow(data)) {
      if (data[i, 3] > 1) {
        critT <- qt(0.975, data[i, 3] - 1)
        p <- data[i, 2] / data[i, 3]
        q <- 1 - p
        margin <- critT * sqrt(p * q / data[i, 3])
        data[i, 4] <- p
        data[i, 5] <- data[i, 4] - margin
        data[i, 6] <- data[i, 4] + margin
      }
      else {
        data[i, 4] <- 0
        data[i, 5] <- 0
        data[i, 6] <- 1
      }
      
      if (data[i, 5] < 0) {
        data[i, 5] <- 0
      }
      if (data[i, 6] > 1) {
        data[i, 6] <- 1
      }
    }
    colnames(data) <- c("", "Won", "Total", "Win %", "Lower Bound", "Upper Bound")
    
    session$sendCustomMessage(
      type = "updateHighchart", 
      message = list(
        name = "simChart",
        y0 = data[1, 4],
        y1 = data[2, 4],
        y2 = data[3, 4],
        y3 = data[4, 4],
        y4 = data[5, 4],
        
        lb0 = data[1, 5],
        lb1 = data[2, 5],
        lb2 = data[3, 5],
        lb3 = data[4, 5],
        lb4 = data[5, 5],
        
        ub0 = data[1, 6],
        ub1 = data[2, 6],
        ub2 = data[3, 6],
        ub3 = data[4, 6],
        ub4 = data[5, 6]
      )
    )
    
    data$Won <- sprintf("%d", data$Won)
    data$Total <- sprintf("%d", data$Total)
    data$"Win %" <- sprintf("%.2f%%", data$"Win %" * 100)
    data$"Lower Bound" <- sprintf("%.2f%%", data$"Lower Bound" * 100)
    data$"Upper Bound" <- sprintf("%.2f%%", data$"Upper Bound" * 100)
    data
  }, include.rownames = FALSE)
})