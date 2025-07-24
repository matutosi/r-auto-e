  # Basic plot (Boxplot)
  # 02_31_analysis-ggplot-ggplot.R
sales_joined |>
  ggplot2::ggplot(mapping = ggplot2::aes(x = item, y = count)) + 
  ggplot2::geom_boxplot() + 
  ggplot2::theme(text = ggplot2::element_text(size = 20)) + # set font size
  ggplot2::guides(x = ggplot2::guide_axis(angle = 90))     # prevent overlap

