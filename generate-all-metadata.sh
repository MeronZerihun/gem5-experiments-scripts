#!/bin/bash

# import paths 
# REQUIRES variables for benchmark home directory and 
# list of benchmarks
source path.sh


# start pin metadata runs for each benchmark
# move pin results into corresponding file in each benchmark dir
curDIR=$PWD

for dir in $BENCHMARK_DIRS; do

    echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
    echo "%% GENERATING METADATA for" $dir

    cp generate-metadata.sh $BENCHMARK_HOME_DIR/$dir/

    cd $BENCHMARK_HOME_DIR/$dir
    objdump -dS bin/$dir.enc > bin/$dir.enc.dump

    cd $PIN_DIR/source/tools/InsnTagging
    mkdir out
    ./get_insn_taint.sh $curDIR/$dir/bin/$dir.enc $dir.enc
    
    mv out/$dir.enc.taints $BENCHMARK_HOME_DIR/$dir/bin/
    mv out/$dir.enc.out    $BENCHMARK_HOME_DIR/$dir/bin/$dir.enc.pin

    rm -r out/
    cd $curDIR

    echo "%% Metadata CONCLUDED"
    echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"

done
