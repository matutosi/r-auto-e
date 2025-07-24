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

