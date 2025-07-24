  # Overlaying boxplot and jitter plot
  # 02_33_analysis-ggplot-geom-boxplot-geom-jitter.R
gg_sales <- 
  sales_joined |>
  ggplot2::ggplot(ggplot2::aes(item, count)) + 
  ggplot2::geom_boxplot(outlier.color = NA) + # prevent duplication of outliers
  ggplot2::geom_jitter(width = 0.3, height = 0, size = 0.3) +
  ggplot2::theme(text = ggplot2::element_text(size = 20)) + # set font size
  ggplot2::guides(x = ggplot2::guide_axis(angle = 90))     # prevent overlap
gg_sales

