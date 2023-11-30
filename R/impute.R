impute <- function(data, l_method = "pmm", c_method = "bpnreg", M = 3, maxit = 5) {
    imp0 <- mice(data, method = l_method, m = 1, maxit = 0)
    
    mthd <- imp0$method
    
    mthd["theta"] <- c_method
    mthd["U1"] <- "~cos(theta)"
    mthd["U2"] <- "~sin(theta)"
    
    p_mat <- imp0$predictorMatrix
    p_mat[,"theta"] <- 0
    p_mat[c("U1", "U2"), ] <- 0
    p_mat[c("U1", "U2"), "theta"] <- 1
    p_mat["theta", c("U1", "U2")] <- 0
    
    imp <- mice(data, m = M, method = mthd, predictorMatrix = p_mat, maxit = maxit, printFlag = FALSE)
    
    return(imp)
}
