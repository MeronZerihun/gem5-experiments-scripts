#!/bin/bash

# import paths 
# REQUIRES variables for benchmark home directory and 
# list of benchmarks
source paths.sh

curDIR=$PWD

for dir in $BENCHMARK_DIRS; do

    cd $BENCHMARK_HOME_DIR/$dir

    pwd 
    
    rm -r bin
    mkdir bin

    make clean
    make 'MODE=na'
    mv $dir.na bin/
    
    make clean
    make 'MODE=enc'
    mv $dir.enc bin/
    
    make clean
    cd $curDIR

done


