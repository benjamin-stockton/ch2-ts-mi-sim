library(purrr)
library(dplyr)
library(ggplot2)
library(rsimsum)

source("R/create_res_summary.R")

setting <- readRDS("setting_arx2.rds")

ll <- c(1,2,4,7)

res_sum <- create_res_sum(ll = ll, file_prefix = "sim-results-mar-ts-mi-sim_setting-",
                          file_suffix = ".csv", analysis_models = c("arx"))

res_sum

sim4 <- readRDS("sim-results/sim-results-mar-ts-mi-2024-05-17-sim_setting-4.rds")

lapply(sim4, function(elem) {
    class(elem)
}) |> unlist()

sim4[[7]]
sim4[[132]]

source("R/replace_try_errors.R")

sim_df <- lapply(c(9), function(id) {
    sim_list <- readRDS(paste0("sim-results/sim-results-mar-ts-mi-low-ar-2024-06-01-sim_setting-", id, ".rds"))
    
    sim_df <- replace_try_errors(sim_list)
    sim_df$set_n <- id
    
    readr::write_csv(sim_df, paste0("sim-results/sim-results-mar-ts-mi-low-ar-2024-06-01-sim_setting-", id, ".csv"))
})

library(dplyr)



#############################################

sim_remove_duplicates <- function(files, f_out, dir, ind) {
    sim_list <- lapply(files, function(f) {
        tmp <- readr::read_csv(file.path(dir, f))
        tmp$set_n <- ind
        return(tmp)
    })
    
    sim_df <- sim_list |>
        bind_rows() |>
        distinct()
    
    readr::write_csv(sim_df, file = file.path(dir, f_out))
    return(sim_df)
}

sim1 <- sim_remove_duplicates(files = c("sim-results-mar-ts-mi-low-ar-sim_setting-1.csv",
                                        "sim-results-mar-ts-mi-low-ar-2024-05-17-sim_setting-1.csv",
                                        "sim-results-mar-ts-mi-low-ar-2024-05-21-sim_setting-1.csv"),
                              f_out = "sim-results-mar-ts-mi-low-ar-sim_setting-1.csv",
                              dir = "sim-results",
                              ind = 1)

sim1 |>
    group_by(term, set_n, method, analysis_model) |>
    summarize(
        n = n()
    )


sim2 <- sim_remove_duplicates(files = c("sim-results-mar-ts-mi-low-ar-sim_setting-2.csv",
                                        "sim-results-mar-ts-mi-low-ar-2024-05-17-sim_setting-2.csv",
                                        "sim-results-mar-ts-mi-low-ar-2024-05-21-sim_setting-2.csv"),
                              f_out = "sim-results-mar-ts-mi-low-ar-sim_setting-2.csv",
                              dir = "sim-results",
                              ind = 2)

sim2 |>
    group_by(term, set_n, method, analysis_model) |>
    summarize(
        n = n()
    )

sim3 <- sim_remove_duplicates(files = c("sim-results-mar-ts-mi-low-ar-sim_setting-3.csv",
                                        "sim-results-mar-ts-mi-low-ar-2024-05-17-sim_setting-3.csv",
                                        "sim-results-mar-ts-mi-low-ar-2024-05-25-sim_setting-3.csv",
                                        "sim-results-mar-ts-mi-low-ar-2024-05-31-sim_setting-3.csv"),
                              f_out = "sim-results-mar-ts-mi-low-ar-sim_setting-3.csv",
                              dir = "sim-results",
                              ind = 3)

sim3 |>
    group_by(term, set_n, method, analysis_model) |>
    summarize(
        n = n()
    )

sim4 <- sim_remove_duplicates(files = c("sim-results-mar-ts-mi-low-ar-sim_setting-4.csv",
                                        "sim-results-mar-ts-mi-low-ar-2024-05-17-sim_setting-4.csv",
                                        "sim-results-mar-ts-mi-low-ar-2024-05-21-sim_setting-4.csv"),
                              f_out = "sim-results-mar-ts-mi-low-ar-sim_setting-4.csv",
                              dir = "sim-results",
                              ind = 4)

sim4 |>
    group_by(term, set_n, method, analysis_model) |>
    summarize(
        n = n()
    )

sim5 <- sim_remove_duplicates(files = c("sim-results-mar-ts-mi-low-ar-sim_setting-5.csv",
                                        "sim-results-mar-ts-mi-low-ar-2024-05-17-sim_setting-5.csv",
                                        "sim-results-mar-ts-mi-low-ar-2024-05-31-sim_setting-5.csv"),
                              f_out = "sim-results-mar-ts-mi-low-ar-sim_setting-5.csv",
                              dir = "sim-results",
                              ind = 5)

sim5 |>
    group_by(term, set_n, method, analysis_model) |>
    summarize(
        n = n()
    )

sim6 <- sim_remove_duplicates(files = c("sim-results-mar-ts-mi-low-ar-sim_setting-6.csv",
                                        "sim-results-mar-ts-mi-low-ar-2024-06-01-sim_setting-6.csv"),
                              f_out = "sim-results-mar-ts-mi-low-ar-sim_setting-6.csv",
                              dir = "sim-results",
                              ind = 6)

sim6 |>
    group_by(term, set_n, method, analysis_model) |>
    summarize(
        n = n()
    )

sim7 <- sim_remove_duplicates(files = c("sim-results-mar-ts-mi-low-ar-sim_setting-7.csv",
                                        "sim-results-mar-ts-mi-low-ar-2024-05-17-sim_setting-7.csv",
                                        "sim-results-mar-ts-mi-low-ar-2024-05-21-sim_setting-7.csv"),
                              f_out = "sim-results-mar-ts-mi-low-ar-sim_setting-7.csv",
                              dir = "sim-results",
                              ind = 7)

sim7 |>
    group_by(term, set_n, method, analysis_model) |>
    summarize(
        n = n()
    )

sim8 <- sim_remove_duplicates(files = c("sim-results-mar-ts-mi-low-ar-sim_setting-8.csv",
                                        "sim-results-mar-ts-mi-low-ar-2024-05-17-sim_setting-8.csv",
                                        "sim-results-mar-ts-mi-low-ar-2024-06-01-sim_setting-8.csv"),
                              f_out = "sim-results-mar-ts-mi-low-ar-sim_setting-8.csv",
                              dir = "sim-results",
                              ind = 8)

sim8 |>
    group_by(term, set_n, method, analysis_model) |>
    summarize(
        n = n()
    )


sim9 <- sim_remove_duplicates(files = c("sim-results-mar-ts-mi-low-ar-sim_setting-9.csv",
                                        "sim-results-mar-ts-mi-low-ar-2024-06-01-sim_setting-9.csv",
                                        "sim-results-mar-ts-mi-low-ar-2024-06-01-sim_setting-9-2.csv"),
                              f_out = "sim-results-mar-ts-mi-low-ar-sim_setting-9.csv",
dir = "sim-results",
ind = 9)

sim9 |>
    group_by(term, set_n, method, analysis_model) |>
    summarize(
        n = n()
    )

#######################################################

sum_sim <- list(sim1, sim2, sim3,
                sim4, sim5, sim6,
                sim7, sim8, sim9) |>
    bind_rows() |>
    mutate(
        moe = se * qt(0.975, df = df),
        l95 = estimate - moe,
        u95 = estimate + moe,
        term2 = case_when(
            term == "(Intercept)" ~ "intercept",
            TRUE ~ term
        )
    ) |>
    filter(analysis_model == "arx") |>
    group_by(set_n, term2, method) |>
    summarize(
        n = n(),
        bias = mean(estimate - par_val),
        se_bias = sqrt(1/(n*(n-1)) * sum((estimate - par_val)^2)),
        cov = mean((l95 < par_val) & (u95 > par_val)),
        se_cov = sqrt(cov*(1-cov) / n)
    ) |>
    left_join(setting, by = "set_n") |>
    # tidyr::pivot_wider(id_cols = c("set_n", "method"),
    #                    names_from = "term",
    #                    values_from = c("bias"))
    print(n = 42)

library(ggplot2)
ggplot(sum_sim, aes(method, bias, color = as.factor(p_miss))) +
    geom_hline(yintercept = 0, color = "black", linetype = "dashed") +
    geom_point() +
    geom_errorbar(aes(ymin = bias - qt(0.975, df = n-1) * se_bias,
                      ymax = bias + qt(0.975, df = n-1) * se_bias),
                  width = 0.2) +
    scale_color_viridis_d(option = "D") +
    facet_grid(N_sample~term2) +
    theme_bw()

ggplot(sum_sim, aes(method, cov, color = as.factor(p_miss))) +
    geom_hline(yintercept = 0.95, color = "black", linetype = "dashed") +
    geom_point() +
    geom_errorbar(aes(ymin = cov - qt(0.975, df = n-1) * se_cov,
                      ymax = cov + qt(0.975, df = n-1) * se_cov),
                  width = 0.2) +
    scale_color_viridis_d(option = "D") +
    facet_grid(N_sample~term2) +
    theme_bw()

sum_sim |>
    filter(
        term2 == "U1"
    ) |>
    ggplot(aes(method, n)) +
        geom_col() +
        facet_wrap(set_n~.)

