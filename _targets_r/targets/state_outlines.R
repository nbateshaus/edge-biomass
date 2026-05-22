tar_terra_vect(
  state_outlines,
  map_data("state", region = c(
      "Connecticut", "Massachusetts", "Rhode Island", "New Hampshire", "Vermont"
    )) |>
    sfheaders::sf_polygon(
      obj = _,
      x = "long",
      y = "lat",
      polygon_id = "group"
    ) |>
    sf::`st_crs<-`(sf::st_crs("epsg:4326")) |>
    terra::vect()
)
