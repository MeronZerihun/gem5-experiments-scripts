#!/bin/bash
source paths.sh

curDIR=$PWD

for dir in $BENCHMARK_DIRS; do
    cd $BENCHMARK_HOME_DIR/$dir
    rm -r bin
    mkdir bin

    make clean
    make 'MODE=na' CC=gcc-5 CXX=g++-5
    ./$dir.na > $dir.na.out
    mv $dir.na bin/

    make clean
    make 'MODE=do' CC=gcc-5 CXX=g++-5
    mv $dir.do bin/
    
    make clean
    make 'MODE=enc' CC=gcc-5 CXX=g++-5
    mv $dir.enc bin/

    if [ $dir == "mnist-cnn" ]; then
        cp mnist-test-x.knd bin/
        cp mnist-cnn.kan bin/
    fi
    
    make clean
    cd $curDIR
done


