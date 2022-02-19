#' Rank People by specified metric
#'
#' @importFrom purrr compact
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#'
#' @return
#' @export
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

rank_people <- function(format = NULL, interested) {
  url <- "https://swapi.dev/api/people/"
  args <- list(format = format)
  # Call the API
  res <- GET(url, query = compact(args))
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

  #trim and sort dataframe for plotting
  resDF <- resDF[c('name', 'height', 'mass')]
  resDF[, c(2:3)] <- sapply(resDF[, c(2:3)], as.numeric)
  resDF <- resDF[complete.cases(resDF), ]
  resDF <- head(resDF, 20)
  resDF

  #plot output for height or mass

  peopleplot <- ggplot(data=resDF,
                       aes(x=reorder(name, -!!sym(interested)),
                           y=!!sym(interested))) +
    geom_bar(stat="identity") +
    coord_flip() +
    xlab("People")
  peopleplot

}
