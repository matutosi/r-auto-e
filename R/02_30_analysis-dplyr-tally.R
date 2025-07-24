  # Shortcuts for counting
  # 02_30_analysis-dplyr-tally.R
dplyr::group_by(answer_mutated, area) |> dplyr::tally()
dplyr::count(answer_mutated, area)

