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
#cv_mod_sel_mnlogistic <- cv4postpr(index = sim_models, 
#                        sumstat = d_stats, 
#                        nval=50, 
#                        tol=.01, 
#                        method="mnlogistic")
#
#cv_mod_sel_rejection <- cv4postpr(index = sim_models, 
#                        sumstat = d_stats, 
#                        nval=10, 
#                        tol=.01, 
#                        method="rejection")

#cv_mod_sel_neuralnet <- cv4postpr(index = sim_models, 
#                        sumstat = d_stats, 
#                        nval=50, 
#                        tol=.01, 
#                        method="neuralnet")
#

#load("abc_mod_sel.RData")

#cv_mod_sel_mnlogistic.sum <- summary(cv_mod_sel_mnlogistic)
#cv_mod_sel_rejection.sum <- summary(cv_mod_sel_rejection)
#cv_mod_sel_neuralnet.sum <- summary(cv_mod_sel_neuralnet)

#save.image("abc_mod_sel.RData")
#load("abc_mod_sel.RData")

#pdf("confusion_mod_sel.pdf", width=15)
#mat <- matrix(c(1,1,1,1,2),
#              nrow=1
#)
#layout(mat)
#plot(cv_mod_sel_mnlogistic,
#     col=1:8,
#)
#mtext(3,
#      at=0,
#      text= "mnlogistic",
#      line=1,
#      cex=2
#)
#plot.new()
#legend(
#       "topleft",
#       legend=models,
#       fill = 1:8,
#       col = 1:8
#)
#plot(cv_mod_sel_rejection,
#     col=1:8
#)
#mtext(3,
#      at=0,
#      text= "rejection",
#      line=1,
#      cex=2
#)
#plot.new()
#legend(
#       "topleft",
#       legend=models,
#       fill = 1:8,
#       col = 1:8
#)

#plot(cv_mod_sel_neuralnet,
#     col=1:8
#)
#mtext(3,
#      at=0,
#      text= "neuralnet",
#      line=1,
#      cex=2
#)
#plot.new()
#legend(
#       "topleft",
#       legend=models,
#       fill = 1:8,
#       col = 1:8
#)
#dev.off()





# Posterior prob. of each demography model

#mod_sel_mnlogistic <- postpr(d_obs_stats, 
#                             sim_models, 
#                             d_stats, 
#                             tol = 0.01, 
#                             method = "mnlogistic"
#)
#
#
#summary(mod_sel_mnlogistic)

# Call: 
# postpr(target = d_obs_stats, index = sim_models, sumstat = d_stats, 
#     tol = 0.01, method = "mnlogistic")
# Data:
#  postpr.out$values (79798 posterior samples)
# Models a priori:
#  model_1_1_1, model_1_1_2, model_1_2_1, model_1_2_2, model_2_1_1, model_2_1_2, model_2_2_1, model_2_2_2
# Models a posteriori:
#  model_1_1_1, model_1_1_2, model_1_2_1, model_1_2_2, model_2_1_1, model_2_1_2, model_2_2_1, model_2_2_2
# Warning: Posterior model probabilities are corrected for unequal number of simulations per models.
# 
# 
# Proportion of accepted simulations (rejection):
# model_1_1_1 model_1_1_2 model_1_2_1 model_1_2_2 model_2_1_1 model_2_1_2 model_2_2_1 model_2_2_2 
#      0.0351      0.1176      0.0114      0.0399      0.1665      0.3630      0.0874      0.1791 
# 
# Bayes factors:
#             model_1_1_1 model_1_1_2 model_1_2_1 model_1_2_2 model_2_1_1 model_2_1_2 model_2_2_1 model_2_2_2
# model_1_1_1      1.0000      0.2983      3.0700      0.8871      0.2116      0.0969      0.4037      0.1959
# model_1_1_2      3.3525      1.0000     10.2921      2.9741      0.7094      0.3247      1.3533      0.6567
# model_1_2_1      0.3257      0.0972      1.0000      0.2890      0.0689      0.0315      0.1315      0.0638
# model_1_2_2      1.1272      0.3362      3.4606      1.0000      0.2385      0.1092      0.4550      0.2208
# model_2_1_1      4.7259      1.4097     14.5088      4.1925      1.0000      0.4577      1.9078      0.9257
# model_2_1_2     10.3247      3.0797     31.6969      9.1593      2.1847      1.0000      4.1679      2.0224
# model_2_2_1      2.4772      0.7389      7.6050      2.1976      0.5242      0.2399      1.0000      0.4852
# model_2_2_2      5.1051      1.5228     15.6729      4.5289      1.0802      0.4945      2.0609      1.0000
# 
# 
# Posterior model probabilities (mnlogistic):
# model_1_1_1 model_1_1_2 model_1_2_1 model_1_2_2 model_2_1_1 model_2_1_2 model_2_2_1 model_2_2_2 
#      0.0004      0.0004      0.0000      0.0009      0.0244      0.6588      0.0072      0.3079 
# 
# Bayes factors:
#             model_1_1_1 model_1_1_2 model_1_2_1 model_1_2_2 model_2_1_1 model_2_1_2 model_2_2_1 model_2_2_2
# model_1_1_1      1.0000      1.2033     19.0256      0.4742      0.0182      0.0007      0.0616      0.0014
# model_1_1_2      0.8310      1.0000     15.8106      0.3941      0.0151      0.0006      0.0512      0.0012
# model_1_2_1      0.0526      0.0632      1.0000      0.0249      0.0010      0.0000      0.0032      0.0001
# model_1_2_2      2.1088      2.5376     40.1214      1.0000      0.0383      0.0014      0.1300      0.0030
# model_2_1_1     54.9907     66.1727   1046.2320     26.0766      1.0000      0.0370      3.3897      0.0791
# model_2_1_2   1487.0988   1789.4916  28292.9763    705.1838     27.0427      1.0000     91.6681      2.1396
# model_2_2_1     16.2226     19.5214    308.6459      7.6928      0.2950      0.0109      1.0000      0.0233
# model_2_2_2    695.0269    836.3565  13223.3166    329.5824     12.6390      0.4674     42.8430      1.0000
# 
# 
# mod_sel_neuralnet <- postpr(d_obs_stats, 
#                              sim_models, 
#                              d_stats, 
#                              tol = 0.01, 
#                              method = "neuralnet"
# )

# summary(mod_sel_neuralnet)


#Call: 
#postpr(target = d_obs_stats, index = sim_models, sumstat = d_stats, 
#    tol = 0.01, method = "neuralnet")
#Data:
# postpr.out$values (79798 posterior samples)
#Models a priori:
# model_1_1_1, model_1_1_2, model_1_2_1, model_1_2_2, model_2_1_1, model_2_1_2, model_2_2_1, model_2_2_2
#Models a posteriori:
# model_1_1_1, model_1_1_2, model_1_2_1, model_1_2_2, model_2_1_1, model_2_1_2, model_2_2_1, model_2_2_2
#Warning: Posterior model probabilities are corrected for unequal number of simulations per models.
#
#
#Proportion of accepted simulations (rejection):
#model_1_1_1 model_1_1_2 model_1_2_1 model_1_2_2 model_2_1_1 model_2_1_2 model_2_2_1 model_2_2_2 
#     0.0481      0.1529      0.0173      0.0541      0.1375      0.3521      0.0701      0.1679 
#
#Bayes factors:
#            model_1_1_1 model_1_1_2 model_1_2_1 model_1_2_2 model_2_1_1 model_2_1_2 model_2_2_1 model_2_2_2
#model_1_1_1      1.0000      0.3144      2.7815      0.8958      0.3510      0.1368      0.6890      0.2862
#model_1_1_2      3.1803      1.0000      8.8459      2.8490      1.1163      0.4351      2.1913      0.9103
#model_1_2_1      0.3595      0.1130      1.0000      0.3221      0.1262      0.0492      0.2477      0.1029
#model_1_2_2      1.1163      0.3510      3.1049      1.0000      0.3918      0.1527      0.7691      0.3195
#model_2_1_1      2.8489      0.8958      7.9240      2.5521      1.0000      0.3898      1.9629      0.8154
#model_2_1_2      7.3091      2.2982     20.3300      6.5477      2.5656      1.0000      5.0360      2.0920
#model_2_2_1      1.4514      0.4564      4.0369      1.3002      0.5095      0.1986      1.0000      0.4154
#model_2_2_2      3.4938      1.0986      9.7178      3.1298      1.2264      0.4780      2.4072      1.0000
#
#
#Posterior model probabilities (neuralnet):
#model_1_1_1 model_1_1_2 model_1_2_1 model_1_2_2 model_2_1_1 model_2_1_2 model_2_2_1 model_2_2_2 
#     0.0000      0.0189      0.0000      0.0011      0.0000      0.8021      0.0000      0.1778 
#
#Bayes factors:
#             model_1_1_1  model_1_1_2  model_1_2_1  model_1_2_2  model_2_1_1  model_2_1_2  model_2_2_1  model_2_2_2
#model_1_1_1 1.000000e+00 0.000000e+00 1.645930e+01 8.000000e-04 1.413100e+00 0.000000e+00 7.182000e+00 0.000000e+00
#model_1_1_2 2.251562e+04 1.000000e+00 3.705914e+05 1.734500e+01 3.181652e+04 2.360000e-02 1.617070e+05 1.064000e-01
#model_1_2_1 6.080000e-02 0.000000e+00 1.000000e+00 0.000000e+00 8.590000e-02 0.000000e+00 4.363000e-01 0.000000e+00
#model_1_2_2 1.298103e+03 5.770000e-02 2.136587e+04 1.000000e+00 1.834332e+03 1.400000e-03 9.322962e+03 6.100000e-03
#model_2_1_1 7.077000e-01 0.000000e+00 1.164780e+01 5.000000e-04 1.000000e+00 0.000000e+00 5.082500e+00 0.000000e+00
#model_2_1_2 9.547568e+05 4.240420e+01 1.571463e+07 7.355017e+02 1.349154e+06 1.000000e+00 6.857054e+06 4.510400e+00
#model_2_2_1 1.392000e-01 0.000000e+00 2.291700e+00 1.000000e-04 1.968000e-01 0.000000e+00 1.000000e+00 0.000000e+00
#model_2_2_2 2.116798e+05 9.401500e+00 3.484102e+06 1.630686e+02 2.991218e+05 2.217000e-01 1.520282e+06 1.000000e+00



# Goodness of fit with PCA

#pdf("gof_pca.pdf")
#gfitpca(target=d_obs_stats, sumstat=d_stats, index=sim_models, cprob=.1)
#dev.off()

## Model_2_1_2 seems the best


# Parameter inference
## Cross-validation



d_log_2_1_2 <- d_log_list[[6]]

d_2_1_2_filtered <- subset(d, modsimid %in% d_log_2_1_2$modsimid)
d_log_2_1_2_filtered <- subset(d_log_2_1_2, modsimid %in% d_2_1_2_filtered$modsimid)



cv_res_loclinear_log <- cv4abc(param = d_log_2_1_2_filtered[,d_log_2_1_2_filtered[1,]!=0][,c(-1, -2, -7, -40)],
                               sumstat = d_2_1_2_filtered[,-c(1, (ncol(d_2_1_2_filtered)))],
                               nval = 100,
                               tols = 0.01,
                               method = "loclinear",
                               transf = "log"
)

cv_res_loclinear <- cv4abc(param = d_log_2_1_2_filtered[,d_log_2_1_2_filtered[1,]!=0][,c(-1, -2, -7, -40)],
                               sumstat = d_2_1_2_filtered[,-c(1, (ncol(d_2_1_2_filtered)))],
                               nval = 100,
                               tols = 0.01,
                               method = "loclinear"
                               #transf = "log"
)

plot_cv <- function(cv_res){
        params <- colnames(cv_res$true)
        for(i in 1:length(params)){
                param <- params[i]
                truth <- cv_res$true[[param]]
                estim <- cv_res$estim[[1]][,param]
                v0 <- min(c(truth, estim))
                v1 <- max(c(truth, estim))
                plot(1,
                     type = 'n',
                     xlim = c(v0, v1),
                     ylim = c(v0, v1),
                     main = param,
                     xlab = "Truth",
                     ylab = "Estimate",
                     log = 'xy'
                )
                segments(v0, v0, v1, v1)
                points(truth,
                       estim
                )
                legend("topleft",
                       legend = c(paste0("Pearson r = ", sprintf("%.3f",cor(log(truth), log(estim)))), paste0("Spearman r = ", sprintf("%.3f",cor(log(truth), log(estim), method = "spearman")))),
                       bty='n'
                )
        }
}



pdf("cv_param_loclinear_log.pdf", width= 15, height=15)
par(mfrow=c(5,5),
    oma = c(0,0,2,0)
)
plot_cv(cv_res_loclinear_log)
mtext(3, outer=T,
      text = "no transformation"
)
plot_cv(cv_res_loclinear)
mtext(3, outer=T,
      text = "log transformation"
)
dev.off()


params <- c("N_anc",
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


#res <- abc(target=d_obs_stats, 
#           param = d_log_2_1_2_filtered[,params],
#           sumstat = d_2_1_2_filtered[,-c(1, ncol(d_2_1_2_filtered))],
#           tol=0.01,
#           method="loclinear",
#           transf = "log"
#)
#
#pdf("param_inf.pdf", height=15, width= 15)
#par(mfrow = c(5,5))
#for(param in params){
#        hist(log10(res$adj.values[, param]),
#             main = param,
#             breaks = 100,
#             border="gray",
#             col = "gray",
#             xlab = paste0("log10(", param, ")")
#        )
#        #mn <- mean(log10(res$adj.values[, param]))
#        md <- median(log10(res$adj.values[, param]))
#        lo <- quantile(log10(res$adj.values[, param]), 0.25)
#        hi <- quantile(log10(res$adj.values[, param]), 0.75)
#        abline(v = md)
#        abline(v = hi,
#               lty =2
#        )
#        abline(v = lo,
#               lty =2
#        )
#        legend("topright",
#               legend = paste0(c("median = ", "25 percentile = ", "75 percentile = "), sprintf("%.3f", c(md, hi, lo))),
#               bty = 'n'
#        )
#}
#dev.off()
#
#write.table(
#            res$adj.values,
#            "model_2_1_2_posterior.txt",
#            quote=F,
#            row.names=F,
#            col.names=T
#)
#
#save.image("abc_mod_sel.RData")

