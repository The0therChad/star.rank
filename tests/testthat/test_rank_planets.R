library("star.rank")

test_that("" , {
  expect_error(rank_planets(interested = "test"))
  expect_error(rank_planets(), "'interested' argument must be character string")
  expect_error(rank_planets(interested = 10), "'interested' argument must be character string")
  expect_error(rank_planets(interested = "average_height", n = "10"), "'n' argument must be type double")
  expect_type(rank_planets(interested = "diameter"), "list")
})
