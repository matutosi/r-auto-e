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

