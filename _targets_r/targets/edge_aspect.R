tar_terra_rast(
  edge_aspect,
  {
    edge_aspect_df <- lc4 |>
      terra::adjacent(
        # For each edge pixel
        cells = edge_distance |>
          filter(category == 1) |>
          as.data.frame(cells = TRUE) |>
          # Extract its cell number
          pull(cell),
        # Find all 8 adjacent cell numbers
        directions = 8
      ) |>
      # We now have an n x 8 matrix of adjacent cell numbers
      # Get the values of the 8 adjacent cell numbers
      # The t() in here magically turns the result of 
      # extract into a single matrix
      apply(1, \(cells) t(extract(lc4, cells))) |>
      # We now have values in columns; turn them into rows
      t() |>
      as.data.frame() |>
      # Now each row contains V1 .. V8, the adjacent values
      # 4 is forest, anything < 4 is non-forest
      mutate(
        north = (!is.na(V1) & V1 < 4) |
          (!is.na(V2) & V2 < 4) |
          (!is.na(V3) & V3 < 4),
        west = !is.na(V4) & V4 < 4,
        east = !is.na(V5) & V5 < 4,
        south = (!is.na(V6) & V6 < 4) |
          (!is.na(V7) & V7 < 4) |
          (!is.na(V8) & V8 < 4),
        
        # North-ish is north; south-ish is south,
        # but we reject things with too many edges
        aspect = case_when(
          north & !south & (!east | !west) ~ 1,
          !north & south & (!east | !west) ~ -1,
          .default = 0
        )
      ) |>
      select(aspect)
    
    edge_aspect <- lc4[[1]]
    edge_aspect[] <- NA_integer_
    
    cells <- as.integer(rownames(edge_aspect_df))
    edge_aspect[cells] <- edge_aspect_df$aspect
    
    edge_aspect
  }
)
