#' Rank Films by specified metric
#'
#' Returns a plot showing all six Star Wars films
#' sorted by the count of a specified metric with the film name on the y-axis,
#' and the ranking metric on the x-axis.
#'
#' @param interested Metric to rank films on. ("characters", "planets", "starships", "vehicles", "species")
#'
#' @import ggplot2
#' @importFrom utils head
#'
#' @return A plot with film title on the y-axis and the ranking metric on the x-axis.
#' @export
#'
#' @examples \dontrun{rank_films(interested = "species"),
#' rank_films(interested = "characters")}

# Get information
rank_films <- function(interested = NULL) {
  # Check for proper arguments
  if (typeof(interested) != "character") stop("'interested' argument must be character string")
  url <- "https://swapi.dev/api/films/"
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
  # Trim for variables of interest
  resDF <-
    resDF[c(
      'title',
      'characters',
      'planets',
      'starships',
      'vehicles',
      'species'
    )]
  # Check for interested argument in data
  if (interested %!in% colnames(resDF)) stop(paste0(interested, " is not a valid argument. Please check documentation for valid 'interested' values."))
  # Count each metric
  resDF[, 2] <- lengths(resDF$characters)
  resDF[, 3] <- lengths(resDF$planets)
  resDF[, 4] <- lengths(resDF$starships)
  resDF[, 5] <- lengths(resDF$vehicles)
  resDF[, 6] <- lengths(resDF$species)
  # Sort by specified metric and use all 6 films
  resDF <- resDF %>%
    dplyr::arrange(-!!sym(interested)) %>%
    head(6)

  # Plot results
  speciesPlot <-
    ggplot(resDF, aes(x=stats::reorder(title, -!!sym(interested)), y=!!sym(interested))) +
    geom_bar(stat="identity") +
    coord_flip() +
    xlab("Species")
  speciesPlot
}
