#!/bin/bash
source paths.sh

curDIR=$PWD

cd $BENCHMARK_HOME_DIR

for dir in $BENCHMARK_DIRS; do

    # Check gem5 benchmark output with native output
    out=$(diff $dir/$dir.na.out $dir/results/m5*/$dir.enc.out | grep "^[<>]" | wc -l)
    if [ $out -gt 0 ]; then
        echo gem5 result for $dir is incorrect.
    fi

done