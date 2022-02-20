library("star.rank")


# Test rank_starships function (args = (interested, n=optional))
test_that("" , {
  expect_error(rank_starships(interested = "test"))
  expect_error(rank_starships(), "'interested' argument must be character string")
  expect_error(rank_starships(interested = 10), "'interested' argument must be character string")
  expect_error(rank_starships(interested = "average_height", n = "10"), "'n' argument must be type double")
  expect_type(rank_starships(interested = "length"), "list")
})
