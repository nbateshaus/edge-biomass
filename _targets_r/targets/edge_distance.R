tar_terra_rast(
  edge_distance,
  {
    # terra::distance fills NA pixels with the distance to the nearest
    # non-NA pixel. Remove forest pixes; these will be filled in by
    # distance.
    lc4 |>
      `levels<-`(lc4_classes) |>
      filter(category != "Forest") |>
      terra::distance()
  }
)
