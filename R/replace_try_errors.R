replace_try_errors <- function(sim_list) {
    lapply(
        sim_list,
        function(df) {
            if(class(df) == "data.frame")
                return(df)
            else 
                return(NULL)
        }
    ) |> dplyr::bind_rows()
}
