setwd("/home/ishigohoka/projects/Miriam/PhD/PhD/inv_freq_abc/output/demography/post_ms_slim")

sim <- read.table("/home/ishigohoka/projects/Miriam/PhD/PhD/inv_freq_abc/output/demography/post_ms_slim/model_2_1_2_posterior_ms_out.txt", header=T)
obs <- read.table("/home/ishigohoka/projects/Miriam/PhD/PhD/inv_freq_abc/output/demography/blackcap/observed_out.txt", header=T)

params <- colnames(sim)[-1]


sim_noD <- sim[, params[grep("^D_.*", params, invert = T)]]
obs_noD <- obs[params[grep("^D_.*", params, invert = T)]]
params <- colnames(obs_noD)

d <- rbind(obs_noD, sim_noD)


pdf("posterior_sim_obs.pdf")
for(param in params){
        hist(d[, param],
             main = param
        )
        abline(v = obs_noD[param],
               col = 2,
               lty = 2
        )
}
dev.off()

