#!/bin/bash

# import paths 
source path.sh



# parse script arguments 
# (these arguments can be updated to match project, 
#  but any changes should also be reflected in other scripts)
gem5=${gem5:-clean} #clean, priv
bmk_ext=${bmk_ext:-na} #na, enc
gem5_branch=${gem5_branch:-} #naive-se-128, naive-se-256, opt-se-128, opt-se-256
date=${date:-} #date of benchmark run
while [ $# -gt 0 ]; do
  case "$1" in
    --gem5=*)
      gem5="${1#*=}"
      ;;
    --bmk_ext=*)
      bmk_ext="${1#*=}"
      ;;
    --gem5_branch=*)
      gem5_branch="${1#*=}"
      ;;
    *)
      printf "***************************\n"
      printf "* Error: Invalid argument.*\n"
      printf "***************************\n"
      exit 1
  esac
  shift
done


RED='\033[0;31m'
GREEN='\033[0;32m'
GREY='\033[0;33m'
NC='\033[0m' # No Color
python3 get-stats.py print $PWD > stats.txt


# loop over each benchmark and validate gem5 results 
echo "------------------------------------------"
for dir in $BENCHMARK_DIRS; do
    
    # print header for this benchmark
    printf "${GREEN}$dir${NC} \n"
    echo "------------------------------------------"


    # setup paths
    curDIR=$PWD
    BIN_DIR=$BENCHMARK_HOME_DIR/$dir/bin
    RESULTS_DIR=$BENCHMARK_HOME_DIR/$dir/results/m5out-$gem5-$gem5_branch-$bmk_ext-$date
    python3 get-stats.py $dir $RESULTS_DIR  >> stats.txt


    # validate gem5 run output using diff
    if [ "$dir" = "kepler-calc" ]; then
        DIFF="numdiff -r 0.001"
    else
        DIFF="diff" 
    fi
    ./$BIN_DIR/$dir-na.do > FOO.out 2> FOO.err
    printf "   ${GREEN}$dir${NC} output diff:\n"
    $DIFF FOO.out $RESULTS_DIR/$dir-$EXT.do.out | grep -v "[VIP]" | sed 's/^/        /' #Ignore lines for rdtsc cycle count...
    rm FOO.out
    rm FOO.err


    # print any errors or warnings in gem5 output file
    printf "   ${GREEN}$dir${NC} error grep:\n"
    grep "ERROR" $RESULTS_DIR/debug.out | sed 's/^/        /'


    # print cycle count for gem5 output
    printf "   ${GREEN}$dir${NC} cycle count:\n"
    IFS=':' read -ra vip <<<  $(grep "VIP" $RESULTS_DIR/$dir-$EXT.do.out)
    IFS=' ' read -ra vip2 <<<  ${vip[1]}
    echo -n ${vip2[0]} "-- " | sed 's/^/        /'
    grep "VIP" $RESULTS_DIR//$dir-$EXT.do.out

    IFS=' ' read -ra stat <<<  $( grep "system.cpu.numCycles" $RESULTS_DIR/stats.txt | sed -n '2 p')
    echo -n ${stat[1]} "-- " | sed 's/^/        /'
    grep "system.cpu.numCycles" $RESULTS_DIR/stats.txt | sed -n '2 p' 

    if test ${vip2[0]} != ${stat[1]}; then  
        printf "        ${RED}cycle counts differ${NC}\n"
    fi


    # print footer for this benchmark
    echo "------------------------------------------"
done



#print aggregate results via python in CSV format
echo ""
cat stats.txt