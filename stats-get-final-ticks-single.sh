#!/bin/bash
source paths.sh

curDIR=$PWD

stat=results/run-enc-4-priv-perfect-prefetch-enc-2025.03.2*.out
output=$curDIR/csv/stats-perfect-prefetch.csv

# BENCHMARK_DIRS=flood-fill
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

