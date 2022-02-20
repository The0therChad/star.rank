#' Rank Vehicles by specified metric
#'
#' Returns a plot showing the top "n" number of Star Wars vehicles
#' sorted by a specified metric with vehicle name on the y-axis,
#' and the ranking metric on the x-axis.
#'
#' @param interested Metric to rank vehicles on. ("cost_in_credits", "length", "max_atmosphering_speed", "crew", "passengers", "cargo_capacity", "films")
#' @param n number of results to plot. (default = 15)
#'
#' @import ggplot2
#' @importFrom utils head
#'
#' @return A plot with vehicle name on the y-axis and the ranking metric on  the x-axis.
#' @export
#'
#' @examples \dontrun{rank_vehicles(interested = "length"),
#' rank_vehicles(interested = "passengers")}

rank_vehicles <- function(interested = NULL, n = 15) {
  url <- "https://swapi.dev/api/vehicles/"
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
  # Only use 'name' and numeric columns
  resDF <-
    resDF[c(
      'name',
      'cost_in_credits',
      'length',
      'max_atmosphering_speed',
      'crew',
      'passengers',
      'cargo_capacity',
      'films'
    )]
  # Strip commas and change all values to numbers for plotting
  resDF[, 2:7] <- suppressWarnings(sapply(resDF[, 2:7], function(x) as.numeric(gsub(",", "", x))))
  # Count number of films
  resDF[, 8] <- lengths(resDF$films)
  # Sort DF by specified metric and use only top 15 values
  resDF <- resDF %>%
    dplyr::arrange(-!!sym(interested)) %>%
    head(n)

  # Plot results
  vehiclesPlot <-
    ggplot(resDF, aes(x = stats::reorder(name, -!!sym(interested)), y = !!sym(interested))) +
    geom_bar(stat = "identity") +
    coord_flip() +
    xlab("Vehicle")
  vehiclesPlot
}
