library(mice, warn.conflicts = F, quietly = T)
library(imputeangles)

file_path <- file.path("R")
source(file.path(file_path, "generate_data.R"))
source(file.path(file_path, "impute.R"))
source(file.path(file_path, "analysis.R"))
source(file.path(file_path, "utils.R"))

# From command line get the following arguments
N_sim <- 250 # Number of simulation iterations
N_sample <- 1000 # Sample size
init_seed <- 1234 # Initial seed
init_seed <- 65843
M <- 50 # Number of imputations
pop_pars <- list(
    mu_0 = c(0,0),
    B_vec = c(0, 0.3, 0, -0.5),
    Psi_vec = c(0.2, -.02, -.02, .2),
    Sigma_vec = c(1,0,0,1),
    beta_y = c(5, 1, 0, 0.5, -0.25),
    sigma_y = 0.5,
    psi_y = 0.25
) # population parameters to draw samples from
miss_pars <- list(
    freq = c(1),
    mech = "MAR",
    p_miss = 0.5
) # Missingness mechanism parameters (also controls MAR/MNAR)

methods <- c("complete", "locf", "vmreg", "pnregid", "pnarxinc") # "bpnreg"

# seeds <- matrix(NA, nrow = N_sim, ncol = 626)
# set.seed(init_seed * set_n)

# pars <- pop_pars, miss_pars, beta_hat, se_beta_hat, df_beta_hat, fmi, p_miss
# total_pars <- length(pop_pars) + length(miss_pars) + 4*P + 1

x1 <- parallel::mclapply(1:N_sim,
               mc.cores = 125,
                function(x) {
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
           imp_data <- impute(inc_data, l_method = "pmm", c_method = mtd, M = M, maxit = 10)
           
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

out_path <- file.path("sim-results")


saveRDS(x1, file = paste0(out_path, "/sim-results-mar-ts-mi-low-ar-", Sys.Date(), "-sim_setting-", 9, ".rds"))

x2 <- x1 |> 
    dplyr::bind_rows()
f_out <- paste0(out_path, "/sim-results-mar-ts-mi-low-ar-sim_setting-", 9, ".csv")
if (file.exists(f_out)) {
    readr::write_csv(x2, f_out, append = TRUE)
} else {
    readr::write_csv(x2, f_out)
}
    
