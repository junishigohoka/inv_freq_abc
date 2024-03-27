setwd("/home/ishigohoka/projects/Miriam/PhD/PhD/inv_freq_abc/output/demography/abcrf")

library(abcrf)


models <- paste0("model_", c("1_1_1", "1_1_2", "1_2_1", "1_2_2", "2_1_1", "2_1_2", "2_2_1", "2_2_2"))



# Read simulation log

if(length(list.files(pattern="sim_models.rds"))==0){
        d_log_list <- list()
        log_modsimids <- c()
        for(i in 1:length(models)){
                model <- models[i]
                print(model)
                d_tmp <- read.table(paste0("../ms/", model, "_log.txt.gz"), header = T)
                d_tmp$modsimid <- paste0(model, "_", d_tmp$simid)
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
                d_tmp <- read.table(paste0("../ms/", model, "_out.txt.gz"), header = T)
                d_tmp$modsimid <- paste0(model, "_", d_tmp$simid)
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
        saveRDS(nsims, "nsims.rds")

        # A vector of Models
        sim_models <- as.factor(rep(models, nsims))
        saveRDS(sim_models, "sim_models.rds")



        # Reference table
        ref_tab <- do.call(rbind, d_list)
        ref_tab <- ref_tab[, -c(1, ncol(ref_tab))]
        #ref_tab <- cbind(data.frame(model = sim_models), ref_tab)




        # Read observed data

        d_obs <- read.table("../blackcap/observed_out.txt", header=T)


        # Remove Tajima's D
        ref_tab <- ref_tab[,-grep("D_", colnames(ref_tab))]
        d_obs <- d_obs[, -grep("D_", colnames(d_obs))]



        # Classification
        model_rf <- abcrf(formula = sim_models~.,
                          data = ref_tab,
                          ntree = 1000,
                          paral = T,
                          ncores = 8
        )


        # Save ref_tab and model_rf

        saveRDS(ref_tab,
                "ref_tab.rds"
        )
        saveRDS(model_rf,
                "model_rf.rds"
        )
        pdf("err_abcrf.pdf")
        err_abcrf <- err.abcrf(model_rf, training = ref_tab, paral = T)
        dev.off()
        saveRDS(err_abcrf, "err_abcrf.rds")

        # Model selection
        modsel_rf <- predict(object = model_rf,
                             obs = d_obs,
                             training = ref_tab,
                             ntree = 1000,
                             paral = T,
                             paral.predict = T
        )
        saveRDS(modsel_rf, "modsel_rf.rds")
}else{
        # Read observed data
        d_obs <- read.table("../blackcap/observed_out.txt", header=T)

        # Remove Tajima's D
        d_obs <- d_obs[, -grep("D_", colnames(d_obs))]
        ref_tab <- readRDS("ref_tab.rds")
        model_rf <- readRDS("model_rf.rds")
        nsims <- readRDS("nsims.rds")
        sim_models <- readRDS("sim_models.rds")
        err_abcrf <- readRDS("err_abcrf.rds")
}







modsel_rf <- readRDS("modsel_rf.rds")




