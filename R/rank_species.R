#' Rank Starships by specified metric
#'
#' @importFrom purrr compact
#' @importFrom jsonlite fromJSON
#' @importFrom httr GET
#'
#' @return
#' @export
#'
#' @examples

rank_species <- function(format = NULL) {
  url <- "https://swapi.dev/api/species/"
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
#couldn't pull dataframe so made mock up to create rest of code
name <- c("Human", "Droid", "Wookie", "Rodian", "Hutt", "Yoda's species", "Trandoshan", "Mon Calamari", "Ewok")
average_height <-  c("180", "n/a", "210", "170", "300", "66", "200", "160", "100")
average_lifespan <- c("120", "n/a", "400", "unknown", "1000", "900", "unknown", "unknown", "unknown")
speciesdf <- data.frame(name, average_height, average_lifespan)

#change column names...base R format
names(speciesdf)[names(speciesdf)=='average_height'] <- 'height'
names(speciesdf)[names(speciesdf)=='average_lifespan'] <- 'lifespan'

#write function to deal with n/a


#write function to make numeric
speciesdf$height <- as.numeric(speciesdf$height)
speciesdf$lifespan <- as.numeric(speciesdf$lifespan)
speciesdf

#sort dataframe based on arg entered
argument <- "Tallest"
n <- 5

#sort based on arg
if (tolower(argument) == "tallest") {
  speciesdf$height <- as.numeric(speciesdf$height)
  species <- (speciesdf[order(-speciesdf$height),])

  #build graph and list functions
}else if (tolower(argument)=="shortest"){
  speciesdf$height <- as.numeric(speciesdf$height)
  speciesdf <- speciesdf[order(speciesdf$height),]
}else if (tolower(argument)=="oldest") {
  speciesdf$lifespan <- as.numeric(speciesdf$lifespan)
  speciesdf <- speciesdf[order(-as.numeric(speciesdf$lifespan)),]
}else if (tolower(argument)=="youngest") {
  speciesdf$lifespan <- as.numeric(speciesdf$lifespan)
  speciesdf <- speciesdf[order(as.numeric(speciesdf$lifespan)),]
}else{
  print("You must enter a valid ranking parameter.  For species you can rank by tallest, shortest, oldest and youngest.")
}
species <-  na.omit(speciesdf[-c(3)])
species
# need to code to pull names from dataframe
plot <- barplot(t(as.matrix(species)), beside = TRUE, horiz=TRUE)
plot



