@include "scripts/utils.awk"


func get_Ns_N0(npops, Ns_N0,    i){
        for(i=1;i<=npops;i++){
                if(i <= 3){ # Georgia, medlong, short
                        Ns_N0[i] = logunif(1, 100)
                }
                else if( i == 4){ # cont_res
                        Ns_N0[i] = 1
                }
                else{ # islands
                        Ns_N0[i] = logunif(0.01, 1)
                }
        }
}


func make_log_line(N_anc, Ns_N0, T_geo, T_split, pops, simid, seed,    pop, str){
        str = simid " " seed " " N_anc
        for(pop in pops){
                str = str " " Ns_N0[pop]
        }
        str = str " " T_split " " T_geo
        return str
}


func make_log_header(pops,    pop, str){
        str="simid seed N_anc "
        for(pop in pops){
               str=str "N_N0_" pop " "
        }
        str=str "T_geo T_split"
        return str
}


BEGIN{
        srand(seed)
}
{
        c++
        pops[c] = $1
        nseqs[c] = $2
}
END{
        # Get npops
        npops = length(pops)
        # Get N_anc
        N_anc = logunif(1e5, 1e6)
        # Get Ns_N0
        get_Ns_N0(npops, Ns_N0)
        # Get T_split
        T_split = logunif(1e4, 1e5)
        # Get T_geo
        T_geo = logunif(T_split, 4e5)
        # Print nseqs
        print_nseqs(nseqs)
        # Print nsites
        printf "nsites %d\n", 1000
        # Print N_anc
        printf "N_anc %d\n", N_anc
        # Print Ns_N0
        print_Ns_N0(Ns_N0)
        # Print T_split
        printf "T_split %d\n", T_split
        printf "T_geo %d\n", T_geo
        # Write in log file
        if(simid == 1){
                print make_log_header(pops) > logfile
        }
        print make_log_line(N_anc, Ns_N0, T_geo, T_split, pops, simid, seed) >> logfile
}

