library("star.rank")

# Test rank_people function (args = (interested, n=optional))
test_that("" , {
  expect_error(rank_people(interested = "test"))
  expect_error(rank_people(), "'interested' argument must be character string")
  expect_error(rank_people(interested = 10), "'interested' argument must be character string")
  expect_error(rank_people(interested = "average_height", n = "10"), "'n' argument must be type double")
  expect_type(rank_people(interested = "height"), "list")
})
