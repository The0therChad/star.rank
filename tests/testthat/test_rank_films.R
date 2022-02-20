library("star.rank")

test_that("" , {
  expect_error(rank_films(interested = "test"))
  expect_error(rank_films(), "'interested' argument must be character string")
  expect_error(rank_films(interested = 10), "'interested' argument must be character string")
  expect_type(rank_films(interested = "characters"), "list")
})
