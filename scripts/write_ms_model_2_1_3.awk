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
$1=="T_short"{
        T_short = $2
}
$1=="T_res"{
        T_res = $2
}
$1=="T_mac1"{
        T_mac1 = $2
}
$1=="T_mac2"{
        T_mac2 = $2
}
$1=="T_azo_cap"{
        T_azo_cap = $2
}
$1=="T_can_mad"{
        T_can_mad = $2
}
$1=="T_cre"{
        T_cre = $2
}
$1=="T_mal"{
        T_mal = $2
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
        # None
        
        # Backward join (forward split)
        printf " -ej %f %d %d", T_short/(4*N_anc), 3, 2
        printf " -ej %f %d %d", T_res/(4*N_anc), 4, 2
        printf " -ej %f %d %d", T_can_mad/(4*N_anc), 6, 5
        printf " -ej %f %d %d", T_azo_cap/(4*N_anc), 8, 7
        printf " -ej %f %d %d", T_mac2/(4*N_anc), 7, 5
        printf " -ej %f %d %d", T_mac1/(4*N_anc), 5, 2
        printf " -ej %f %d %d", T_mal/(4*N_anc), 9, 2
        printf " -ej %f %d %d", T_cre/(4*N_anc), 10, 2
        printf " -ej %f %d %d", T_geo/(4*N_anc), 2, 1
        printf "\n"
}
