tar_target(
  the_rest_of_the_map,
  {
    library(ggspatial)
    
    neon_aop_harv_xlim <- c(ext(neon_aop_harv)$xmin - 0.015, ext(neon_aop_harv)$xmax + 0.015)
    neon_aop_harv_ylim <- c(ext(neon_aop_harv)$ymin - 0.015, ext(neon_aop_harv)$ymax + 0.015)
    
    detail_area <- terra::ext(-72.20, -72.15, 42.50, 42.55) |>
      terra::vect(crs = crs("epsg:4326"))
    detail_xlim <- c(ext(detail_area)$xmin, ext(detail_area)$xmax)
    detail_ylim <- c(ext(detail_area)$ymin, ext(detail_area)$ymax)
    
    harvard_forest <- terra::vect(
      tibble(x=-72.1899, y=42.5319),
      crs=crs("epsg:4326")
    )
    
    list(
      geom_spatvector(
        data = neon_aop_harv,
        aes(
          color = "NEON AOP",
          linetype = "NEON AOP"
        ),
        fill = "transparent"
      ),
      geom_spatvector(
        data = ma_towns,
        aes(
          color = "Town Borders",
          linetype = "Town Borders"
        ),
        fill = "transparent"
      ),
      geom_spatvector(
        data = detail_area,
        aes(
          color = "Detail Area",
          linetype = "Detail Area"
        ),
        fill = "transparent"
      ),
      # This one is a black background for the HF triangle;
      # it does not show in the legend.
      geom_spatvector(
        data = harvard_forest,
        color = "black",
        shape = "triangle",
        size = 2.5
      ),
      geom_spatvector(
        data = harvard_forest,
        aes(
          color = "Harvard Forest",
          linetype = "Harvard Forest"
        ),
        shape = "triangle"
      ),
      geom_spatvector(
        data = rope_plots,
        aes(
          color = "Rope Plot",
          linetype = "Rope Plot"
        )
      ),
      coord_sf(
        crs = crs(neon_aop_harv),
        xlim = neon_aop_harv_xlim,
        ylim = neon_aop_harv_ylim
      ),
      scale_color_manual(
        name = "Legend",
        values = c(
          "Town Borders" = "black",
          "NEON AOP" = "red",
          "Detail Area" = "blue",
          "Harvard Forest" = "gold",
          "Rope Plot" = "black"
        ),
        breaks = c(
          "Town Borders",
          "NEON AOP",
          "Detail Area",
          "Harvard Forest",
          "Rope Plot"
        )
      ),
      scale_linetype_manual(
        name = "Legend",
        values = c(
          "Town Borders" = "dotted",
          "NEON AOP" = "solid",
          "Detail Area" = "dashed",
          "Harvard Forest" = "solid",
          "Rope Plot" = "solid"
        ),
        breaks = c(
          "Town Borders",
          "NEON AOP",
          "Detail Area",
          "Harvard Forest",
          "Rope Plot"
        )
      ),
      theme_bw(),
      theme(axis.text.x = element_text(angle = -30, hjust = 0, vjust = 1)),
      annotation_scale(
        location = "br",
        pad_x = unit(0.65, "cm"),
        pad_y = unit(0.45, "cm")
      ),
      annotation_north_arrow(
        location = "tr",
        width = unit(0.75, "cm"),
        pad_x = unit(0.00, "cm"),
        pad_y = unit(1, "cm"),
        style = north_arrow_minimal
      )
    )
  }
)
