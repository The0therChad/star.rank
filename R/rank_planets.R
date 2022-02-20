#' Rank Planets by specified metric
#'
#' Returns a plot showing the top "n" number of Star Wars planets
#' sorted by a specified metric with planet name on the y-axis,
#' and the ranking metric on the x-axis.
#'
#' @param interested Metric to rank planets on. ("rotation_period", "orbital_period", "diameter", "population", "films")
#' @param n Number of results to plot. (default = 15)
#'
#' @import ggplot2
#' @importFrom utils head
#'
#' @return A ggplot with planet name on  the y-axis and the ranking metric on the x-axis.
#' @export
#'
#' @examples \dontrun{rank_planets(interested = "rotation_period", n = 9),
#' rank_planets(interested = "population")}

# Get information
rank_planets <- function(interested = NULL, n = 15) {
  # Check for proper arguments
  if (typeof(interested) != "character") stop("'interested' argument must be character string")
  if (typeof(n) != "double") stop("'n' argument must be type double")
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
  # Tidy dataframe
  # Select variables of interest
  resDF <-
    resDF[c('name',
            'rotation_period',
            'orbital_period',
            'diameter',
            'population',
            'films'
            )]
  # Check for n within range of data
  if (n > nrow(resDF)) stop(paste0("There are only ", nrow(resDF), " elements in the data. Please select a smaller 'n'"))
  # Check for interested argument in data
  if (interested %!in% colnames(resDF)) stop(paste0(interested, " is not a valid argument. Please check documentation for valid 'interested' values."))
  # Strip commas, change numeric columns to numbers
  resDF[, 2:5] <- suppressWarnings(sapply(resDF[, 2:5], function(x) as.numeric(gsub(",", "", x))))
  # Count number of films
  resDF[, 6] <- lengths(resDF$films)
  resDF <- resDF %>%
    dplyr::arrange(-!!sym(interested)) %>%
    head(n)

  #plot results
  planetPlot <- ggplot(data = resDF, aes(x = stats::reorder(name,-!!sym(interested)), y = !!sym(interested))) +
    geom_bar(stat = "identity") +
    xlab("Planet Name") +
    coord_flip() +
    xlab("Planet")
  planetPlot
}
