library(dplyr)
library(purrr)

#################################################
## Test: MAR TS with Incompleteness only on Angles ##
#################################################

setting <- readRDS("test_setting_arx2.rds")

# setting.l <- as.list(setting%>%filter(set_n!=1))

purrr::pwalk(.l = setting,
             .f = function(N_sample, N_sim, p_miss, M, set_n){
                 cat(
                     whisker::whisker.render(
                         readLines('tmpls/test-mar-ts-mi-sim.tmpl'),
                         data = list(
                             N_sample = N_sample,
                             N_sim = N_sim,
                             M = M,
                             p_miss = p_miss,
                             set_n = set_n)
                     ),
                     file = file.path('sim_scripts',
                                      sprintf("test-mar-ts-mi-sim_setting-%s.R",
                                              set_n)
                     ),
                     sep='\n')
             })

source("R/create_bash_scripts.R")

create_bash_scripts("sim_scripts",
                    script_base_name = "test-mar-ts-mi-sim_setting-%s.R",
                    sh_name = "test-mar-ts-mi-sim.sh",
                    setting = setting)

#################################################
## MAR TS with Incompleteness only on Angles ##
#################################################

setting <- readRDS("setting_arx2.rds")

# setting.l <- as.list(setting%>%filter(set_n!=1))

purrr::pwalk(.l = setting,
             .f = function(N_sample, N_sim, p_miss, M, set_n){
                 cat(
                     whisker::whisker.render(
                         readLines('tmpls/mar-ts-mi-sim.tmpl'),
                         data = list(
                             N_sample = N_sample,
                             N_sim = N_sim,
                             M = M,
                             p_miss = p_miss,
                             set_n = set_n)
                     ),
                     file = file.path('sim_scripts',
                                      sprintf("mar-ts-mi-sim_setting-%s.R",
                                              set_n)
                     ),
                     sep='\n')
             })

source("R/create_bash_scripts.R")

create_bash_scripts("sim_scripts",
                    script_base_name = "mar-ts-mi-sim_setting-%s.R",
                    sh_name = "mar-ts-mi-sim.sh",
                    setting = setting)

#################################################
## Test: MAR TS with Incompleteness only on Angles ##
#################################################

setting <- readRDS("test_setting.rds")

# setting.l <- as.list(setting%>%filter(set_n!=1))

purrr::pwalk(.l = setting,
             .f = function(N_sample, N_sim, p_miss, M, set_n){
                 cat(
                     whisker::whisker.render(
                         readLines('tmpls/mar-ts-mi-lm-sim.tmpl'),
                         data = list(
                             N_sample = N_sample,
                             N_sim = N_sim,
                             M = M,
                             p_miss = p_miss,
                             set_n = set_n)
                     ),
                     file = file.path('sim_scripts',
                                      sprintf("test-mar-ts-mi-lm-sim_setting-%s.R",
                                              set_n)
                     ),
                     sep='\n')
             })

source("R/create_bash_scripts.R")

create_bash_scripts("sim_scripts",
                    script_base_name = "test-mar-ts-mi-lm-sim_setting-%s.R",
                    sh_name = "test-mar-ts-mi-lm-sim.sh",
                    setting = setting)

#################################################
## MAR TS with Incompleteness only on Angles ##
## LM Analysis Only              ##
#################################################

setting <- readRDS("setting.rds")

# setting.l <- as.list(setting%>%filter(set_n!=1))

purrr::pwalk(.l = setting,
             .f = function(N_sample, N_sim, p_miss, M, set_n){
                 cat(
                     whisker::whisker.render(
                         readLines('tmpls/mar-ts-mi-lm-sim.tmpl'),
                         data = list(
                             N_sample = N_sample,
                             N_sim = N_sim,
                             M = M,
                             p_miss = p_miss,
                             set_n = set_n)
                     ),
                     file = file.path('sim_scripts',
                                      sprintf("mar-ts-mi-lm-sim_setting-%s.R",
                                              set_n)
                     ),
                     sep='\n')
             })

source("R/create_bash_scripts.R")

create_bash_scripts("sim_scripts",
                    script_base_name = "mar-ts-mi-lm-sim_setting-%s.R",
                    sh_name = "mar-ts-mi-lm-sim.sh",
                    setting = setting)

#################################################
## Test: MAR TS ARX Analysis with Incompleteness only on Angles ##
#################################################

setting <- readRDS("test_setting_arx.rds")

# setting.l <- as.list(setting%>%filter(set_n!=1))

purrr::pwalk(.l = setting,
             .f = function(N_sample, N_sim, p_miss, M, set_n){
                 cat(
                     whisker::whisker.render(
                         readLines('tmpls/mar-ts-mi-arima-sim.tmpl'),
                         data = list(
                             N_sample = N_sample,
                             N_sim = N_sim,
                             M = M,
                             p_miss = p_miss,
                             set_n = set_n)
                     ),
                     file = file.path('sim_scripts',
                                      sprintf("test-mar-ts-mi-arima-sim_setting-%s.R",
                                              set_n)
                     ),
                     sep='\n')
             })

source("R/create_bash_scripts.R")

create_bash_scripts("sim_scripts",
                    script_base_name = "test-mar-ts-mi-arima-sim_setting-%s.R",
                    sh_name = "test-mar-ts-mi-arima-sim.sh",
                    setting = setting)

#################################################
## MAR TS with Incompleteness only on Angles ##
## ARX Analysis Only            ##
#################################################

setting <- readRDS("setting_arx.rds")

# setting.l <- as.list(setting%>%filter(set_n!=1))

purrr::pwalk(.l = setting,
             .f = function(N_sample, N_sim, p_miss, M, set_n){
                 cat(
                     whisker::whisker.render(
                         readLines('tmpls/mar-ts-mi-arima-sim.tmpl'),
                         data = list(
                             N_sample = N_sample,
                             N_sim = N_sim,
                             M = M,
                             p_miss = p_miss,
                             set_n = set_n)
                     ),
                     file = file.path('sim_scripts',
                                      sprintf("mar-ts-mi-arima-sim_setting-%s.R",
                                              set_n)
                     ),
                     sep='\n')
             })

source("R/create_bash_scripts.R")

create_bash_scripts("sim_scripts",
                    script_base_name = "mar-ts-mi-arima-sim_setting-%s.R",
                    sh_name = "mar-ts-mi-lm-sim.sh",
                    setting = setting)

