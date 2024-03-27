setwd("/home/ishigohoka/projects/Miriam/PhD/PhD/inv_freq_abc/output/demography/abc")
# Library
library(vioplot)
library(abc)





models <- paste0("model_", c("1_1_1", "1_1_2", "1_2_1", "1_2_2", "2_1_1", "2_1_2", "2_2_1", "2_2_2"))

# Read simulation out
nsims <- c()
for(i in 1:length(models)){
        model <- models[i]
        print(model)
        d_tmp <- read.table(paste0("../ms/", model, "_out.txt.gz"), header = T)
        d_tmp$modsimid <- paste0(model, "_", d_tmp$simid)
        nsims <- c(nsims, nrow(d_tmp))
        if(i==1){
                d <- d_tmp
        }else{
                d <- rbind(d, d_tmp)
        }
        remove(d_tmp)
}


sim_models <- rep(models, nsims)


# Read simulation log

d_log_list <- list()
for(i in 1:length(models)){
        model <- models[i]
        print(model)
        d_tmp <- read.table(paste0("../ms/", model, "_log.txt.gz"), header = T)
        d_tmp$modsimid <- paste0(model, "_", d_tmp$simid)
        d_log_list[[i]] <- d_tmp
        remove(d_tmp)
}





# Read observed data

d_obs <- read.table("../blackcap/observed_out.txt", header=T)


# Remove Tajima's D
d <- d[,-grep("D_", colnames(d))]
d_obs <- d_obs[, -grep("D_", colnames(d_obs))]


# Make data frame only with summary stats
d_stats <- d[,2:(ncol(d)-1)]
d_obs_stats <- d_obs[,2:(ncol(d)-1)]


# Model selection
#

cv_mod_sel_mnlogistic <- cv4postpr(index = sim_models, 
                        sumstat = d_stats, 
                        nval=50, 
                        tol=.01, 
                        method="mnlogistic")

cv_mod_sel_rejection <- cv4postpr(index = sim_models, 
                        sumstat = d_stats, 
                        nval=50, 
                        tol=.01, 
                        method="rejection")

cv_mod_sel_neuralnet <- cv4postpr(index = sim_models, 
                        sumstat = d_stats, 
                        nval=50, 
                        tol=.01, 
                        method="neuralnet")


#load("abc_mod_sel.RData")

cv_mod_sel_mnlogistic.sum <- summary(cv_mod_sel_mnlogistic)
cv_mod_sel_rejection.sum <- summary(cv_mod_sel_rejection)
cv_mod_sel_neuralnet.sum <- summary(cv_mod_sel_neuralnet)

save.image("abc_mod_sel.RData")

