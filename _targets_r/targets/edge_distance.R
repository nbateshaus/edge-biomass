tar_terra_rast(
  edge_distance,
  {
    lc4 |>
      # target = 4 = Forest
      # exclude = 1 = Water
      terra::distance(target = 4, exclude = 1) |>
      filter(category > 0) |>
      mutate(category = case_when(
        category <= 30  ~ 1,
        category <= 100 ~ 2,
        category  > 100 ~ 3
      )) |>
      terra::mask(lc4)
  }
)
