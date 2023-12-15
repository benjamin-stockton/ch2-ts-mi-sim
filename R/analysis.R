lm_analysis <- function(imp_data) {
    fit <- with(imp_data, lm(Y ~ X1 + X2 + U1 + U2))
    
    if (is.mira(fit)) {
        res_pool <- pool(fit)
        res2 <- res_pool$pooled
        res2$se <- sqrt(res2$t)
        return(res2)
    }
    else if (class(fit) == "lm") {
        smry <- summary(fit)
        
        res <- as.data.frame(smry$coefficients)
        colnames(res) <- c("estimate", "se", "t_val", "p_val")
        res$term <- rownames(res)
        res$df <- nrow(imp_data) - 5
        rownames(res) <- 1:nrow(res)
        return(res)
    }
}

arx_analysis <- function(imp_data) {
    fit <- with(imp_data, arima(Y, order = c(1,0,0), xreg = cbind(X1, X2, U1, U2)))
    
    if (is.mira(fit)) {
        res_pool <- pool(fit)
        res2 <- res_pool$pooled
        res2$se <- sqrt(res2$t)
        return(res2)
    }
    else if (class(fit) == "Arima") {
        smry <- summary(fit)
        
        res <- as.data.frame(cbind(estimate = coef(fit), se = sqrt(diag(vcov(fit)))))
        res$df <- nrow(imp_data) - 6
        res$t_val <- (res$estimate - 0) / res$se
        res$p_val <- 2 * pt(res$t_val, df = res$df, lower.tail = FALSE)
        res$term <- rownames(res)
        rownames(res) <- 1:nrow(res)
        return(res)
    }
}

gam_analysis <- function(imps) {
    
}
