tar_terra_vect(
  neon_aop_harv,
  terra::vect(file.path(
     "/vsizip",
     neon_aop_harv_file,
     "AOP_flightBoxes",
     "AOP_flightboxesAllSites.shp"
  )) |>
    filter(siteID == "HARV") |>
    filter(priority == 1)
)
