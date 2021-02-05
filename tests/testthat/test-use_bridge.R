test_that("produces the expected changes to the r2dii.data repository", {
  sibling_path <- function(...) fs::path(fs::path_dir(here::here()), ...)
  copy_into_tempdir <- function(path) fs::dir_copy(path, tempdir())
  
  pkg <- "r2dii.data"
  tmp_path <- fs::path(tempdir(), pkg)
  tryCatch(
    copy_into_tempdir(sibling_path(pkg)),
    # R CMD check doesn't know about siblings
    error = function(e) copy_into_tempdir(test_path(pkg))
  )
  
  old <- getwd()
  setwd(tmp_path)
  devtools::load_all()

  dataset <- "fake"
  data <- data.frame(
    original_code = letters[1:3],
    code_level = 5,
    code = as.character(1:3),
    sector = "not in scope",
    borderline = FALSE
  )
  contributor <- "@somebody"
  issue <- "#123"

  system("git init", intern = TRUE)
  system("git add .", intern = TRUE)
  system("git commit -m 'init' --allow-empty", intern = TRUE)
  purrr::quietly(use_bridge)(dataset, data, contributor, issue)
  diff <- system("git diff --stat", intern = TRUE)
  status <- system("git status -s", intern = TRUE)
  actual <- c(diff, status)
  
  setwd(old)
  out_path <- test_path("output", "output-use_bridge.md")
  # writeLines(actual, out_path)
  
  expected <- readLines(out_path)
  expect_equal(actual, expected)
  
  # Cleanup
  fs::dir_delete(tmp_path)
})
