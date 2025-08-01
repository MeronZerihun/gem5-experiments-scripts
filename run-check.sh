#!/bin/bash
source paths.sh

curDIR=$PWD

cd $BENCHMARK_HOME_DIR

for dir in $BENCHMARK_DIRS; do
    lib=$(grep -P '^7' $dir/$2-bin-$1/$dir.enc.taints | wc -l)
    push=$(grep 'push qword' $dir/$2-bin-$1/$dir.enc.taints | wc -l)

    if [ $NO_DEBUG == false ]; then
        abort=$(grep 'Abort' $dir/$2-bin-$1/$dir.enc.pin | wc -l)
        if [ $abort -gt 0 ]; then
            echo abort in $2-$1/$dir.enc.pin
            exit 1
        fi 
    fi
    if [ $lib -gt 0 ]; then
        echo Tainted lib in $2-$1/$dir.enc.taints
        exit 1 
    fi
    if [ $push -gt 0 ]; then
        echo push qword in $2-$1/$dir.enc.taints
        exit 1
    fi

done