tar_terra_rast(
  interior_adj,
  {
    edge_distance |>
      filter(category != 1) |>
      terra::distance(
        exclude = 2 # transition
      ) |>
      filter(is.finite(category) & category > 0) |>
      mutate(category = case_when(
        category <= 120 ~ 1, # Interior Adjacent
        category  > 120 ~ 0  # Isolated
      )) |>
      terra::mask(edge_distance)
  }
)
