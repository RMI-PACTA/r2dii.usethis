test_that("defines one dataset", {
  dictionary <- data.frame(
    stringsAsFactors = FALSE,
    dataset = paste0("dataset_", c(1, 1, 2, 2)),
    column = letters[1:4],
    typeof = c("character", "integer", "double", "factor"),
    definition = paste0("Definition of ", letters[1:4])
  )

  out <- use_column_definitions(dictionary, dataset = "dataset_1")
  
  expect_is(out, "glue")
  expect_is(out, "character")
  expect_length(out, 2L)
})

test_that("with missing `dataset` errors gracefully", {
  # Doesn't matter
  dictionary <- mtcars
  
  expect_error(use_column_definitions(dictionary), "dataset.*missing")
})
