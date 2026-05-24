tar_terra_rast(
  impervious_adj,
  {
    impervious_adj <- c(
      lc4 |>
        mutate(impervious = case_when(
          category == 2 ~ 1, # Impervious
          .default = 0 # Everything else
        )) |>
        select(impervious),
      edge_distance |>
        mutate(edge = case_when(
          category == 1 ~ 1, # Edge
          .default = 0 # Everything else
        )) |>
        select(edge)
    ) |>
      mutate(
        category = if_else(edge == 1, NA, impervious) # Edge -> NA
      ) |>
      select(category) |>
      terra::focal(
        w = 3, # 3x3 window
        fun = "max", # 1 if impervious, 0 otherwise
        na.policy = "only", # Only fill edges, which are NA
        na.rm = TRUE # max should ignore NA values
      ) |>
      mutate(category = case_when(
        focal_max == 0 ~ 3, # Pervious
        focal_max == 1 ~ 2, # Impervious
        .default = NA
      )) |>
      select(category) |>
      terra::mask(edge_distance |> filter(category == 1))
  }
)
