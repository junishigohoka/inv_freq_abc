func unif(min, max){
        if(min > max){
                print "Err: min of unif() should be greater than max" > "/dev/stderr"
                exit
        }
        return min + (max-min) * rand()
}


func logunif(min, max){
        if(min<=0){
                print "Err: min of logunif() should be positive" > "/dev/stderr"
                exit
        }
        if(min > max){
                print "Err: min of logunif() should be greater than max" > "/dev/stderr"
                exit
        }
        return exp(unif(log(min), log(max)))
}


func print_nseqs(nseqs,    i){
        printf "nseqs"
        for(i=1;i<=length(nseqs);i++){
                printf " %d", nseqs[i]
        }
        printf "\n"
}



func print_Ns_N0(Ns_N0,    i){
        printf "Ns_N0"
        for(i=1;i<=length(Ns_N0);i++){
                printf " %f", Ns_N0[i]
        }
        printf "\n"
}

