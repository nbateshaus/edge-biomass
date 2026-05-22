tar_terra_rast(
  basemap,
  {
    neon_aop_harv_xlim <- c(ext(neon_aop_harv)$xmin - 0.015, ext(neon_aop_harv)$xmax + 0.015)
    neon_aop_harv_ylim <- c(ext(neon_aop_harv)$ymin - 0.015, ext(neon_aop_harv)$ymax + 0.015)
    basemap_area <- terra::ext(
      neon_aop_harv_xlim["xmin"],
      neon_aop_harv_xlim["xmax"],
      neon_aop_harv_ylim["ymin"],
      neon_aop_harv_ylim["ymax"]
    ) |>
      terra::vect(crs = crs("epsg:4326"))
    
    neon_aop_web <- basemap_area |>
      terra::project(crs("epsg:3857")) |> # use webmercator
      st_as_sf()
    
    maptiles::get_tiles(
      neon_aop_web,
      provider = "CartoDB.VoyagerNoLabels",
      zoom = 8, # US County
      crop = TRUE
    )
  }
)
