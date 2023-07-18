#!/bin/bash

# import paths 
# REQUIRES variables for benchmark home directory and 
# list of benchmarks
source path.sh


# parse script arguments 
# (these arguments can be updated to match project, 
#  but any changes should also be reflected in other scripts)
gem5=${gem5:-clean} #clean, priv
bmk_ext=${bmk_ext:-na} #na, enc
gem5_branch=${gem5_branch:-} #naive-se-128, naive-se-256, opt-se-128, opt-se-256
while [ $# -gt 0 ]; do
  case "$1" in
    --gem5=*)
      gem5="${1#*=}"
      ;;
    --bmk_ext=*)
      bmk_ext="${1#*=}"
      ;;
    --gem5_branch=*)
      gem5_branch="${1#*=}"
      ;;
    *)
      printf "***************************\n"
      printf "* Error: Invalid argument.*\n"
      printf "***************************\n"
      exit 1
  esac
  shift
done



# start runs for each benchmark
curDIR=$PWD
for dir in $BENCHMARK_DIRS; do
    # copy run.sh into benchmark dir
    cp common/run.sh $BENCHMARK_HOME_DIR/$dir/run.sh
    # start run.sh 
    cd $BENCHMARK_HOME_DIR/$dir
    ./run.sh --bmk=$dir --gem5=$gem5 --bmk_ext=$bmk_ext --gem5_branch=$gem5_branch| tee results/run-$gem5-$gem5_branch-$bmk_ext-$(date +'%Y.%m.%d').out &
    cd $curDIR
done
