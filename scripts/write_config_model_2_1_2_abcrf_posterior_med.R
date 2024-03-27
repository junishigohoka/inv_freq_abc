
pop_nhaps <- read.table("/home/ishigohoka/projects/Miriam/PhD/PhD/inv_freq_abc/list/pop_nhaps.txt", col.names=c("pop", "nhaps"))

params <- read.table("/home/ishigohoka/projects/Miriam/PhD/PhD/inv_freq_abc/output/demography/abcrf/model_2_1_2_posterior_med_for_ms.txt", header=T)
params$N_N0_4 <- 1

nsites <- 1000

cat_migs <- function(params_line){
        for(i in 1:10){
                for(j in 1:10){
                        if(i != j){
                                mig <- paste("mig", i, j, sep="_")
                                if(mig %in% colnames(params_line)){
                                        cat("mig", i, j, params_line[,mig], "\n")
                                }
                                else{
                                        cat("mig", i, j, 0, "\n")
                                }
                        }
                }
        }
}

cat_config <- function(params_line, nhaps, nsites){
        cat("nseqs" , nhaps, "\n")
        cat("nsites", nsites, "\n")
        cat("N_anc", params_line$N_anc, "\n")
        cat("Ns_N0", unlist(params_line[,paste0("N_N0_",1:10)]), "\n")
        cat_migs(params_line)
        cat("T_split", params_line$T_split, "\n")
        cat("T_geo", params_line$T_geo, "\n")
}


cat_config(params[1,], pop_nhaps$nhaps, nsites)
