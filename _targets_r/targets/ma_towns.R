tar_terra_vect(
  ma_towns,
  terra::vect(file.path(
    "/vsizip",
    ma_towns_file,
    "CENSUS2020TOWNS_POLY.shp"
  ))
)
