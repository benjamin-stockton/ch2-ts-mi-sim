#!/usr/bin/env bash 

cd .. 

echo "Running sim_scripts/test-mar-ts-mi-arima-sim_setting-1.R" 
time Rscript "sim_scripts/test-mar-ts-mi-arima-sim_setting-1.R"
echo "Running sim_scripts/test-mar-ts-mi-arima-sim_setting-2.R" 
time Rscript "sim_scripts/test-mar-ts-mi-arima-sim_setting-2.R"

echo "Done!"
