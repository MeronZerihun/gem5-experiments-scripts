#!/bin/bash

# import paths 
# REQUIRES variables for benchmark home directory and 
# list of benchmarks
source path.sh

curDIR=$PWD

for dir in $BENCHMARK_DIRS; do

    cd $dir
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


