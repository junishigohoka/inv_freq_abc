setwd("/home/ishigohoka/projects/Miriam/PhD/PhD/inv_freq_abc/output/demography/post_ms_slim")

ms <- read.table("model_2_1_2_posterior_ms_out.txt", header=T)

obs <- read.table("../blackcap/observed_out.txt", header=T)
obs$simid[1] <- 0
ms_abcrf <- read.table("model_2_1_2_abcrf_posterior_med_ms_out.txt", header=T)



d <- rbind(obs, ms)
ms_abcrf$simid <- nrow(d) + 1


d <- (d[,c(-1,-grep("D_", colnames(d)))])


pca <- prcomp(d,
              center = T,
              scale = T
)

pdf("pca.pdf")
plot(pca$x[,1],
     pca$x[,2]
)
points(pca$x[1,1],
       pca$x[1,2],
       col=2
)
points(pca$x[nrow(d),1],
       pca$x[nrow(d),2],
       col=4
)
dev.off()
