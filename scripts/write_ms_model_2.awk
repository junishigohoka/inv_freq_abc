func sum(arr,  i, s){
        for(i in arr){
                s+=arr[i]
        }
        return s
}

func rand_int(n){
        return int(n * rand())
}

BEGIN{
        srand(seed)
        }
$1=="nseqs"{
        for(i=2;i<=NF;i++){
                nseqs[i-1] = $i
        }
        nseqs_all=sum(nseqs)
}
$1=="nsites"{
        nsites=$2
}
$1=="N_anc"{
        N_anc=$2
}
$1=="Ns_N0"{
        for(i=2;i<=NF;i++){
                Ns_N0[i-1] = $i
        }
        npops=length(Ns_N0)
}
$1=="T_split"{
        T_split = $2
}
$1=="T_geo"{
        T_geo = $2
}
$1=="mig"{
        mig[$2][$3]=$4
}
END{
        if(length(nseqs)!=length(Ns_N0)){
                printf "Err: NSEQS %d is different from NPOPS %d.\n", length(nseqs), length(Ns_N0) | "cat >&2"
                exit
        }
        printf "ms"
        printf " %d", nseqs_all
        printf " %d", nsites
        printf " -seeds %d %d %d", rand_int(99999), rand_int(99999), rand_int(99999)
        printf " -s 1"
        # Number of populations
        printf " -I %d", npops
        for(i=1;i<=npops;i++){
                printf " %d", nseqs[i]
        }
        # Pop size
        for(i=1;i<=npops;i++){
                printf " -n %d %f", i, Ns_N0[i]
        }
        # Migration
        if(length(mig) > 0){
                for(i in mig){
                        for(j in mig[i]){
                                if(i==0 || j==0){
                                        # pop0 is just cont_medlong older than T_split
                                        printf " -em %f %d %d %f", T_split/(4*N_anc),1, 2, 4 * N_anc * mig[i][j]
                                        printf " -em %f %d %d %f", T_split/(4*N_anc),2, 1, 4 * N_anc * mig[i][j]
                                        printf " -em %f %d %d %f", T_geo/(4*N_anc),1, 2, 0
                                        printf " -em %f %d %d %f", T_geo/(4*N_anc),2, 1, 0
                                }
                                else{
                                        printf " -m %d %d %f", i, j, 4 * N_anc * mig[i][j]
                                        printf " -m %d %d %f", j, i, 4 * N_anc * mig[i][j]
                                        if(i==1 || j==1){
                                                printf " -em %f %d %d %f", T_geo/(4*N_anc),i, j, 0
                                                printf " -em %f %d %d %f", T_geo/(4*N_anc),j, i, 0
                                        }
                                        else{
                                                printf " -em %f %d %d %f", T_split/(4*N_anc),i, j, 0
                                                printf " -em %f %d %d %f", T_split/(4*N_anc),j, i, 0
                                        }
                                }
                        }
                }
        }
        # Backward join (forward split)
        if(npops>1){
                # join all non-Georgian to cont_medlong at T_split
                for(i=3;i<=npops;i++){
                        printf " -ej %f %d %d", T_split/(4*N_anc), i, 2
                }
                # join cont_medlong to cont_geo at T_split
                printf " -ej %f %d %d", T_geo/(4*N_anc), 2, 1
        }
        printf "\n"
}
