#' Rank Planets by quantitative metric (rotation_period, orbital_period, diameter, population)
#'
#' Returns a plot showing the top "n" number of Star Wars planets
#' sorted by a specified metric with planet name on the y-axis,
#' and the ranking metric on the x-axis.
#'
#' @param interested Metric to rank planets on. ("rotation_period", "orbital_period", "diameter", "population")
#' @param n Number of results to plot. (default = 15)
#'
#' @import ggplot2
#' @importFrom utils head
#'
#' @return A ggplot with planet name on  the y-axis and the ranking metric on the x-axis.
#' @export
#'
#' @examples \dontrun{rank_planets(interested = "rotation_period"),
#' rank_planets(interested = "population")}

rank_planets <- function(interested = NULL, n = 15) {
  url <- "https://swapi.dev/api/planets/"
  # Check for internet
  check_internet()
  # Call the API
  res <- httr::GET(url)
  # Check the result
  check_status(res)
  # Store content of response
  cont <- httr::content(res, as = "text", encoding = "UTF-8")
  # Return content as a dataframe
  resHead <- jsonlite::fromJSON(cont)
  resDF <- resHead$results
  # Get each page of data and append to first page
  while (!is.null(resHead$`next`)) {
    res <- httr::GET(resHead$`next`)
    cont <- httr::content(res, as = "text", encoding = "UTF-8")
    resHead <- jsonlite::fromJSON(cont)
    resDF <- rbind(resDF, resHead$results)
  }

  #trim and sort dataframe for plotting
  resDF <-
    resDF[c('name',
            'rotation_period',
            'orbital_period',
            'diameter',
            'population')]
  resDF[, 2:5] <- suppressWarnings(sapply(resDF[, 2:5], function(x) as.numeric(gsub(",", "", x))))
  resDF <- resDF %>%
    dplyr::arrange(-!!sym(interested)) %>%
    head(n)

  #plot output for requested attribute
  planetPlot <- ggplot(data = resDF,
                       aes(x = stats::reorder(name,-!!sym(interested)),
                           y = !!sym(interested))) +
    geom_bar(stat = "identity") +
    xlab("Planet Name") +
    #    ylim(0,30000) +
    coord_flip() +
    xlab("Planet")
  planetPlot
}
