  # Calculate mean
  # 02_21_analysis-dplyr-summarise.R
dplyr::group_by(answer_mutated, area) |> 
  dplyr::summarise(m_years = mean(years), m_satisfy = mean(satisfy))

