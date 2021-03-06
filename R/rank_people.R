#' Rank Peoples by specified metric
#'
#' Returns a plot showing the top "n" number of Star Wars people
#' sorted by a specified metric with the person's name on the y-axis,
#' and the ranking metric on the x-axis.
#'
#' @param interested Metric to rank people on. ("height", "mass", "films")
#' @param n Number of results to plot. (default = 15)
#'
#' @import ggplot2
#' @importFrom utils head
#'
#' @return A plot with people name on the y-axis and the ranking metric on the x-axis.
#' @export
#'
#' @examples \dontrun{rank_people(interested = "height"),
#' rank_people(interested = "mass", n = 18)}

# Get Information
rank_people <- function(interested = NULL, n = 15) {
  # Check for proper arguments
  if (typeof(interested) != "character") stop("'interested' argument must be character string")
  if (typeof(n) != "double") stop("'n' argument must be type double")
  url <- "https://swapi.dev/api/people/"
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
    resDF[c(
      'name',
      'height',
      'mass',
      'films'
    )]
  # Check for n within range of data
  if (n > nrow(resDF)) stop(paste0("There are only ", nrow(resDF), " elements in the data. Please select a smaller 'n'"))
  # Check for interested argument in data
  if (interested %!in% colnames(resDF)) stop(paste0(interested, " is not a valid argument. Please check documentation for valid 'interested' values."))
  # Strip commas and change all values to numbers for plotting
  resDF[, 2:3] <- suppressWarnings(sapply(resDF[, 2:3], function(x) as.numeric(gsub(",", "", x))))
  # Count number of films
  resDF[, 4] <- lengths(resDF$films)
  # Sort DF by specified metric and use top "n" values
  resDF <- resDF %>%
    dplyr::arrange(-!!sym(interested)) %>%
    head(n)

  # Plot results
  peoplePlot <-
    ggplot(resDF, aes(x = stats::reorder(name, -!!sym(interested)), y = !!sym(interested))) +
    geom_bar(stat = "identity") +
    coord_flip() +
    xlab("Person")
  peoplePlot
}
