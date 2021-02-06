test_that("produces the expected changes to the r2dii.data repository", {
  system <- function(x) base::system(x, intern = TRUE)
  copy_into_tempdir <- function(path) {
    tmp <- fs::path(tempdir(), path)
    if (fs::dir_exists(tmp)) fs::dir_delete(tmp)
    fs::dir_copy(path, tempdir())
    invisible(path)
  }
  
  pkg <- "r2dii.data"
  tmp_path <- fs::path(tempdir(), pkg)
  copy_into_tempdir(test_path("r2dii.data"))
  
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

  system("git init -b master && git add . && git commit -m 'init'")
  purrr::quietly(use_bridge)(dataset, data, contributor, issue)
  actual <- system("git diff --stat && git status -s")
  setwd(old)
  reference <- test_path("output", "output-use_bridge.md")
  expected <- readLines(reference)
  
  expect_equal(actual, expected)
  
  fs::dir_delete(tmp_path)
})
