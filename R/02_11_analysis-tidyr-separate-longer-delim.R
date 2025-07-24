  # Split data into vertical direction
  # 02_11_analysis-tidyr-separate-longer-delim.R
answer_tidy <- answer_wide |> # data/answer_tidy.csv
tidyr::separate_longer_delim(apps, delim = ";") |> # split with ";"
  tidyr::replace_na(list(apps = "-", comment = "")) # replace NA
head(answer_tidy, 3)

