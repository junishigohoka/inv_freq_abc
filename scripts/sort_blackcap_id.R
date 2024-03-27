setwd("/home/ishigohoka/projects/Miriam/PhD/PhD/inv_freq_abc")

# Read sorted pops
pops_sorted <- read.table("list/pop_nhaps.txt")[,1]

# Read IDs
d <- read.table("../msmc2_relate_rec/list/blackcap_id_pops.list", col.names=c("id", "pop"))
d$pop <- as.factor(d$pop)
d$pop <- factor(d$pop, levels=pops_sorted)

d_sorted <- d[order(d$pop),]

# Save
write.table(d_sorted, "list/id_sorted.txt", quote=F, col.names=F, row.names=F)

