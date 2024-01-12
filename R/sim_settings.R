#simulation set-up
library(dplyr)

test_setting <- expand.grid(N_sample = c(100, 250),
                            N_sim = c(5),
                       M = c(10),
                       p_miss = c(0.1))

test_setting <- test_setting |>
    dplyr::mutate(set_n = seq(1, length(test_setting$N_sample), 1))

saveRDS(test_setting, 'test_setting.rds')

setting <- expand.grid(N_sample = c(250),
                       N_sim = c(200),
                       M = c(10, 25, 50),
                       p_miss = c(0.1, 0.5, 0.75))

setting <- setting |>
    dplyr::mutate(set_n = seq(1, length(setting$N_sample), 1))

saveRDS(setting, 'setting.rds')

#####################
# ARX Sim Settings
#####################

test_setting <- expand.grid(N_sample = c(500),
                            N_sim = c(5),
                            M = c(5, 10),
                            p_miss = c(0.1))

test_setting <- test_setting |>
    dplyr::mutate(set_n = seq(1, length(test_setting$N_sample), 1))

saveRDS(test_setting, 'test_setting_arx.rds')

setting <- expand.grid(N_sample = c(500),
                       N_sim = c(500),
                       p_miss = c(0.1, 0.5, 0.75),
                       M = c(10, 25, 50))

setting <- setting |>
    dplyr::mutate(set_n = seq(1, length(setting$N_sample), 1))

saveRDS(setting, 'setting_arx.rds')



#####################
# ARX Sim Settings
#####################

test_setting <- expand.grid(N_sample = c(500),
                            N_sim = c(5),
                            M = c(5, 10),
                            p_miss = c(0.1))

test_setting <- test_setting |>
    dplyr::mutate(set_n = seq(1, length(test_setting$N_sample), 1))

saveRDS(test_setting, 'test_setting_arx2.rds')

setting <- expand.grid(N_sample = c(250, 500, 1000),
                       N_sim = c(100),
                       p_miss = c(0.1, 0.5, 0.75))

setting <- setting |>
    dplyr::mutate(set_n = seq(1, length(setting$N_sample), 1),
                  M = p_miss * 100)

saveRDS(setting, 'setting_arx2.rds')
