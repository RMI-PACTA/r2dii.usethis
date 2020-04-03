test_that("output is as expected", {
  verify_output(
    test_path("output", "use_data_format.txt"),
    use_data_format("region_isos")
  )
})
