#' Rank Species by specified metric
#'
#' Returns a plot showing the top "n" number of Star Wars species
#' sorted by a specified metric with starship name on the y-axis,
#' and the ranking metric on the x-axis.
#'
#' @param interested Metric to rank species on. ("average_height", "average_lifespan", "films")
#' @param n Number of results to plot. (default = 15)
#'
#' @import ggplot2
#' @importFrom utils head
#'
#' @return A plot with species name on the y-axis and the ranking metric on the x-axis.
#' @export
#'
#' @examples \dontrun{rank_species(interested = "average_height", n = 20),
#' rank_species(interested = "average_lifespan")}

# Get information
rank_species <- function(interested = NULL, n = 15) {
  # Check for proper arguments
  if (typeof(interested) != "character") stop("'interested' argument must be character string")
  if (typeof(n) != "double") stop("'n' argument must be type double")
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
  # Select variables of interest
  resDF <-
    resDF[c(
      'name',
      'average_height',
      'average_lifespan',
      'films'
    )]
  # Check for n within range of data
  if (n > nrow(resDF)) stop(paste0("There are only ", nrow(resDF), " elements in the data. Please select a smaller 'n'"))
  # Check for interested argument in data
  if (interested %!in% colnames(resDF)) stop(paste0(interested, " is not a valid argument. Please check documentation for valid 'interested' values."))
  # Strip commas, change numeric values to numbers
  resDF[, 2:3] <- suppressWarnings(sapply(resDF[, 2:3], function(x) as.numeric(gsub(",", "", x))))
  # Count number of films
  resDF[, 4] <- lengths(resDF$films)
  # Sort by specified metric and use only top 15 values
  resDF <- resDF %>%
    dplyr::arrange(-!!sym(interested)) %>%
    head(n)

  # Plot results
  speciesPlot <-
    ggplot(resDF, aes(x=stats::reorder(name, -!!sym(interested)), y=!!sym(interested))) +
    geom_bar(stat="identity") +
    coord_flip() +
    xlab("Species")
  speciesPlot
}
