setwd("/home/ishigohoka/projects/Miriam/PhD/PhD/inv_freq_abc/output/demography/post_ms_slim")


d <- read.table("model_2_1_2_slim_pyslim_pca.eigenvec")[, c(1,3,4)]
colnames(d) <- c("id", "pc1", "pc2")

ninds <- read.table("../../../list/pop_nhaps.txt")[,2]/2

cols <- c("black", rainbow(9))


pdf("model_2_1_2_slim_pyslim_pca.pdf")
plot(d$pc1, d$pc2,
     col = rep(cols, each = ninds)
)
dev.off()
