  # jitter plot
  # 02_32_analysis-ggplot-geom-jitter.R
sales_joined |>
  ggplot2::ggplot(ggplot2::aes(item, count)) + 
  ggplot2::geom_jitter() + 
  ggplot2::theme(text = ggplot2::element_text(size = 20)) + # set font size
  ggplot2::guides(x = ggplot2::guide_axis(angle = 90))     # prevent overlap

