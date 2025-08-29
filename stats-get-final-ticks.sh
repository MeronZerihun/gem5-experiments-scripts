#!/bin/bash
# Command: ./stats-get-final-ticks.sh r*se-ext-opt-no-hash-2025* se-ext-opt-no-hash
source paths.sh

curDIR=$PWD

mkdir -p csv

stat=results/$1*.out
output=$curDIR/csv/stats-final-ticks-$2.csv

echo Benchmarks,Final Ticks > $output
for dir in $BENCHMARK_DIRS; do
    cd $BENCHMARK_HOME_DIR/$dir
    # Benchmark name
    tick=$dir,

    # Get run output
    tick_msg=$(grep -rh 'Exiting @ tick' $stat)
    IFS=' ' read -r -a arr <<< "${tick_msg}"
    tick+=${arr[6]},
    
    echo -e $tick >> $output

    cd $curDIR
done

