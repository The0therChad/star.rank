#' Rank Species by specified metric
#'
#' Returns a plot showing the top 15 Star Wars species
#' sorted by a specified metric with starship name on the y-axis,
#' and the ranking metric on the x-axis.
#'
#' @param interested Metric to rank species on. ("average_height", "average_lifespan")
#'
#' @import ggplot2
#' @importFrom utils head
#'
#' @return A plot with species name on the y-axis and the ranking metric on the x-axis.
#' @export
#'
#' @examples \dontrun{rank_species(interested = "average_height"),
#' rank_species(interested = "average_lifespan")}

# Get information
rank_species <- function(interested = NULL) {
  url <- "https://swapi.dev/api/species/"
  #check for internet
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

  # Tidy dataframe
  # Trim to only 'name' and numeric columns
  resDF <-
    resDF[c(
      'name',
      'average_height',
      'average_lifespan'
    )]
  # Strip commas, change numeric values to numbers
  resDF[, 2:3] <- suppressWarnings(sapply(resDF[, 2:3], function(x) as.numeric(gsub(",", "", x))))
  # Sort by specified metic and use only top 15 values
  resDF <- resDF %>%
    dplyr::arrange(-!!sym(interested)) %>%
    head(15)

  # Plot results
  speciesPlot <-
    ggplot(resDF, aes(x=stats::reorder(name, -!!sym(interested)), y=!!sym(interested))) +
    geom_bar(stat="identity") +
    coord_flip() +
    xlab("Species")
  speciesPlot
}
