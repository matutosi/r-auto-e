  # Including 2byte font in the plot
  # 02_42_analysis-geom-text.R
tibble::tibble(x = 1:3, y = 1:3, label = menu) |>
  ggplot2::ggplot(aes(x, y, label = label)) +
  ggplot2::geom_text(family = "Yu Mincho", size = 10) +
  ggplot2::theme(text = ggplot2::element_text(size = 20)) + # Increase font size
  xlim(0, 4) + ylim(0, 4)
path <- fs::file_temp(ext = "pdf")
ggplot2::ggsave(path, device = cairo_pdf)
  # shell.exec(path)

