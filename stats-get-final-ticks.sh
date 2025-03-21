#!/bin/bash
source paths.sh

curDIR=$PWD

benchmark_run_hash1=results/run-enc-4-priv-se-ext-hash-1*
benchmark_run_hash3=results/run-enc-4-priv-se-ext-hash-3*
output=$curDIR/csv/stats.csv

# BENCHMARK_DIRS=flood-fill
echo Benchmarks,se-ext-hash-3,se-ext-hash-1 > $output
for dir in $BENCHMARK_DIRS; do
    cd $BENCHMARK_HOME_DIR/$dir
    # Benchmark name
    tick=$dir,

    # Read se-ext-hash-1 run output
    tick_msg=$(grep -rh 'Exiting @ tick' $benchmark_run_hash3)
    IFS=' ' read -r -a arr <<< "${tick_msg}"
    tick+=${arr[6]},
    
    # Read se-ext-hash-3 run output
    tick_msg=$(grep -rh 'Exiting @ tick' $benchmark_run_hash1)
    IFS=' ' read -r -a arr <<< "${tick_msg}"
    tick+=${arr[6]}

    echo -e $tick >> $output

    cd $curDIR
done

