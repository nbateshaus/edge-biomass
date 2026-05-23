tar_terra_rast(
  lc4,
  {
    nlcd_reclassification <- tribble(
      ~is, ~becomes,
      "Open Water", "Water",
      "Developed, Open Space", "Impervious",
      "Developed, Low Intensity", "Impervious",
      "Developed, Medium Intensity", "Impervious",
      "Developed, High Intensity", "Impervious",
      "Barren Land", "Pervious",
      "Deciduous Forest", "Forest",
      "Evergreen Forest", "Forest",
      "Mixed Forest", "Forest",
      "Shrub/Scrub", "Pervious",
      "Grassland/Herbaceous", "Pervious",
      "Pasture/Hay", "Pervious",
      "Cultivated Crops", "Pervious",
      "Woody Wetlands", "Water",
      "Emergent Herbaceous Wetlands", "Water"
    ) |>
      left_join(nlcd_levels[[1]], by = join_by(is == `NLCD Land Cover Class`)) |>
      left_join(lc4_classes, by = join_by(becomes == category)) |>
      select(is = `Pixel Value`, becomes = `ID`)
    
    nlcd |>
      `levels<-`(nlcd_levels) |>
      terra::classify(nlcd_reclassification) |>
      `levels<-`(lc4_classes)
  }
)
