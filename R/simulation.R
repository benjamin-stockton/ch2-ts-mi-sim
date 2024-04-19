library(mice)
library(imputeangles)

file_path <- file.path("R")
source(file.path(file_path, "generate_data.R"))
source(file.path(file_path, "impute.R"))
source(file.path(file_path, "analysis.R"))
source(file.path(file_path, "utils.R"))
# source(file.path("generate_data.R"))
# source(file.path("impute.R"))
# source(file.path("analysis.R"))
# source(file.path("utils.R"))

# From command line get the following arguments
N_sim <- 100 # Number of simulation iterations
N_sample <- 100 # Sample size
init_seed <- 1234 # Initial seed
M <- 5 # Number of imputations
pop_pars <- list(
    mu_0 = c(0,0),
    B_vec = c(1, 3, 0, -5),
    Psi_vec = c(0.75, -.2, -.2, .5),
    Sigma_vec = c(1,0,0,1),
    beta_y = c(5, 1, 0, 0.5, -0.25),
    sigma_y = 0.5,
    psi_y = 0.65
) # population parameters to draw samples from
miss_pars <- list(
    freq = c(1),
    mech = "MAR",
    p_miss = 0.5
) # Missingness mechanism parameters (also controls MAR/MNAR)

# methods <- c("complete", "bpnreg", "vmreg", "pnregid", "pnarxid")
methods <- c("complete", "locf", "norm")

# seeds <- matrix(NA, nrow = N_sim, ncol = 626)
# set.seed(init_seed)

# pars <- pop_pars, miss_pars, beta_hat, se_beta_hat, df_beta_hat, fmi, p_miss
# total_pars <- length(pop_pars) + length(miss_pars) + 4*P + 1

x1 <- parallel::mclapply(1:N_sim,
               mc.cores = 20,
                function(x) {
# x1 <- lapply(1:N_sim, function(x) {
    
    print(x)
    
    # seeds[1,] <- get.seed()
    sample_data <- generate_data(N_sample, pop_pars)
    
    inc_data <- impose_missingness(sample_data, 
                                   freq = miss_pars$freq, 
                                   mech = miss_pars$mech, 
                                   p_miss = miss_pars$p_miss)
    prop_miss <- apply(as.matrix(inc_data[,2:5]), 2, function(i) {mean(is.na(i))})
    
    iter_res <- lapply(methods, function(mtd) {
        if (mtd == "complete") {
            res_lm <- lm_analysis(sample_data)
            res_lm$prop_miss <- 0
            res_ar <- arx_analysis(sample_data)
            res_ar$prop_miss <- 0
        }
        else if (mtd == "locf") {
            imp_data <- impute(inc_data, l_method = "locf", c_method = mtd, M = M, maxit = 1)
            
            res_lm <- lm_analysis(imp_data)
            res_lm$prop_miss <- c(0,prop_miss)
            res_ar <- arx_analysis(imp_data)
            res_ar$prop_miss <- c(0, 0, prop_miss)
        }
        else {
            imp_data <- impute(inc_data, l_method = "pmm", c_method = mtd, M = M, maxit = 1)
            
            res_lm <- lm_analysis(imp_data)
            res_lm$prop_miss <- c(0,prop_miss)
            res_ar <- arx_analysis(imp_data)
            res_ar$prop_miss <- c(0, 0, prop_miss)
        }
        
        res_lm$analysis_model <- "lm"
        res_ar$analysis_model <- "arx"
        res <- dplyr::bind_rows(res_lm, res_ar)
        
        res$par_val <- c(pop_pars$beta_y, pop_pars$psi_y, pop_pars$beta_y)
        res$iter <- x
        res$method <- mtd
        return(res)
    })
    
    iter_res |> 
        dplyr::bind_rows() -> results
    
    return(results)
})

# out_path <- file.path("..", "..", "sim-results")
# 
# 
# saveRDS(x1, file = paste0(out_path, "/sim-results_", Sys.Date(), ".rds"))
# 
# x1 |> 
#     dplyr::bind_rows() |>
#     readr::write_csv(paste0(out_path, "/sim-results_", Sys.Date(), ".csv"))

# x1 <- readRDS("../../sim-results/sim-results_2023-11-30.rds")
# 
res <- x1 |> dplyr::bind_rows()

res |>
    group_by(term, method, analysis_model) |>
    summarize(
        mean_est = mean(estimate),
        bias_est = mean(estimate - par_val),
        mse = mean((estimate - par_val)^2)
    ) |>
    arrange(analysis_model, term, mse) |>
    print(n = 33)
