i <- as.integer(commandArgs(trailingOnly = TRUE)[1])


setwd("/home/ishigohoka/projects/Miriam/PhD/PhD/inv_freq_abc/output/demography/abcrf")

library(abcrf)



# Read log
d_log <- read.table(paste0("../ms/model_2_1_2_log.txt.gz"), header = T)
d_log$modsimids <- paste0("model_2_1_2_", d_log$simid)

# Remove fixed variables
vars <- c()
for(j in 1:ncol(d_log)){
        if(d_log[1, j] != d_log[2, j]){
                vars <- c(vars, j)
        }
}
d_log <- d_log[, vars]


# Read simulation output
d <- read.table(paste0("../ms/model_2_1_2_out.txt.gz"), header = T)
d$modsimids <- paste0("model_2_1_2_", d$simid)


# Keep replicates with both output and log
d_log <- subset(d_log, d_log$modsimids %in% d$modsimids)
d <- subset(d, d$modsimids %in% d_log$modsimids)


# Keep only parameters
d_log <- d_log[, -c(1,2, ncol(d_log))]

# Remove tajima's D
d <- d[, -grep("D_", colnames(d))]


# Keep only summary stats
d <- d[, -c(1, ncol(d))]



# Observed data

d_obs <- read.table("../blackcap/observed_out.txt", header=T)
d_obs <- d_obs[, -grep("D_", colnames(d_obs))]
d_obs <- d_obs[, -1]

param <- d_log[, i]
rf_model <- readRDS(paste0("regAbcrf_model_2_1_2_", colnames(d_log)[i], ".rds"))
estim <- rf_model$model.rf$predictions

ref_tab <- cbind(d_log[, i], d)

posterior <- predict(object = rf_model,
                     obs = d_obs, 
                     training = ref_tab,
                     paral = T,
                     rf.wrights = T
)


saveRDS(posterior, 
        paste0("model_2_1_2_posterior_", colnames(d_log)[i], ".rds")
)





