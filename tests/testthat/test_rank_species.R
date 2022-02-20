library("star.rank")

test_that("" , {
  expect_error(rank_species(interested = "average_weight"))
  expect_error(rank_species(), "Can't convert NULL to a symbol.")
  expect_error(rank_species(interested = average_height), "object 'average_height' not found")
  expect_error(rank_species(interested = "average_height", n = ""), "non-numeric argument to binary operator")
  expect_type(rank_species(interested = "average_lifespan"), "list")
})
