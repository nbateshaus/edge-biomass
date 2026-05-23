tar_target(
  nlcd_coltab,
    terra::rast(
      file.path(
        "/vsizip",
        nlcd_file,
        paste0("Annual_NLCD_LndCov_", nlcd_year, "_CU_C1V1_", nlcd_uuid, ".tiff")
      )
    ) |>
    coltab()
)
