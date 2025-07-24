  # simple summary
  # 02_27_analysis-dplyr-straight-summary.R
dplyr::count(answer_mutated, area)  |> # Single answer, simple tally
  print(n = 3)
count_multi(answer_mutated, "apps") |> # Multiple answers, simple tally
  print(n = 3)

