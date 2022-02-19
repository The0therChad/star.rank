#' Rank Starships by specified metric
#'
#' Returns a plot showing the top 15 Star Wars starships
#' sorted by a specified metric with starship name on the y-axis,
#' and the ranking metric on the x-axis.
#'
#' @param interested Metric to rank starships on. ("cost_in_credits", "length", "max_atmosphering_speed", "crew", "passengers", "cargo_capacity")
#'
#' @import ggplot2
#' @importFrom utils head
#'
#' @return A plot with starship name on the y-axis and the ranking metric on  the x-axis.
#' @export
#'
#' @examples \dontrun{rank_starships(interested = "crew"),
#' rank_starships(interested = "max_atmosphering_speed")}

rank_starships <- function(interested = NULL) {
  url <- "https://swapi.dev/api/starships/"
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
      'cargo_capacity'
    )]
  # Strip commas and change all values to numbers for plotting
  resDF[, 2:7] <- suppressWarnings(sapply(resDF[, 2:7], function(x) as.numeric(gsub(",", "", x))))
  # Sort DF by specified metric and use only top 15 values
  resDF <- resDF %>%
    dplyr::arrange(-!!sym(interested)) %>%
    head(15)

  # Plot results
  starshipsPlot <-
    ggplot(resDF, aes(x = stats::reorder(name, -!!sym(interested)), y = !!sym(interested))) +
    geom_bar(stat = "identity") +
    coord_flip() +
    xlab("Starship")
  starshipsPlot
}
