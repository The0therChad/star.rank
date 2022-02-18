#' Rank Starships by specified metric
#'
#' @importFrom purrr compact
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#'
#' @return
#' @export
#'#' Rank Planets by quantitative metric (rotation_period, orbital_period, diameter, population)
#'
#' @importFrom purrr compact
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @import ggplot2
#' @import dplyr
#'
#' @return
#' @export
#'
#' @examples

rank_species <- function(format = NULL, interested) {
  url <- "https://swapi.dev/api/species/"
  args <- list(format = format)
  # Call the API
  res <- GET(url, query = compact(args))
  # Store content of response
  cont <- httr::content(res, as = "text", encoding = "UTF-8")
  # Return content as a dataframe
  resHead <- fromJSON(cont)
  resDF <- resHead$results
  # Get each page of data and append to first page
  while (!is.null(resHead$`next`)) {
    res <- GET(resHead$`next`, query = compact(args))
    cont <- httr::content(res, as = "text", encoding = "UTF-8")
    resHead <- fromJSON(cont)
    resDF <- rbind(resDF, resHead$results)
  }

  #trim and sort dataframe for plotting
  resDF <- resDF[c('name', 'rotation_period', 'orbital_period', 'diameter', 'population')]
  resDF[, c(2:5)] <- sapply(resDF[, c(2:5)], as.numeric)
  resDF <- resDF[complete.cases(resDF), ] %>%
    arrange(-!!sym(interested))
  resDF <- head(resDF, 10)
  resDF

  #plot output for requested attribute
  planetplot <- ggplot(data=resDF, aes(x=name, y=!!sym(interested))) +
    geom_bar(stat="identity") +
    coord_flip()
  planetplot



}

