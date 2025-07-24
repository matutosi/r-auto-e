  # Changing the theme
  # 02_43_analysis-ggplot-theme.R
gg <- 
  tibble::tibble(x = rnorm(100), y = runif(100)) |>
  ggplot2::ggplot(ggplot2::aes(x, y)) +
  ggplot2::geom_point() +  # scatter plot
  ggplot2::theme_bw()      # Change to a simple black and white theme
gg

