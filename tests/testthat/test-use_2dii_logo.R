test_that("multiplication works", {
  verify_output(
    test_path("output", "use_2dii_logo.txt"),
    use_2dii_logo("pkg")
  )
})
