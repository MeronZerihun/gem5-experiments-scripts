#!/bin/bash
source paths.sh


# start pin metadata runs for each benchmark
# move pin results into corresponding file in each benchmark dir
curDIR=$PWD

copy=${dir:-} 
cmd_args=$#

while [ $# -gt 0 ]; do
  case "$1" in
    --dir=*)
      copy="${1#*=}"
      ;;
      esac
  shift
done

# Build Instruction Taint tracking tool
$PIN_DIR/source/tools/InsnTagging/build_tool.sh

echo "%% Generating metadata for all benchmarks... "
for dir in $BENCHMARK_DIRS; do

    rm -rf $BENCHMARK_HOME_DIR/$dir/$copy/

    echo "%% Generating for" $dir

    cp common/generate-metadata.sh $BENCHMARK_HOME_DIR/$dir/

    cd $BENCHMARK_HOME_DIR/$dir
    objdump -dS bin/$dir.enc > bin/$dir.enc.dump

    cd $curDIR
    cd $PIN_DIR/source/tools/InsnTagging
    mkdir out

    ./get_insn_taint.sh $BENCHMARK_HOME_DIR/$dir/bin/$dir.enc $dir.enc

    grep -Pv '^7' out/$dir.enc.taints > out/temp.taints
    grep -v 'push qword' out/temp.taints > out/$dir.enc.taints

    mv out/$dir.enc.taints $BENCHMARK_HOME_DIR/$dir/bin/
    mv out/$dir.enc.out    $BENCHMARK_HOME_DIR/$dir/bin/$dir.enc.pin

    mkdir -p $BENCHMARK_HOME_DIR/$dir/$copy
    cp -r $BENCHMARK_HOME_DIR/$dir/bin/* $BENCHMARK_HOME_DIR/$dir/$copy/

    rm -r out/
    cd $curDIR

    abort=$(grep 'Abort' $BENCHMARK_HOME_DIR/$dir/$copy/$dir.enc.taints)
    readarray -t match_arr <<< "$abort"
    if [[ -n "$abort" ]]; then
      echo Aborts exist in $dir.enc.taints
      for match in "${match_arr[@]}"; do
        line=($match)
        insAddr=${line[2]}
        if [[ $insAddr != 7* ]]; then
          echo Found abort in $dir.enc.taints: $match
          exit 1
        else 
          grep -Fv "$match" $BENCHMARK_HOME_DIR/$dir/$copy/$dir.enc.taints > $BENCHMARK_HOME_DIR/$dir/$copy/taints.out
          mv $BENCHMARK_HOME_DIR/$dir/$copy/taints.out $BENCHMARK_HOME_DIR/$dir/$copy/$dir.enc.taints
        fi
      done
    fi
    

    echo "%%      done."
done
