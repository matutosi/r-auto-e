  # Repeating plot
  # 02_46_analysis-purrr-split-imap.R
gg_sales_split <- 
  sales_joined |>
  group_split(shop) |>
  purrr::imap(
    \(.x, .y){
      ggplot2::ggplot(.x, ggplot2::aes(period, count, group = item)) +
      ggplot2::geom_line(aes(color = item)) + # map line color to item
      ggplot2::theme_bw() +                   # black and white theme
      ggplot2::theme(text = ggplot2::element_text(family = "Yu Mincho", 
                     size = 20)) +            # Font type and font size
      ggplot2::guides(x = ggplot2::guide_axis(angle = 90)) + # prevent overlap
      ggplot2::labs(title = .y)                              # title
    }
  )

