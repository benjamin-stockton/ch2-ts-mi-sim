generate_data <- function(N_sample, population_parameters) {
    X <- cbind(
        arima.sim(n = N_sample, list(ar = c(0.24))),
        arima.sim(n = N_sample, list(ar = c(0.75), ma = c(-0.25, 0.25)))
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
    sigma_y <- population_parameters$sigma_y
    psi_y <- population_parameters$psi_y
    
    X_mat <- cbind(rep(1, N_sample), X, U)
    y_resp <- numeric(N_sample)
    err <- rnorm(N_sample, 0, sigma_y)
    
    y_resp[1] <- X_mat[1,] %*% beta_y + err[1]
    
    for(i in 2:N_sample) {
        y_resp[i] <- psi_y * y_resp[i-1] + X_mat[i,] %*% beta_y + err[i]
    }
    
    df <- data.frame(
        theta = theta,
        X1 = X[,1],
        X2 = X[,2],
        U1 = U[,1],
        U2 = U[,2],
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

# pop_par <- list(
#     mu_0 = c(0,0),
#     B_vec = c(1, 3, 0, -5),
#     Psi_vec = c(0.75, -.2, -.2, .5),
#     Sigma_vec = c(1,0,0,1),
#     beta_y = c(5, 1, 0, 0.5, -0.25),
#     sigma_y = 0.5,
#     psi_y = 0.65
# )
# 
# df <- generate_data(500, pop_par)
# ggplot(df, aes(theta, Y)) +
#     geom_point()
# ggplot(df, aes(X1, Y)) +
#     geom_point()
# ggplot(df, aes(X2, Y)) +
#     geom_point()
# 
# ggplot(df, aes(1:500, Y)) +
#     geom_line()
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
# with_fit <- with(df, lm(Y ~ X1 + X2 + U1 + U2))
# summary(with_fit)
# with_fit$coefficients
