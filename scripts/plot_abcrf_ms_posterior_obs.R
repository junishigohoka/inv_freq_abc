
setwd("/home/ishigohoka/projects/Miriam/PhD/PhD/inv_freq_abc/output/demography/post_ms_slim")



d_sim <- read.table("../ms/model_2_1_2_out.txt.gz", header=T)
#d_abcrf_post_ms <- read.table("model_2_1_2_abcrf_posterior_med_ms_out.txt", header=T)


for(i in 0:9){
        d_tmp <- read.table(paste0("model_2_1_2_abcrf_posterior_med_ms_", i, "_out.txt"), header=T)
        if(i == 0){
                d_abcrf_post_ms <- d_tmp
        }else{
                d_abcrf_post_ms <- rbind(d_abcrf_post_ms, d_tmp)
        }
}


for(i in 0:9){
        d_tmp <- read.table(paste0("model_2_1_2_slim_pyslim_50_", i, "_out.txt"), header=T)
        if(i == 0){
                d_abcrf_post_slim_50 <- d_tmp
        }else{
                d_abcrf_post_slim_50 <- rbind(d_abcrf_post_slim_50, d_tmp)
        }
}
for(i in 0:9){
        d_tmp <- read.table(paste0("model_2_1_2_slim_pyslim_100_", i, "_out.txt"), header=T)
        if(i == 0){
                d_abcrf_post_slim_100 <- d_tmp
        }else{
                d_abcrf_post_slim_100 <- rbind(d_abcrf_post_slim_100, d_tmp)
        }
}

#d_abcrf_post_slim_50 <- read.table("model_2_1_2_slim_pyslim_50_0_out.txt", header=T)
#d_abcrf_post_slim_100 <- read.table("model_2_1_2_slim_pyslim_100_out.txt", header=T)

d_obs <- read.table("../blackcap/observed_out.txt", header=T)




# Plot histograms
pdf("model_2_1_2_post_obs.pdf", height=3*5, width=3*5)
par(mfrow=c(5,5))
for(i in 2:ncol(d_obs)){
        stat <- colnames(d_obs)[i]
        hist(d_sim[, stat],
             col = "gray",
             border = "gray",
             xlab = stat,
             main = stat
        )
        abline(v = d_obs[1, stat], 
               col = 1,
               lty =1)
        abline(v = d_abcrf_post_ms[1, stat], 
               col = 3,
               lty =2)
        abline(v = d_abcrf_post_slim_50[1, stat],
               col = 4,
               lty = 2
        )
        legend("topright",
               lty = c(1,2, 2),
               col = c(1, 3, 4),
               legend = c("Observed", "ABC-RF (ms)", "ABC-RF (slim)")
        )
}
dev.off()



# Plot PCA

d_obs$simid <- 0
#d_abc_posterior <- read.table("model_2_1_2_posterior_ms_out.txt", header=T)


d <- rbind(d_obs, d_abcrf_post_ms)
d <- rbind(d, d_abcrf_post_slim_50)
d <- rbind(d, d_abcrf_post_slim_100)
d <- rbind(d, d_sim)

d <- d[, c(-1, -grep("D_", colnames(d)))]



pca <- prcomp(d,
              center = T,
              scale = T
)

pca$prop <- sprintf(fmt = "%.1f", pca$sdev^2/sum(pca$sdev^2) * 100)



png("pca_ms_slim.png", res= 350 , height=480*3, width= 480*3)
par(mar=c(4,5,2,1))
plot(pca$x[22:nrow(pca$x),1],
     pca$x[22:nrow(pca$x),2],
     pch = '.',
     xlab = paste0("PC1 (", pca$prop[1], "%)"),
     ylab = paste0("PC2 (", pca$prop[2], "%)")
)
# abcrf ms
points(pca$x[2:11, 1],
       pca$x[2:11, 2],
       col = 3,
       pch = 4
)
# abcrf slim 50
points(pca$x[12:21, 1],
       pca$x[12:21, 2],
       col = 4,
       pch = 4
)
# abcrf slim 100
points(pca$x[22:31, 1],
       pca$x[22:31, 2],
       col = 5,
       pch = 4
)
# obs
points(pca$x[1,1],
       pca$x[1,2],
       col = 2,
       pch = 4
)
legend("topright",
       pch = c(4,4,4,4,1),
       col = c(2,3,4,5,1),
       legend = c("Observed", "ms w/ post. med.", "SLiM w/ post. med. (scale = 50)",  "SLiM w/ post. med. (scale = 100)", "model_2_1_2"),
       cex = 0.75
)
dev.off()



