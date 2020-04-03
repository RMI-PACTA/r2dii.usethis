test_that("output is as expected", {
  verify_output(
    test_path("output", "use_logo.txt"),
    use_logo("pkg")
  )
})
