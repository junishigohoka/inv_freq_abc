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
                for(j=0;j<=10;j++){
                        s[j] = logunif(1e-9,0.1)
                        p_opt[j] = unif(0,0.5)
                }
                for(j=0;j<=10;j++){
                        printf "%e ", s[j]
                }
                for(j=0;j<10;j++){
                        printf "%.3f ", p_opt[j]
                }
                printf "%.3f\n", p_opt[10]
        }
}
