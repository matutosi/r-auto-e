  # Installing tidyverse
  # 02_01_analysis-install.R
install.packages("tidyverse")

  # Calling  tidyverse
  # 02_02_analysis-library.R
library(tidyverse)

  # A function to read all sheets in Excel
  # 02_03_analysis-read-all-sheets-fun.R
read_all_sheets <- function(path, add_sheet_name = TRUE){
  sheets <- openxlsx::getSheetNames(path)  # list of sheet names
  xlsx <- 
    sheets |>
    purrr::map(\(x){                       # for each sheet
      openxlsx::read.xlsx(path, sheet = x) # read data
    }) |>
    purrr::map(tibble::tibble)             # convert to tibble
  names(xlsx) <- sheets                    # sheet name
  if(add_sheet_name){                      # add sheet name to tibble or not
    xlsx <- purrr::map2(xlsx, sheets,
      \(.x, .y){
        dplyr::mutate(.x, sheet = .y)      # add column for sheet name
      }
    )
  }
  return(xlsx)
}

  # Reading data for analysis
  # 02_04_analysis-read.R
wd <- fs::path_temp()
setwd(wd)
files <- c("answer.xlsx", "attribute.xlsx", "sales.xlsx", "unit_price.xlsx")
urls <- paste0("https://matutosi.github.io/r-auto-e/data/", files)
curl::multi_download(urls)
answer <- readxl::read_excel(files[1])
attribute <- readxl::read_excel(files[2])
sales <- read_all_sheets(files[3]) |> 
  dplyr::bind_rows() |>
  dplyr::rename(shop = sheet)
unit_price <- readxl::read_excel(files[4])

  # A summary of answer
  # 02_05_analysis-answer.R
head(answer, 3)

  # A summary of attribute
  # 02_06_analysis-attribute.R
head(attribute, 3)

  # A summary of sales
  # 02_07_analysis-sales.R
head(sales, 3)

  # A summary of unit_price
  # 02_08_analysis-unit-price.R
head(unit_price, 3)

  # Convert to wide format
  # 02_09_analysis-tidyr-pivot-wider.R
head(answer, 3)
answer_wide <- # data/answer_wide.csv
  tidyr::pivot_wider(answer, names_from = item, values_from = ans)
head(answer_wide, 3)

  # Convert to long Format
  # 02_10_analysis-tidyr-pivot-longer.R
head(sales, 3)
sales_long <-                                         # data/sales_long.csv
  tidyr::pivot_longer(sales, cols = !c(period, shop), # ! means exclusion
                      names_to = "item", values_to = "count")
head(sales_long, 3)

  # Split data into vertical direction
  # 02_11_analysis-tidyr-separate-longer-delim.R
answer_tidy <- answer_wide |> # data/answer_tidy.csv
tidyr::separate_longer_delim(apps, delim = ";") |> # split with ";"
  tidyr::replace_na(list(apps = "-", comment = "")) # replace NA
head(answer_tidy, 3)

  # Joining data frames
  # 02_12_analysis-dplyr-join.R
answer_joined <- # data/answer_joined.csv
  dplyr::left_join(attribute, answer_tidy) # join with id column
head(answer_joined, 3)
sales_joined <- # data/sales_joined.csv
  dplyr::left_join(sales_long, unit_price, by = join_by(item == item))
head(sales_joined, 3)

  # Extracting missing data
  # 02_13_analysis-dplyr-anti-join.R
lost <- dplyr::filter(answer_joined, apps != "-")     # drop when apps == "-"
print(answer_joined, n = 3)                           # all data
print(lost, n = 3)                                    # apps != "-"
dplyr::anti_join(answer_joined, lost) |> print(n = 3) # apps == "-"

  # Selecting and excluding columns
  # 02_14_analysis-dplyr-select.R
dplyr::select(answer_joined, id, area, years) |> head(3) # select columsus
dplyr::select(sales_joined, -c(period, item)) |> head(3) # exclude columns

  # Extracting Rows
  # 02_15_analysis-dplyr-filter.R
dplyr::filter(sales_joined, 600 < price & price < 700) |> head(3)

  # remove duplicates
  # 02_16_analysis-dplyr-distinct.R
dplyr::distinct(answer_joined, area) |> head(3)

  # Arrange
  # 02_17_analysis-dplyr-arrange.R
dplyr::arrange(sales_joined, desc(count)) |> head(3)

  # add columns
  # 02_18_analysis-dplyr-mutate.R
dplyr::mutate(answer_joined, id = as.numeric(id), 
              years = as.numeric(years)) |> 
  print(n = 3)
  # Add column ap before second column
answer_joined |>
  dplyr::mutate(id = as.numeric(id), years = as.numeric(years)) |> 
  dplyr::mutate(ap = stringr::str_sub(apps, 1, 2), .before = 2) |> 
  print(n = 3)

  # Convert specified columns
  # 02_19_analysis-dplyr-mutate-all.R
answer_mutated <- # data/answer_mutated.csv
  dplyr::mutate_at(answer_joined, c("id", "years", "satisfy"), as.numeric) |> 
  print(n = 3)

  # Grouping
  # 02_20_analysis-dplyr-group-by.R
dplyr::group_by(answer_mutated, area) |> print(n = 3)

  # Calculate mean
  # 02_21_analysis-dplyr-summarise.R
dplyr::group_by(answer_mutated, area) |> 
  dplyr::summarise(m_years = mean(years), m_satisfy = mean(satisfy))

  # Calculate means using .by
  # 02_22_analysis-dplyr-summarise-by.R
dplyr::summarise(answer_mutated, m_years = mean(years), 
                 m_satisfy = mean(satisfy), .by = area)

  # Summary of a column containing numbers
  # 02_23_analysis-dplyr-summarise-if.R
dplyr::group_by(sales_joined, item) |> 
  dplyr::summarise_if(is.numeric, max) |>
  print(n = 3)

  # counting numbers
  # 02_24_analysis-dplyr-n.R
dplyr::group_by(answer_mutated, area) |> 
  dplyr::summarise(n = n())

  # change format after summarization
  # 02_25_analysis-dplyr-summarise-pivot-wider.R
sales_joined |>
  dplyr::summarise(sum = round(sum(count * price) / 1000), 
                   .by = c(period, shop)) |>
  tidyr::pivot_wider(names_from = shop, values_from = sum) |>
  print(n = 3)

  # A function to count multiple answers
  # 02_26_analysis-dplyr-count-multi-ans-fun.R
count_multi <- function(df, col, delim = "[^[:alnum:]]+", group_add = TRUE){
  df |>
    tidyr::separate_longer_delim(tidyselect::all_of(col),    # split vertically
                                 delim = delim) |> 
    dplyr::filter({{ col }} != "") |>                            # remove empty
    dplyr::filter(!is.na({{ col }})) |>                          # remove NA
    dplyr::group_by(dplyr::pick({{ col }}), .add = group_add) |> # grouping
    dplyr::tally() |>                                            # cout number
    dplyr::filter({{ col }} != "")                               # remove empty
}

  # simple summary
  # 02_27_analysis-dplyr-straight-summary.R
dplyr::count(answer_mutated, area)  |> # Single answer, simple tally
  print(n = 3)
count_multi(answer_mutated, "apps") |> # Multiple answers, simple tally
  print(n = 3)

  # cross-tabulation
  # 02_28_analysis-dplyr-cross-summary.R
dplyr::count(answer_mutated, area, satisfy) |> # Single answer, cross tabulation
  tidyr::pivot_wider(names_from = area, values_from = n, values_fill = 0) |>
  print(n = 3)
answer_mutated |>                           # Multiple answer, cross tabulation
  dplyr::group_by(area) |>
  count_multi("apps", delim = ";") |>
  tidyr::pivot_wider(names_from = area, values_from = n, values_fill = 0) |>
  print(n = 3)

  # relocate and rename columns
  # 02_29_analysis-dplyr-others.R
dplyr::relocate(answer_mutated, apps)
dplyr::rename(answer_mutated, ans_id = id)

  # Shortcuts for counting
  # 02_30_analysis-dplyr-tally.R
dplyr::group_by(answer_mutated, area) |> dplyr::tally()
dplyr::count(answer_mutated, area)

  # Basic plot (Boxplot)
  # 02_31_analysis-ggplot-ggplot.R
sales_joined |>
  ggplot2::ggplot(mapping = ggplot2::aes(x = item, y = count)) + 
  ggplot2::geom_boxplot() + 
  ggplot2::theme(text = ggplot2::element_text(size = 20)) + # set font size
  ggplot2::guides(x = ggplot2::guide_axis(angle = 90))     # prevent overlap

  # jitter plot
  # 02_32_analysis-ggplot-geom-jitter.R
sales_joined |>
  ggplot2::ggplot(ggplot2::aes(item, count)) + 
  ggplot2::geom_jitter() + 
  ggplot2::theme(text = ggplot2::element_text(size = 20)) + # set font size
  ggplot2::guides(x = ggplot2::guide_axis(angle = 90))     # prevent overlap

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

  # splitting a scatterplot using for and subset()
  # 02_34_analysis-ggplot-facet-for.R
par(mfcol = c(3, 3))
  par(mar = rep(1.5, 4))
  par(oma = rep(1.5, 4))
for(s in unique(sales_joined$shop)){
  sales_sub <- subset(sales_joined, shop == s)
  plot(factor(sales_sub$item), sales_sub$count)
}

  # facet split scatter plot
  # 02_35_analysis-ggplot-facet-wrap.R
sales_joined |>
  ggplot2::ggplot(ggplot2::aes(item, count)) + 
  ggplot2::geom_boxplot() + 
  ggplot2::facet_wrap(vars(shop)) + 
  ggplot2::theme(text = ggplot2::element_text(size = 16)) + # set font size
  ggplot2::guides(x = ggplot2::guide_axis(angle = 90))      # prevent overlap

  # Save drawing to file
  # 02_36_analysis-ggplot-ggsave.R
path <- fs::file_temp(ext = "png") # Specify destination path extension
ggplot2::ggsave(path, gg_sales)

  # Installing and calling extrafont and Cairo
  # 02_37_analysis-extrafont.R
install.packages("extrafont")
install.packages("Cairo")
library(extrafont)
library(Cairo)

  # Importing Fonts
  # 02_38_analysis-extrafont-font-import.R
extrafont::font_import()

  # Registering Fonts
  # 02_39_analysis-extrafont-loadfonts.R
extrafont::loadfonts()

  # Get available fonts
  # 02_40_analysis-extrafont-font.R
extrafont::fonts()
extrafont::fonts() |>
  stringr::str_subset("Yu")

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

  # Changing the theme
  # 02_43_analysis-ggplot-theme.R
gg <- 
  tibble::tibble(x = rnorm(100), y = runif(100)) |>
  ggplot2::ggplot(ggplot2::aes(x, y)) +
  ggplot2::geom_point() +  # scatter plot
  ggplot2::theme_bw()      # Change to a simple black and white theme
gg

  # Splitting a data frame into a list
  # 02_44_analysis-purrr-split-area.R
group_split(answer_mutated, area)

  # Repeat aggregation
  # 02_45_analysis-purrr-answer.R
group_split(answer_mutated, area) |>
  purrr::map(count_multi, "apps", ";") |>
  purrr::map(dplyr::arrange, desc(n))

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

  # Show listed graphs
  # 02_47_analysis-purrr-split-imap-gg.R
gg_sales_split[[2]] # Second graph 

  # save multiple plots
  # 02_48_analysis-purrr-split-map2.R
pdfs <- 
  paste0(names(gg_sales_split), ".pdf") |>
  fs::path_temp()
purrr::map2(pdfs, gg_sales_split, ggsave, 
            device = cairo_pdf, width = 7, height = 7)
  # shell.exec(pdfs[1])

  # function in error when 2
  # 02_49_analysis-purrr-possibly-prep.R
error_if_two <- function(x){
  if(x == 2){
    stop("Error")
  }else{
    return(x)
  }
}

  # Handling errors in iterative processing
  # 02_50_analysis-purrr-possibly.R
purrr::map(1:3, error_if_two)  # when left as is
error_if_two_possibly <- possibly(error_if_two, otherwise = 0) # 0 if error
purrr::map_dbl(1:3, error_if_two_possibly)

  # basic functions for sequential processing
  # 02_51_analysis-purrr-reduce-add.R
accumulate(1:4, `*`)
reduce(1:4, `*`)

  # A function to add new stuff
  # 02_52_analysis-purrr-paste-if-new-fun.R
paste_if_new <- function(x, y){
  pattern <- paste0("(^|;)+", y, "(;|$)+")
  if(stringr::str_detect(x, pattern)){
    x
  }else{
    paste0(x, ";", y)
  }
}

  # Sequential function execution
  # 02_53_analysis-purrr-reduce.R
answer_mutated |> 
  dplyr::summarise(apps = reduce(apps, paste_if_new), 
                   .by = c(area, satisfy)) |>
  print(n = 3)

