tar_terra_rast(
  wetland_adj,
  {
    # Build a raster of wetlands and edges
    wetland_adj <- c(
      lc4 |>
        filter(category == 1) |> # just water
        select(water = category),
      edge_distance |>
        filter(category == 1) |> # just edges
        select(edge = category)
    ) |>
      mutate(category = case_when(
        water == 1 ~ 1, # Water
        edge == 1 ~ 2,  # Edge
      )) |>
      select(category) |>
      # For each edge, find the distance to water
      terra::distance(
        target = 2, # edge
        exclude = NA
      ) |>
      filter(category > 0) |>
      # Label the edges as wet (adjacent to water) or dry
      mutate(category = case_when(
        category <= 30 ~ 0, # Wet
        category  > 30 ~ 1  # Dry
      )) |>
      terra::mask(lc4)
  }
)
