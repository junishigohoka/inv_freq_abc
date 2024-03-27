# Tajima's D

func get_a1(n,    i,s){
        for(i=1;i<=n-1;i++){
                s+=1/i
        }
        return s
}


func get_a2(n,   i, s){
        for(i=1;i<=n-1;i++){
                s+=1/i^2
        }
        return s
}


func get_e1(n,   a1){
        a1=get_a1(n)
        return ((n+1)/(3*(n-1))-1/a1)/a1
}


func get_e2(n,  n1, a2){
        a1 = get_a1(n)
        a2 = get_a2(n)
        return (2*(n^2 + n + 3)/(9*n*(n-1)) - (n+2)/(n*a1) + a2/a1^2)/(a1^2 + a2)
}



func get_tajimaD(pi, ss, n,     a1, e1, e2){
        a1 = get_a1(n)
        e1 = get_e1(n)
        e2 = get_e2(n)
        return (pi - ss/a1)/(e1*ss + e2*ss*(ss - 1))
}

# Watterson's estimator of theta for one position


func get_theta(p, n){
        if(p!=1 && p!=0){
                return 1/get_a1(n)
        }
        else{
                return 0
        }
}


# Allele freq

func make_freqs(gt, haps, freqs, pop_haps,   pos, hapidx, pop, n){
        for(pos in gt){
                for(hapidx in haps){
                        pop=haps[hapidx]
                        freqs[pop][pos]+=gt[pos][hapidx]
                }
        }
        for(pop in pop_haps){
                n=length(pop_haps[pop])
                for(pos in freqs[pop]){
                        freqs[pop][pos] /= n
                }
        }
}

# pi


func get_pi(p, n){
        return 2 * n * p * (1 - p)/(n-1)
}




# Weir & Cockerham's estimator of FST

func get_n_bar(n1, n2){
        return (n1 + n2)/2
}


func get_n_c(n1, n2,     n_bar){
        n_bar=get_n_bar(n1, n2)
        return (2 * n_bar) - ((n1^2 + n2^2)/(2 * n_bar))
}

func get_p_bar(p1, p2, n1, n2,    n_bar){
        n_bar=get_n_bar(n1, n2)
        return (n1 * p1 + n2 * p2 )/ (2 * n_bar)
}

func get_s_2(p1, p2, n1, n2,   n_bar, p_bar){
        n_bar=get_n_bar(n1, n2)
        p_bar=get_p_bar(p1, p2, n1, n2)
        return (n1 * (p1 - p_bar)^2 + n2 * (p2 - p_bar)^2) / n_bar
}


func get_h_bar(n1, n2, h1, h2,    n_bar){
        n_bar = get_n_bar(n1, n2)
        return (n1 * h1 + n2 * h2)/(2 * n_bar)
}


func get_a(p1, p2, n1, n2, h1, h2,      n_bar, n_c, s_2, p_bar, h_bar){
        n_bar = get_n_bar(n1, n2)
        n_c = get_n_c(n1, n2)
        s_2 = get_s_2(p1, p2, n1, n2)
        p_bar = get_p_bar(p1, p2, n1, n2) 
        h_bar = get_h_bar(n1, n2, h1, h2)
        return (n_bar/n_c) * (s_2 - (p_bar *(1 - p_bar) - s_2/2 - h_bar/4)/(n_bar - 1))
}


func get_b(p1, p2, n1, n2, h1, h2,      n_bar, s_2, p_bar, h_bar){
        n_bar = get_n_bar(n1, n2)
        s_2 = get_s_2(p1, p2, n1, n2)
        p_bar = get_p_bar(p1, p2, n1, n2) 
        h_bar = get_h_bar(n1, n2, h1, h2)
        return ((n_bar)/(n_bar - 1)) * ((p_bar * (1 - p_bar)) - s_2/2 - h_bar *(2*n_bar - 1)/(4 * n_bar))
}

func get_c(n1, n2, h1, h2,   h_bar){
        h_bar = get_h_bar(n1, n2, h1, h2)
        return h_bar/2
}


func get_h(p, n){
        return get_pi(p, n)
}


func get_fst(p1, p2, n1, n2,     a, b, c, h1, h2){
        h1 = get_h(p1, n1)
        h2 = get_h(p2, n2)
        a = get_a(p1, p2, n1, n2, h1, h2)
        b = get_b(p1, p2, n1, n2, h1, h2)
        c = get_c(n1, n2, h1, h2)
        if(a == 0){
                return 0
        }
        else{
                return a/(a + b + c)
        }
}


# Header
func print_header(pops, simid,    pop, pop1, pop2){
        printf "simid"
        for(pop=1;pop<=length(pops);pop++){
                printf " pi_%d", pop
        }
        for(pop=1;pop<=length(pops);pop++){
                printf " theta_%d", pop
        }
        for(pop=1;pop<=length(pops);pop++){
                printf " D_%d", pop
        }
        for(pop1=1;pop1<=length(pops)-1;pop1++){
                for(pop2=pop1+1;pop2<=length(pops);pop2++){
                        printf " FST_%d_%d", pop1, pop2
                }
        }
        printf "\n"
}


NR==FNR && NR==1{
        #print $0 > "test.ms." a ".command"
}
/^$/{
        pos++
        i=0
        getline
        getline
        getline
        getline
}
NR==FNR && /^[01]$/{
        i++
        gt[pos][i]=$1
}
NR!=FNR{
        c++
        nhaps+=$2
        while(hapidx < nhaps){
                hapidx++
                haps[hapidx] = c
        }
        pops[c]++
}
END{
        # Print headder
        if(simid==1){
                print_header(pops)
        }
        # Get summary stats
        L=length(gt)
        for(hapidx in haps){
                pop_haps[haps[hapidx]][hapidx]++
        }
        npops=c
        make_freqs(gt, haps, freqs, pop_haps)
        # Compute mean FST for each population pair
        for(pop1=1;pop1<=npops-1;pop1++){
                for(pop2=pop1+1;pop2<=npops;pop2++){
                        n1 = length(pop_haps[pop1])
                        n2 = length(pop_haps[pop2])
                        for(pos=1;pos<=L;pos++){
                                p1 = freqs[pop1][pos]
                                p2 = freqs[pop2][pos]
                                fst[pop1][pop2]+=get_fst(p1, p2, n1, n2)
                        }
                        fst[pop1][pop2] /= L
                }
        }
        # Compute mean pi and theta for each population
        for(pop in pops){
                n=length(pop_haps[pop])
                for(pos=1;pos<=L;pos++){
                        p = freqs[pop][pos]
                        pi[pop] += get_pi(p, n)
                        theta[pop] += get_theta(p, n)
                }
                pi[pop] /= L
                theta[pop] /= L
        }
        # Tajima's D
        for(pop in pops){
                n=length(pop_haps[pop])
                # Count seg sites
                ss = 0
                for(pos=1;pos<=L;pos++){
                        if(freqs[pop][pos] > 0 && freqs[pop][pos] < 1){
                                ss++
                        }
                }
                if(ss>0){
                        D[pop] = get_tajimaD(pi[pop], ss, n)
                }
                else{
                        D[pop] = "NA"
                }
        }
        # Print
        # simid
        printf "%d", simid
        # pi
        for(pop=1;pop<=length(pops);pop++){
                printf " %f", pi[pop]
        }
        # theta
        for(pop=1;pop<=length(pops);pop++){
                printf " %f", theta[pop]
        }
        # Tajima's D
        for(pop=1;pop<=length(pops);pop++){
                if(D[pop] == "NA"){
                        printf " %s", D[pop]
                }
                else{
                        printf " %f", D[pop]
                }
        }
        # Fst
        for(pop1=1;pop1<=npops-1;pop1++){
                for(pop2=pop1+1;pop2<=npops;pop2++){
                        printf " %f", fst[pop1][pop2]
                }
        }
        printf "\n"
}

