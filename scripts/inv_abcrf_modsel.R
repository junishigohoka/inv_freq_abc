setwd("/home/ishigohoka/projects/Miriam/PhD/PhD/inv_freq_abc/output/inv/abcrf")

library(abcrf)


models <- paste0("sim_inv_1_", 0:4)


# Read observed data

d_obs <- as.data.frame(t(as.matrix(read.table("../blackcap/chr_12_inv_pop_freq.txt")[,5])))
colnames(d_obs) <- paste0("p_", 1:10)

if(length(list.files(pattern = "ref_tab.rds")) == 0){
        # Read simulation log
        d_log_list <- list()
        log_modsimids <- c()
        for(i in 1:length(models)){
                model <- models[i]
                print(model)
                d_tmp <- read.table(paste0("../slim/summary/", model, "_log.txt.gz"), header = F)
                colnames(d_tmp)[1] <- "modsimid"
                log_modsimids <- c(log_modsimids, d_tmp$modsimid)
                d_log_list[[i]] <- d_tmp
                remove(d_tmp)
        }

        # Remove fixed variables

        for(i in 1:length(models)){
                vars <- c()
                for(j in 1:ncol(d_log_list[[i]])){
                        if(d_log_list[[i]][1, j] != d_log_list[[i]][2, j]){
                                vars <- c(vars, j)
                        }
                }
                d_log_list[[i]] <- d_log_list[[i]][, vars]
        }



        # Read simulation out

        d_list <- list()
        for(i in 1:length(models)){
                model <- models[i]
                print(model)
                d_tmp <- read.table(paste0("../slim/summary/", model, "_out.txt.gz"), header = F)
                colnames(d_tmp)[1] <- "modsimid"
                d_list[[i]] <- d_tmp
                remove(d_tmp)
        }


        # Keep simulations with complete log and data
        for(i in 1:length(models)){
                d_log_list[[i]] <- subset(d_log_list[[i]], modsimid %in% d_list[[i]]$modsimid)
                d_list[[i]] <- subset(d_list[[i]], modsimid %in% log_modsimids)
        }


        # Get number simulations of each model
        nsims <- sapply(d_log_list, nrow)



        # A vector of Models
        sim_models <- as.factor(rep(models, nsims))
        saveRDS(sim_models, "sim_models.rds")

        # Reference table
        ref_tab <- do.call(rbind, d_list)
        ref_tab <- ref_tab[, -1]
        colnames(ref_tab) <- paste0("p_", 1:10)
        
        saveRDS(ref_tab,
                "ref_tab.rds"
        )
}else{
        ref_tab <- readRDS("ref_tab.rds")
        nsims <- readRDS("sim_models")
}


if(length(list.files(pattern = "model_rf.rds")) == 0){
        model_rf <- abcrf(formula = sim_models~.,
                          data = ref_tab,
                          ntree = 1000,
                          paral = T,
                          ncores = 8
        )

        # Save ref_tab and model_rf
        saveRDS(model_rf,
                "model_rf.rds"
        )
}else{
        model_rf <- readRDS("model_rf.rds")
}




#pdf("err_abcrf.pdf")
#err_abcrf <- err.abcrf(model_rf, training = ref_tab, paral = T)
#dev.off()
#saveRDS(err_abcrf, "err_abcrf.rds")


# Model selection


if(length(list.files(pattern = "modsel_rf.rds")) == 0){
        modsel_rf <- predict(object = model_rf,
                             obs = d_obs,
                             training = ref_tab,
                             ntree = 1000,
                             paral = T,
                             paral.predict = T
        )
        saveRDS(modsel_rf, "modsel_rf.rds")
}
else{
        modsel_rf <- readRDS("modsel_rf.rds")
}

