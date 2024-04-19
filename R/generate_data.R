generate_data <- function(N_sample, population_parameters) {
    # Simulate N+1 X values; X[1,] corresponds to time 0
    X <- cbind(
        arima.sim(n = N_sample + 1, list(ar = c(0.24))),
        arima.sim(n = N_sample + 1, list(ar = c(0.75), ma = c(-0.25, 0.25)))
    )
    
    mu_0 <- population_parameters$mu_0
    B <- matrix(population_parameters$B_vec, nrow = 2, byrow = TRUE)
    mu <- X %*% B
    Psi <- matrix(population_parameters$Psi_vec, nrow = 2)
    Sigma <- matrix(population_parameters$Sigma_vec, nrow = 2)
    
    Y <- matrix(NA, nrow = N_sample, ncol = 2)
    U <- matrix(NA, nrow = N_sample, ncol = 2)
    Y[1,] <- mvtnorm::rmvnorm(1, mu_0 + mu[1,], Sigma)
    U[1,] <- Y[1,] / sqrt(Y[1,1]^2 + Y[1,2]^2)
    for (i in 2:N_sample) {
        Y[i,] <- mvtnorm::rmvnorm(1, Y[i-1,] %*% Psi + mu[i,], Sigma)
        U[i,] <- Y[i,] / sqrt(Y[i,1]^2 + Y[i,2]^2)
    }
    
    theta <- atan2(U[,2], U[,1])
    
    beta_y <- population_parameters$beta_y 
    beta_0 <- beta_y[1]
    sigma_y <- population_parameters$sigma_y
    psi_y <- population_parameters$psi_y
    
    X_mat <- cbind(X[2:(N_sample+1),], U)
    X_mat <- rbind(c(0,0), X_mat[2:N_sample,])
    
    # y_resp <- numeric(N_sample)
    # err <- rnorm(N_sample, 0, sigma_y)
    
    # y_resp[1] <- beta_0 + X_mat[1,] %*% beta_y[2:5] + err[1]
    y_resp <- arima.sim(n = N_sample+1, model = list(order = c(1,0,0), ar = c(psi_y)),
                        sd = sigma_y) 
    y_resp <- beta_0 + y_resp[2:(N_sample+1)] + X_mat %*% beta_y[2:5]
    
    # for(i in 2:N_sample) {
    #     y_resp[i] <- beta_0 + psi_y * y_resp[i-1] + X_mat[i,] %*% beta_y[2:5] + err[i]
    # }
    
    df <- data.frame(
        theta = theta,
        X1 = X_mat[,1],
        X2 = X_mat[,2],
        # X1_l = X[1:(N_sample),1],
        # X2_l = X[1:(N_sample),2],
        U1 = X_mat[,3],
        U2 = X_mat[,4],
        Y = y_resp
    )
    return(df)
}

impose_missingness <- function(df, freq = c(1), mech = "MAR", p_miss = 0.5) {
    mads_df <- ampute(data = df)
    
    amp_p <- mads_df$patterns[1,]
    amp_p[1, c(1, 4, 5)] <- 0
    
    amp_w <- mads_df$weights[1,]
    amp_w[1, c(1, 4, 5)] <- 0
    
    mads_df1 <- ampute(data = df, patterns = amp_p, prop = p_miss,
                       weights = amp_w, freq = freq, mech = mech)
    
    return(mads_df1$amp)
}

pop_par <- list(
    mu_0 = c(0,0),
    B_vec = c(1, 3, 0, -5),
    Psi_vec = c(0.75, -.2, -.2, .5),
    Sigma_vec = c(1,0,0,1),
    beta_y = c(5, 1, 0, 0.5, -0.25),
    sigma_y = 0.5,
    psi_y = 0.65
)

# df <- generate_data(500, pop_par)
# df |> head()
# ggplot(df, aes(theta, Y)) +
#     geom_point()
# ggplot(df, aes(X1, Y)) +
#     geom_point()
# ggplot(df, aes(X2, Y)) +
#     geom_point()
# 
# ggplot(df, aes(1:nrow(df), Y)) +
#     geom_line()
# 
# summary(lm(X1 ~ X1_l, data = df))
# 
# amp <- impose_missingness(df)
# md.pattern(amp)
# 
# imputeTS::ggplot_na_distribution(as.numeric(amp$Y))
# imputeTS::ggplot_na_distribution(as.numeric(amp$theta))
# 
# arima(df$Y, order = c(1,0,0), xreg = df[,c("X1", "X2", "U1", "U2")]) |> summary()
# pop_par$beta_y
# pop_par$psi_y
# pop_par$sigma_y
# 
# imps <- mice(amp, m = 5, method = "norm")
# 
# with_fit <- with(imps, lm(Y ~ X1 + X2 + U1 + U2))
# summary(pool(with_fit))
# round(summary(pool(with_fit))[,2], 3)
# 
# library(pnregstan)
# 
# df <- generate_data(500, pop_par)
# fit_pnarx <- fit_pn_arx_id_model(df$theta[1:400],
#                     X = df[1:400,c("X1", "X2")],
#                     X_ppd = df[401:500,c("X1", "X2")])
# fit_pnarx$summary(variables = c("B_mat", "auto_cor_mat"))
# 
# theta_ppd <- fit_pnarx$draws(variables = "theta_ppd") |>
#     posterior::as_draws_df() |>
#     as.matrix()
# 
# 
# bayesplot::ppc_ribbon(y = df$theta[1:400],
#                       yrep = theta_ppd[, 1:400])
# 
# bayesplot::ppc_ribbon(y = df$theta[401:500],
#                       yrep = theta_ppd[, 401:500])
