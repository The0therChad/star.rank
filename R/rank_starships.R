#' Rank Starships by specified metric
#'
#' @importFrom purrr compact
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @import ggplot2
#' @import dplyr
#'
#' @return
#' @export
#'
#' @examples

rank_starships <- function(format = NULL, sort_on = NULL) {
  url <- "https://swapi.dev/api/starships/"
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
  resDF <- resDF %>%
    as_tibble(resDF) %>%
    select(name, length) %>%
    mutate(length = as.numeric(length))

  resDF
  ggplot(resDF) +
    aes(x = name,
        y = length) +
    geom_col()
  ggsave("rank_plot.png", width = 20, height = 10)
}
