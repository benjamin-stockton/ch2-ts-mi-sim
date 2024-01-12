simsum_plots <- function(res_sum, var, true_val, analysis_models = c("lm", "arx")) {
    s0 <- res_sum[which(res_sum$term == var),] |>
        filter(
            analysis_model %in% c(analysis_models)
        )
    
    s0 <- s0 |>
        simsum(estvarname = "estimate", se = "se", true = true_val, df = "df",
               methodvar = "method", ref = "complete", 
               by = c("set_n", "analysis_model"), x = TRUE)
    
    smry_0 <- summary(s0)
    
    p0 <- autoplot(s0, type = "est_ridge")
    p1 <- autoplot(smry_0, type = "lolly", "bias")
    p2 <- autoplot(smry_0, type = "lolly", "cover")
    p3 <- autoplot(smry_0, type = "lolly", "becover")
    
    p4 <- cowplot::plot_grid(p0, p1, p2, p3, nrow = 2)
    return(list(summary = smry_0,
                p_bias = p1,
                p_cov = p2,
                p_becov = p3,
                p_grid = p4))
}

create_res_sum <- function(ll, load_rds = FALSE, file_prefix = "sim-results_", file_suffix = ".csv", in_dir = "sim-results", out_dir = "sim-summary", analysis_models = "arx") {
    res_sum <-
        map_df(ll,
               .f = function(sc) {
                   x1 <- readr::read_csv(file.path(in_dir, paste0(file_prefix, sc, file_suffix)))
                   
                   
                   x1 |>
                       group_by(analysis_model, method, term) |>
                       mutate(
                           term = case_when(
                               term == "(Intercept)" ~ "intercept",
                               term == "intercept" ~ "intercept",
                               TRUE ~ term
                           ),
                           se = case_when(
                               !is.na(se) ~ se,
                               is.na(se) ~ sqrt(t),
                               TRUE ~ NA
                           ),
                           df = case_when(
                               !is.na(df) ~ df,
                               is.na(df) ~ 494,
                               TRUE ~ NA
                           ),
                           moe = qt(0.975, df = df) * se,
                           lb95 = estimate - moe,
                           ub95 = estimate + moe,
                           cov = case_when(
                               lb95 > par_val ~ 0,
                               ub95 < par_val ~ 0,
                               TRUE ~ 1
                           )
                       ) |>
                       # summarize(
                       #     n_sim = n(),
                       #     true_val = mean(par_val),
                       #     mean_est = mean(estimate),
                       #     mean_se = mean(se),
                       #     avg_bias = mean(estimate - par_val),
                       #     mse = mean((estimate - par_val)^2),
                       #     mad = mean(abs(estimate - par_val)),
                       #     ci_cov = mean(cov),
                       #     ci_width = mean(moe*2)
                       # ) |>
                   mutate(
                       set_n = sc
                   ) |>
                       left_join(setting, by = "set_n") |>
                       slice_head(n = 500)
                   
               })
    
    res_sum |>
        group_by(set_n, method, analysis_model, term) |>
        summarize(
            n_sim = n()
        ) |> 
        filter(term == "intercept") |>
        print(n = 30)
    
    mods <- paste(analysis_models, collapse = "-")
    f_out <- paste0("sum_", file_prefix, mods)
    print(file.path(out_dir, f_out))
    # saveRDS(res_sum, file = file.path(out_dir, paste0(f_out, ".rds")))
    readr::write_csv(res_sum, file = file.path(out_dir, paste0(f_out, ".csv")))
    
    simsum_plots(res_sum, var = "intercept", true_val = 5, analysis_models = analysis_models)
    simsum_plots(res_sum, var = "X1", true_val = 1, analysis_models = analysis_models)
    simsum_plots(res_sum, var = "X2", true_val = 0, analysis_models = analysis_models)
    simsum_plots(res_sum, var = "U1", true_val = 0.5, analysis_models = analysis_models)
    simsum_plots(res_sum, var = "U2", true_val = -0.25, analysis_models = analysis_models)
    
}


library(purrr)
library(dplyr)
library(ggplot2)
library(rsimsum)

setting <- readRDS("setting_arx2.rds")

ll <- c(1:5,7,8)

res_sum <- create_res_sum(ll = ll, file_prefix = "sim-results-mar-ts-mi-sim_setting-",
                          file_suffix = ".csv", analysis_models = c("arx"))

res_sum

sim7 <- readRDS("sim-results/sim-results-mar-ts-mi-2024-01-08-sim_setting-7.rds")

sim7_df <- sim7 |> bind_rows()
sim7[[159]] <- NULL
sim7[[408]] <- NULL
readr::write_csv(sim7_df, "sim-results/sim-results-mar-ts-mi-sim_setting-7.csv")
