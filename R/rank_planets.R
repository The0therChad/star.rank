#' Rank Planets by quantitative metric (rotation_period, orbital_period, diameter, population)
#'
#' @importFrom purrr compact
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#'
#' @return
#' @export
#'
#' @examples

rank_planets <- function(format = NULL) {
  url <- "https://swapi.dev/api/planets/"
  args <- list(format = format)
  # Check for internet
  check_internet()
  # Call the API
  res <- GET(url, query = compact(args))
  # Check the result
  check_status(res)
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
  resDF
}

