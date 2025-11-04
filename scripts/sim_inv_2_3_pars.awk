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

BEGIN{
        srand(seed)
        for(i=0;i<nsims;i++){
                printf "%s_%d ", prefix, i
                printf "%d ", unif(0, 1e9)
                s_cont = logunif(1e-7,0.1)
                s_isl = logunif(1e-7,0.1)
                p_opt_cont = unif(0, 0.5)
                p_opt_isl = unif(0, 0.5)
                for(j=0;j<=4;j++){
                        printf "%e ", s_cont
                }
                for(j=5;j<=10;j++){
                        printf "%e ", s_isl
                }
                for(j=0;j<=4;j++){
                        printf "%.3f ", p_opt_cont
                }
                for(j=5;j<10;j++){
                        printf "%.3f ", p_opt_isl
                }
                printf "%.3f\n", p_opt_isl
        }
}
