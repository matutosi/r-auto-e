  # Save drawing to file
  # 02_36_analysis-ggplot-ggsave.R
path <- fs::file_temp(ext = "png") # Specify destination path extension
ggplot2::ggsave(path, gg_sales)

