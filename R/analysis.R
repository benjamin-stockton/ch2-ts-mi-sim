lm_analysis <- function(imp_data) {
    fit <- with(imp_data, lm(Y ~ X1 + X2 + U1 + U2))
    
    if (is.mira(fit)) {
        res_pool <- pool(fit)
        return(res_pool$pooled)
    }
    else if (class(fit) == "lm") {
        smry <- summary(fit)
        
        res <- as.data.frame(smry$coefficients)
        colnames(res) <- c("estimate", "std_err", "t_val", "p_val")
        res$term <- rownames(res)
        rownames(res) <- 1:nrow(res)
        return(res)
    }
    # 
    # pool_res$pooled |> 
    #     tidyr::pivot_longer(
    #         estimate:fmi, 
    #         names_to = "name", 
    #         values_to = "value"
    #     ) |> 
    #     dplyr::mutate(
    #         term_f6 = stringr::str_sub(term, 1, 6)
    #     ) |> 
    #     dplyr::filter(
    #         term_f6 != "spline"
    #     ) |> 
    #     dplyr::arrange(desc(name)) |>
    #     print(n = 20)
}

arx_analysis <- function(imps) {
    
}

gam_analysis <- function(imps) {
    
}
