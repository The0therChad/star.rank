#' Rank Starships by specified metric
#'
#' Returns a plot showing the top "n" number of Star Wars starships
#' sorted by a specified metric with starship name on the y-axis,
#' and the ranking metric on the x-axis.
#'
#' @param interested Metric to rank starships on. ("cost_in_credits", "length", "max_atmosphering_speed", "crew", "passengers", "cargo_capacity", "films")
#' @param n Number of results to plot. (default = 15)
#'
#' @import ggplot2
#' @importFrom utils head
#'
#' @return A plot with starship name on the y-axis and the ranking metric on the x-axis.
#' @export
#'
#' @examples \dontrun{rank_starships(interested = "crew", n = 5),
#' rank_starships(interested = "max_atmosphering_speed")}

# Get information
rank_starships <- function(interested = NULL, n = 15) {
  # Check for proper arguments
  if (typeof(interested) != "character") stop("'interested' argument must be character string")
  if (typeof(n) != "double") stop("'n' argument must be type double")
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
  
  #Tidy dataframe
  # Select variables of interest
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
  # Check for n within range of data
  if (n > nrow(resDF)) stop(paste0("There are only ", nrow(resDF), " elements in the data. Please select a smaller 'n'"))
  # Check for interested argument in data
  if (interested %!in% colnames(resDF)) stop(paste0(interested, " is not a valid argument. Please check documentation for valid 'interested' values."))
  # Strip commas and change all values to numbers for plotting
  resDF[, 2:7] <- suppressWarnings(sapply(resDF[, 2:7], function(x) as.numeric(gsub(",", "", x))))
  # Count number of films
  resDF[, 8] <- lengths(resDF$films)
  # Sort DF by specified metric and use only top "n" values
  resDF <- resDF %>%
    dplyr::arrange(-!!sym(interested)) %>%
    head(n)

  # Plot results
  starshipsPlot <-
    ggplot(resDF, aes(x = stats::reorder(name, -!!sym(interested)), y = !!sym(interested))) +
    geom_bar(stat = "identity") +
    coord_flip() +
    xlab("Starship")
  starshipsPlot
}
