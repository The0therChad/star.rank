#' @importFrom attempt stop_if_not
#' @importFrom curl has_internet
# Check internet connection
check_internet <- function(){
  stop_if_not(.x = has_internet(), msg = "Please check your internet connection")
}

#' @importFrom httr status_code
# Check API return status
check_status <- function(res){
  stop_if_not(.x = status_code(res),
              .p = ~ .x == 200,
              msg = "The API returned an error")
}

# Check "in" function to confirm "interested" is in data
'%!in%' <- function(x,y)!('%in%'(x,y))

utils::globalVariables(c("name", "title", "%>%"))
