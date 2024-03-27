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



# Cross validation
if(length(list.files(pattern = "regAbcrf_model_2_1_2_cv.pdf"))==0){
        pdf("regAbcrf_model_2_1_2_cv.pdf", height = 3*6, width= 3*6)
        par(mfrow = c(6,6))
        for(i in 1:ncol(d_log)){
                print(i)
                param <- d_log[, i]
                rf_model <- readRDS(paste0("regAbcrf_model_2_1_2_", colnames(d_log)[i], ".rds"))
                estim <- rf_model$model.rf$predictions
                plot(log10(param)[1:100],
                     rf_model$model.rf$predictions[1:100],
                     xlab = paste0("log10(", colnames(d_log[i]), ")"),
                     ylab = "Prediction",
                     main = colnames(d_log)[i]
                )
                abline(a=0,
                       b=1,
                       col = 2,
                       lty = 2
                )
                legend( "topleft",
                       legend = c(paste0("Pearson r = ", sprintf("%.3f",cor(log10(param), estim))), paste0("Spearman r = ", sprintf("%.3f",cor(log10(param), estim, method = "spearman")))),
                       bty = 'n'
                )
        }
        dev.off()
}



posterior <- 

