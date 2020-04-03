test_that("output is as expected", {
  verify_output(
    test_path("output", "use_2dii_logo.txt"),
    use_2dii_logo("pkg")
  )
})
