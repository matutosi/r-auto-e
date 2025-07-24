  # Anti-garbled PDF files
  # 02_41_analysis-ggplot-notofu.R
  # library(extrafont) # Needed on restart
menu <- stringi::stri_unescape_unicode(
  c("\\u795e\\u6238\\u725b(kobe beef)"   , 
    "\\u3059\\u3057(sushi)"              , 
    "\\u30e9\\u30fc\\u30e1\\u30f3(ramen)"))
gg_notofu <- 
  tibble(menu, val = 1:3) |>
  ggplot(aes(menu, val)) + 
    geom_point(size = 5) +
    theme(text = element_text(size = 20, family = "Yu Mincho"))
path <- fs::path_temp(ext = "pdf")
ggplot2::ggsave(path, gg_notofu, device = cairo_pdf)
  # shell.exec(path)

