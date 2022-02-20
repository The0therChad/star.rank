library("star.rank")

test_that("" , {
  expect_error(rank_vehicles(interested = "test"))
  expect_error(rank_vehicles(), "'interested' argument must be character string")
  expect_error(rank_vehicles(interested = 10), "'interested' argument must be character string")
  expect_error(rank_vehicles(interested = "average_height", n = "10"), "'n' argument must be type double")
  expect_type(rank_vehicles(interested = "length"), "list")
})
