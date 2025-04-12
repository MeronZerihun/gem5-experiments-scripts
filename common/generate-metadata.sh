#!/bin/bash                                                                                        

# import paths 
# REQUIRES variables for benchmark home directory and 
# list of benchmarks
source ../../gem5-experiments-scripts/paths.sh


# privDIR=~/Privacy
curDIR=$PWD
BIN_DIR=bin

objdump -dS $BIN_DIR/$BMK.enc > $BIN_DIR/$BMK.enc.dump

cd $PIN_DIR/source/tools/InsnTagging

mkdir out

./get_insn_taint.sh $BENCHMARK_DIRS/$BIN_DIR/$BMK.enc $BMK.enc

mv out/editdist-enc.taints $BENCHMARK_DIRS/$BIN_DIR/
mv out/$BMK.enc.taints $BENCHMARK_DIRS/$BIN_DIR/
mv out/$BMK.enc.out    $BENCHMARK_DIRS/$BIN_DIR/$BMK.enc.pin

rm -r out/

cd $curDIR


