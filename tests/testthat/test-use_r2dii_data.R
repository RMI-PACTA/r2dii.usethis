test_that("outputs an informative checklist", {
  verify_output(
    test_path("output", "output-use_r2dii_data.txt"),
    {
      use_r2dii_data()

      use_r2dii_data("my_data")
    }
  )
})
