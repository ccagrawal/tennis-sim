shinyUI(bootstrapPage(
  tags$head(
    tags$script(src = 'js/highcharts.js'),
    tags$script(src = 'js/highcharts-more.js')
  ),
  
  headerPanel("Monte Carlo Simulations in Tennis"),
  sidebarPanel(
    sliderInput("winP1", "Point Win Probability:",
                min = 0, max = 1, value = .55, step = .005),
    tags$br(),
    sliderInput("delay", "Match Simulation Speed:",
                min = 1, max = 5, value = 2, step = 1),
    tags$br(),
    tags$br(),
    helpText("This app simulates tennis matches. You input",
             "the probability of winning a single point,",
             "and the app will continuously simulate matches and",
             "output the percentage of points, games, tiebreakers,",
             "sets, and matches that were won. The matches are",
             "simulated according to Men's Single's Grand Slam rules.",
             "If you move the 'Point Win Probability' slider, the",
             "data will reset."),
    tags$br(),
    tags$h5(textOutput("count"))
  ),
  mainPanel(
    tags$div(id = "simChart",
             style="min-width: 200px; height: 300px; margin: 0 auto"),
    tags$script(src = "initchart.js"),
    tags$br(),
    tableOutput("simResults")
  )
))