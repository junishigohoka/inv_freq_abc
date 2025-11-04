i <- as.integer(commandArgs(trailingOnly = TRUE)[1])


setwd("/home/ishigohoka/projects/Miriam/PhD/PhD/inv_freq_abc/output/inv/abcrf/parinf")

library(abcrf)


# Read log
d_log <- read.table(paste0("../../slim/summary/sim_inv_2_3_log.txt.gz"), header = F)
colnames(d_log) <- c("modsimids", "seed", paste0("s", 0:10), paste0("h", 0:10))
d_log <- d_log[, c("modsimids", "s1", "s5", "h1", "h5")]
colnames(d_log) <- c("modsimids", "s_cont", "s_isl", "h_cont", "h_isl")



# Read simulation output
d <- read.table(paste0("../../slim/summary/sim_inv_2_3_out.txt.gz"), header = F)
colnames(d) <- c("modsimids", paste0("p", 1:10))


# Keep replicates with both output and log
d_log <- subset(d_log, d_log$modsimids %in% d$modsimids)
d <- subset(d, d$modsimids %in% d_log$modsimids)


# Keep only parameters
d_log <- d_log[, -1]

# Keep only summary stats
d <- d[, -1]


# Loop over parameters to estimate
param <- d_log[, i]

# Use log for selection coef but not dominance coef


if(i %in% c(1,2)){
        model <- regAbcrf(formula = log10(param)~.,
                                  data = d,
                                  ntree = 1000,
                                  paral = T)
}else{
        model <- regAbcrf(formula = param~.,
                                  data = d,
                                  ntree = 1000,
                                  paral = T)
}
saveRDS(model, paste0("regAbcrf_sim_inv_2_3_", colnames(d_log)[i], ".rds"))

