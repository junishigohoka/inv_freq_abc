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


func make_log_line(N_anc, Ns_N0, T_geo, T, pops, simid, seed,    pop, str){
        str = simid " " seed " " N_anc
        for(pop=1;pop<=length(pops);pop++){
                str = str " " Ns_N0[pop]
        }
        str = str " " T_geo " " T["medlong"] " " T["res"] " " T["mac1"] " " T["mac2"] " " T["azo_cap"] " " T["can_mad"] " " T["cre"] " " T["mal"]
        return str
}


func make_log_header(pops,    pop, str){
        str="simid seed N_anc "
        for(pop=1;pop<=length(pops);pop++){
               str=str "N_N0_" pop " "
        }
        str=str "T_geo T_medlong T_res T_mac1 T_mac2 T_azo_cap T_can_mad T_cre T_mal"
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
        T["medlong"] = logunif(1e4, 1e5)
        T["res"] = logunif(1e4, 1e5)
        T["mac1"] = logunif(1e4, 1e5)
        T["mac2"] = logunif(1e4, T["mac1"])
        T["azo_cap"] = logunif(1e4, T["mac2"])
        T["can_mad"] = logunif(1e4, T["mac2"])
        T["cre"] = logunif(1e4, 1e5)
        T["mal"] = logunif(1e4, 1e5)
        # Get T_geo
        T_split_old = max(T)
        T_geo = logunif(T_split_old, 4e5)
        # Print nseqs
        print_nseqs(nseqs)
        # Print nsites
        printf "nsites %d\n", nsites
        # Print N_anc
        printf "N_anc %d\n", N_anc
        # Print Ns_N0
        print_Ns_N0(Ns_N0)
        # Print T_split
        printf "T_medlong %d\n", T["medlong"]
        printf "T_res %d\n", T["res"]
        printf "T_mac1 %d\n", T["mac1"]
        printf "T_mac2 %d\n", T["mac2"]
        printf "T_azo_cap %d\n", T["azo_cap"]
        printf "T_can_mad %d\n", T["can_mad"]
        printf "T_cre %d\n", T["cre"]
        printf "T_mal %d\n", T["mal"]
        printf "T_geo %d\n", T_geo
        # Write in log file
        if(simid == 0){
                print make_log_header(pops) > logfile
        }
        print make_log_line(N_anc, Ns_N0, T_geo, T, pops, simid, seed) >> logfile
}

