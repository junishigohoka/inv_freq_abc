setwd("/home/ishigohoka/projects/Miriam/PhD/PhD/inv_freq_abc/output/demography/abc")
# Library
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



# Parameter inference


d_log_2_1_2 <- d_log_list[[6]]

d_2_1_2_filtered <- subset(d, modsimid %in% d_log_2_1_2$modsimid)
d_log_2_1_2_filtered <- subset(d_log_2_1_2, modsimid %in% d_2_1_2_filtered$modsimid)



params <- c(
            "N_anc",
            "N_N0_1",
            "N_N0_2",
            "N_N0_3",
            "N_N0_5",
            "N_N0_6",
            "N_N0_7",
            "N_N0_8",
            "N_N0_9",
            "N_N0_10",
            "T_geo",
            "T_split",
            "mig_1_2",
            "mig_2_3",
            "mig_4_5",
            "mig_4_6",
            "mig_4_7",
            "mig_4_8",
            "mig_5_4",
            "mig_5_6",
            "mig_5_7",
            "mig_5_8",
            "mig_6_7",
            "mig_6_8",
            "mig_7_8"
)


res <- abc(target=d_obs_stats, 
           param = d_log_2_1_2_filtered[,params],
           sumstat = d_2_1_2_filtered[,-c(1, ncol(d_2_1_2_filtered))],
           tol=0.001,
           method="loclinear",
           transf = "log"
)

pdf("param_inf.pdf", height=15, width= 15)
par(mfrow = c(5,5))
for(param in params){
        hist(log10(res$adj.values[, param]),
             main = param,
             breaks = 100,
             border="gray",
             col = "gray",
             xlab = paste0("log10(", param, ")")
        )
        #mn <- mean(log10(res$adj.values[, param]))
        md <- median(log10(res$adj.values[, param]))
        lo <- quantile(log10(res$adj.values[, param]), 0.025)
        hi <- quantile(log10(res$adj.values[, param]), 0.975)
        abline(v = md)
        abline(v = hi,
               lty =2
        )
        abline(v = lo,
               lty =2
        )
        legend("topright",
               legend = paste0(c("median = ", "25 percentile = ", "75 percentile = "), sprintf("%.3f", c(md, hi, lo))),
               bty = 'n'
        )
}
dev.off()

write.table(
            res$adj.values,
            "model_2_1_2_posterior.txt",
            quote=F,
            row.names=F,
            col.names=T
)

save.image("abc_mod_sel.RData")

#load("abc_mod_sel.RData")




