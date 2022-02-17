#' Rank Starships by specified metric
#'
#' @importFrom purrr compact
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#' @importFrom stats reorder
#' @import ggplot2
#' @import dplyr
#' @import tidyr
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
    mutate(cost_in_credits = as.numeric(cost_in_credits),
           length = as.numeric(length),
           max_atmosphering_speed = as.numeric(max_atmosphering_speed),
           crew = as.numeric(crew),
           passengers = as.numeric(passengers),
           cargo_capacity = as.numeric(cargo_capacity)) %>%
    suppressWarnings() %>%
    tidyr::replace_na(list(0))

  ggplot(resDF) +
    aes(x = reorder(name, -!!sym(sort_on)),
        y = !!sym(sort_on)) +
    geom_col() +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
  suppressWarnings(ggsave("rank_plot.png", width = 20, height = 10))
}
