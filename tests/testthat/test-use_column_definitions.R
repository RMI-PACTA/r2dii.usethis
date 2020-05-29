test_that("defines one dataset", {
  dictionary <- data.frame(
    stringsAsFactors = FALSE,
    dataset = c("d1", "d2"),
    column = c("x", "y", "o", "p"),
    typeof = c("character", "integer", "double", "factor"),
    definition = c("Def. of x", "Def. of y", "Def. of o", "Def. of p")
  )
  
  out <- use_column_definitions(dictionary, dataset = "d1")
  expect_is(out, "glue")
  expect_is(out, "character")
  expect_length(out, 2L)
})

test_that("with missing `dataset` errors gracefully", {
  dictionary <- data.frame(
    stringsAsFactors = FALSE,
    dataset = c("d1", "d2"),
    column = c("x", "y", "o", "p"),
    typeof = c("character", "integer", "double", "factor"),
    definition = c("Def. of x", "Def. of y", "Def. of o", "Def. of p")
  )
  
  expect_error(use_column_definitions(dictionary), "dataset.*missing")
})
