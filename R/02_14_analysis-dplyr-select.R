  # Selecting and excluding columns
  # 02_14_analysis-dplyr-select.R
dplyr::select(answer_joined, id, area, years) |> head(3) # select columsus
dplyr::select(sales_joined, -c(period, item)) |> head(3) # exclude columns

