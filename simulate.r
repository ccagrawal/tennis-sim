simPoint <- function(winProb, simData) {
  rand <- runif(1, 0, 1)
  if (rand < winProb) {
    simData[1, 2] <- simData[1, 2] + 1
    simData[1, 3] <- simData[1, 3] + 1
    return(list(1, simData))
  }
  else {
    simData[1, 3] <- simData[1, 3] + 1
    return(list(0, simData))
  }
}

simGame <- function(winProb, simData) {
  p1Points <- 0
  p2Points <- 0
  
  while (TRUE) {
    results <- simPoint(winProb, simData)
    simData <- as.data.frame(results[2])
    if (results[1] == 1) {
      p1Points <- p1Points + 1
    }
    else {
      p2Points <- p2Points + 1
    }
    
    # cat("Game Score: ", p1Points, "-", p2Points, "\n", sep = "")
    
    if ((p1Points >= 4) && ((p1Points - p2Points) >= 2)) {
      simData[2, 2] <- simData[2, 2] + 1
      simData[2, 3] <- simData[2, 3] + 1
      return(list(1, simData))
    }
    else if ((p2Points >= 4) && ((p2Points - p1Points) >= 2)) {
      simData[2, 3] <- simData[2, 3] + 1
      return(list(0, simData))
    }
  }
}

simTiebreaker <- function(winProb, simData) {
  p1Points <- 0
  p2Points <- 0
  
  while (TRUE) {
    results <- simPoint(winProb, simData)
    simData <- as.data.frame(results[2])
    if (results[1] == 1) {
      p1Points <- p1Points + 1
    }
    else {
      p2Points <- p2Points + 1
    }
    
    # cat("Tiebreaker Score: ", p1Points, "-", p2Points, "\n", sep = "")
    
    if ((p1Points >= 7) && ((p1Points - p2Points) >= 2)) {
      simData[3, 2] <- simData[3, 2] + 1
      simData[3, 3] <- simData[3, 3] + 1
      return(list(1, simData))
    }
    else if ((p2Points >= 7) && ((p2Points - p1Points) >= 2)) {
      simData[3, 3] <- simData[3, 3] + 1
      return(list(0, simData))
    }
  }
}

simSetReg <- function(winProb, simData) {
  p1Games <- 0
  p2Games <- 0
  
  while (TRUE) {
    results <- simGame(winProb, simData)
    simData <- as.data.frame(results[2])
    if (results[1] == 1) {
      p1Games <- p1Games + 1
    }
    else {
      p2Games <- p2Games + 1
    }
    
    # cat("Set Score: ", p1Games, "-", p2Games, "\n", sep = "")
    
    if ((p1Games >= 6) && ((p1Games - p2Games) >= 2)) {
      simData[4, 2] <- simData[4, 2] + 1
      simData[4, 3] <- simData[4, 3] + 1
      return(list(1, simData))
    }
    else if ((p2Games >= 6) && ((p2Games - p1Games) >= 2)) {
      simData[4, 3] <- simData[4, 3] + 1
      return(list(0, simData))
    }
    else if ((p1Games == 6) && (p2Games == 6)) {
      results <- simTiebreaker(winProb, simData)
      simData <- as.data.frame(results[2])
      if (results[1] == 1) {
        simData[4, 2] <- simData[4, 2] + 1
        simData[4, 3] <- simData[4, 3] + 1
        return(list(1, simData))
      }
      else {
        simData[4, 3] <- simData[4, 3] + 1
        return(list(0, simData))
      }
    }
  }
}

simSetAdv <- function(winProb, simData) {
  p1Games <- 0
  p2Games <- 0
  
  while (TRUE) {
    results <- simGame(winProb, simData)
    simData <- as.data.frame(results[2])
    if (results[1] == 1) {
      p1Games <- p1Games + 1
    }
    else {
      p2Games <- p2Games + 1
    }
    
    # cat("Set Score: ", p1Games, "-", p2Games, "\n", sep = "")
    
    if ((p1Games >= 6) && ((p1Games - p2Games) >= 2)) {
      simData[4, 2] <- simData[4, 2] + 1
      simData[4, 3] <- simData[4, 3] + 1
      return(list(1, simData))
    }
    else if ((p2Games >= 6) && ((p2Games - p1Games) >= 2)) {
      simData[4, 3] <- simData[4, 3] + 1
      return(list(0, simData))
    }
  }
}

simMatch <- function(winProb, simData) {
  p1Sets <- 0
  p2Sets <- 0
  
  while (TRUE) {
    results <- simSetReg(winProb, simData)
    simData <- as.data.frame(results[2])
    if (results[1] == 1) {
      p1Sets <- p1Sets + 1
      
    }
    else {
      p2Sets <- p2Sets + 1
    }
    
    # cat("Match Score: ", p1Sets, "-", p2Sets, "\n", sep = "")
    
    if (p1Sets == 3) {
      simData[5, 2] <- simData[5, 2] + 1
      simData[5, 3] <- simData[5, 3] + 1
      return(list(1, simData))
    }
    else if (p2Sets == 3) {
      simData[5, 3] <- simData[5, 3] + 1
      return(list(0, simData))
    }
    else if ((p1Sets + p2Sets) == 4) {
      results <- simSetAdv(winProb, simData)
      simData <- as.data.frame(results[2])
      simData[5, 2] <- simData[5, 2] + as.numeric(results[1])
      simData[5, 3] <- simData[5, 3] + 1
      return(list(results[1], simData))
    }
  }
}