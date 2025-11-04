setwd("/home/ishigohoka/projects/Miriam/PhD/PhD/inv_freq_abc/output/demography/abcrf")

pars_all <- unlist(strsplit(readLines("../ms/model_2_1_2_log.txt.gz", n=1), " "))[-c(1,2)]

pars <- c()
posterior <- c()

for(i in 1:length(pars_all)){
        if(length(list.files(pattern = paste0("model_2_1_2_posterior_", pars_all[i], ".rds"))) == 1){
                pars <- c(pars, pars_all[i])
                posterior <- c(posterior, 10^readRDS(paste0("model_2_1_2_posterior_", pars_all[i], ".rds"))$med[1])
        }
}




posterior <- as.data.frame(t(as.matrix(posterior)))
colnames(posterior) <- pars


write.table(posterior,
            "model_2_1_2_posterior_med_for_ms.txt",
            col.names = T,
            quote = F,
            row.names = F
)


pars <- c()
expct <- c()
med<- c()
lo <- c()
hi <- c()

for(i in 1:length(pars_all)){
        if(length(list.files(pattern = paste0("model_2_1_2_posterior_", pars_all[i], ".rds"))) == 1){
                pars <- c(pars, pars_all[i])
                expct <- c(expct, 10^readRDS(paste0("model_2_1_2_posterior_", pars_all[i], ".rds"))$expectation[1])
                med <- c(med, 10^readRDS(paste0("model_2_1_2_posterior_", pars_all[i], ".rds"))$med[1])
                lo <- c(lo, 10^readRDS(paste0("model_2_1_2_posterior_", pars_all[i], ".rds"))$quantiles[1,1])
                hi <- c(hi, 10^readRDS(paste0("model_2_1_2_posterior_", pars_all[i], ".rds"))$quantiles[1,2])
        }
}

d <- data.frame(parameter=pars, expectation = expct, median=med, q2.5=lo, q97.5=hi)

write.table(d, "model_2_1_2_posterior_summary.txt",
            row.names = F,
            quote = F
)

