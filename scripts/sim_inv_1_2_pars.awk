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
                h_mig = unif(-2,0)
                h_res = unif(-2,0)
                s_mig = -logunif(1e-7,0.1)
                s_res = -logunif(1e-7,0.1)
                for(j=0;j<=3;j++){
                        printf "%.3f ", h_mig
                }
                for(j=4;j<=10;j++){
                        printf "%.3f ", h_res
                }
                for(j=0;j<=3;j++){
                        printf "%e ", s_mig
                }
                for(j=4;j<10;j++){
                        printf "%e ", s_res
                }
                printf "%e\n", s_res
        }
}
