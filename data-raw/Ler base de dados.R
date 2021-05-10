paralisadas <-
  readxl::read_xlsx("data-raw/paralisadas_2020.xlsx")


paralisadas <- paralisadas %>%
  janitor::clean_names()

readr::write_rds(paralisadas, "data-raw/paralisadas.rds")

dplyr::glimpse(paralisadas)
