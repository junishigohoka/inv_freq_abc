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


func get_mig(pops, mig,      i, j, mig_geo_medlong, mig_medlong_short, mig_mac, mig_res_mac, mig_azo_cap, mig_can_mad){
        # Initialise migration matrix
        for(i in pops){
                for(j in pops){
                        if(i != j){
                                mig[i][j]=0
                        }
                        else{
                                mig[i][j]="x"
                        }
                }
        }
        # Sample migration rates
        mig_geo_medlong = logunif(1e-9, 1e-3)
        mig_medlong_short = logunif(1e-9, 1e-3)
        mig_short_res = logunif(1e-9, 1e-3)
        mig_mac = logunif(1e-9, 1e-3)
        mig_res_mac = logunif(1e-9, mig_mac) # mig between isl and cont should not exceed that between islands
        mig_azo_cap = logunif(mig_mac, 1e-3) # mig between azo and cap should be higher than between azo/cap and can/mad
        mig_can_mad = logunif(mig_mac, 1e-3) # mig between azo and cap should be higher than between azo/cap and can/mad
        mig[1][2] = mig_geo_medlong
        mig[2][1] = mig_geo_medlong
        mig[2][3] = mig_medlong_short
        mig[3][2] = mig_medlong_short
        mig[3][4] = mig_short_res
        mig[4][3] = mig_short_res
        for(i=5;i<=8;i++){
                mig[4][i] = mig_res_mac
                mig[i][4] = mig_res_mac
        }
        mig[5][6] = mig_azo_cap
        mig[6][5] = mig_azo_cap
        mig[7][8] = mig_can_mad
        mig[8][7] = mig_can_mad
        for(i=5;i<=6;i++){
                for(j=7;j<=8;j++){
                        mig[i][j] = mig_mac
                        mig[j][i] = mig_mac
                }
        }
}


func make_log_line(N_anc, Ns_N0, T_split, mig, pops, simid, seed,    pop, str, i, j){
        str = simid " " seed " " N_anc
        for(pop=1;pop<=length(pops);pop++){
                str = str " " Ns_N0[pop] 
        }
        str = str " " T_split 
        for(i=1;i<=length(pops);i++){
                for(j=1;j<=length(pops);j++){
                        if(i!=j){
                                str = str " " mig[i][j]
                        }
                }
        }
        return str
}


func make_log_header(pops,    pop, pop1, pop2, str){
        str="simid seed N_anc"
        for(pop=1;pop<=length(pops);pop++){
               str=str " N_N0_" pop
        }
        str=str " T_split"
        for(pop1=1;pop1<=length(pops);pop1++){
                for(pop2=1;pop2<=length(pops);pop2++){
                        if(pop1 != pop2){
                                str=str " mig_" pop1 "_" pop2 
                        }
                }
        }
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
        # Get mig
        get_mig(pops, mig)
        # Print nseqs
        print_nseqs(nseqs)
        # Print nsites
        printf "nsites %d\n", nsites
        # Print N_anc
        printf "N_anc %d\n", N_anc
        # Print Ns_N0
        print_Ns_N0(Ns_N0)
        # Print T_split
        printf "T_split %d\n", T_split
        # Print mig
        for(pop1=0;pop1<=length(pops);pop1++){
                for(pop2=0;pop2<=length(pops);pop2++){
                        if(pop1 != pop2 && mig[pop1][pop2] > 0){
                                printf "mig %d %d %f\n", pop1, pop2, mig[pop1][pop2]
                        }
                }
        }
        # Write in log file
        if(simid == 1){
                print make_log_header(pops) > logfile
        }
        print make_log_line(N_anc, Ns_N0, T_split, mig, pops, simid, seed) >> logfile
}

