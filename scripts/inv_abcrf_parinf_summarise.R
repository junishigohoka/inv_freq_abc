setwd("/home/ishigohoka/projects/Miriam/PhD/PhD/inv_freq_abc/output/inv/abcrf/parinf")
library(abcrf)

s_cont_predicted <- readRDS("sim_inv_2_3_posterior_s_cont.rds")
s_isl_predicted <- readRDS("sim_inv_2_3_posterior_s_isl.rds")
p_cont_predicted <- readRDS("sim_inv_2_3_posterior_h_cont.rds")
p_isl_predicted <- readRDS("sim_inv_2_3_posterior_h_isl.rds")

10^(c(s_cont_predicted$expectation, s_isl_predicted$expectation))
10^(c(s_cont_predicted$med, s_isl_predicted$med))
10^(c(s_cont_predicted$quantiles, s_isl_predicted$quantiles))
c(p_cont_predicted$expectation, p_isl_predicted$expectation)
c(p_cont_predicted$med, p_isl_predicted$med)
c(p_cont_predicted$quantiles, p_isl_predicted$quantiles)




