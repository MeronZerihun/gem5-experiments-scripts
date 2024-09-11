#!/bin/bash
source paths.sh


# start pin metadata runs for each benchmark
# move pin results into corresponding file in each benchmark dir
curDIR=$PWD

# Build Instruction Taint tracking tool
$PIN_DIR/source/tools/InsnTagging/build_tool.sh

echo "%% Generating metadata for all benchmarks... "
for dir in $BENCHMARK_DIRS; do

    
    echo "%% Generating for" $dir

    cp common/generate-metadata.sh $BENCHMARK_HOME_DIR/$dir/

    cd $BENCHMARK_HOME_DIR/$dir
    objdump -dS bin/$dir.enc > bin/$dir.enc.dump

    cd $curDIR
    cd $PIN_DIR/source/tools/InsnTagging
    mkdir out

    ./get_insn_taint.sh $BENCHMARK_HOME_DIR/$dir/bin/$dir.enc $dir.enc

    mv out/$dir.enc.taints $BENCHMARK_HOME_DIR/$dir/bin/
    mv out/$dir.enc.out    $BENCHMARK_HOME_DIR/$dir/bin/$dir.enc.pin

    rm -r out/
    cd $curDIR

    echo "%%      done."
done
