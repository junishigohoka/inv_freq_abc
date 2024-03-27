{
        chr=$1
        pos=$2
        print ""
        print "//"
        print "segsites: 1"
        print "positions: " chr ":"pos
        for(i=3;i<=NF;i++){
                print $i
        }
        print chr, pos > logfile
}
