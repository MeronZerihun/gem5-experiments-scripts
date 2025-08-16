#!/bin/bash
source paths.sh

curDIR=$PWD

cd $BENCHMARK_HOME_DIR

for dir in $BENCHMARK_DIRS; do

    # Check gem5 benchmark output with native output
    check=$(diff $dir/$dir.enc.out $dir/results/m5out-enc-3*/$dir.enc.out | grep "^[<>]" | wc -l)
    
    if [ $1 == "se-ext" ]; then
        check=$(diff $dir/$dir.enc.out $dir/results/m5out-enc-4*/$dir.enc.out | grep "^[<>]" | wc -l)
    fi

    if [ $check -gt 0 ]; then
        echo -e "\033[0;31mgem5 result for $dir is incorrect.\033[0m"
    else
        echo -e "\033[0;32mgem5 result for $dir is correct.\033[0m"
    fi

done