  # facet split scatter plot
  # 02_35_analysis-ggplot-facet-wrap.R
sales_joined |>
  ggplot2::ggplot(ggplot2::aes(item, count)) + 
  ggplot2::geom_boxplot() + 
  ggplot2::facet_wrap(vars(shop)) + 
  ggplot2::theme(text = ggplot2::element_text(size = 16)) + # set font size
  ggplot2::guides(x = ggplot2::guide_axis(angle = 90))      # prevent overlap

