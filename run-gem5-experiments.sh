#!/bin/bash
source paths.sh

# parse script arguments 
gem5=${gem5:-clean} # clean, priv
bmk_ext=${bmk_ext:-na} # na, enc
gem5_branch=${gem5_branch:-} # opt-se-128, opt-se-ext-320
enc=${enc:-}
dir=${dir:-}
id=${id:-} # add file identifier for experiment results
cmd_args=$#

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
    --enc=*)
      enc="${1#*=}"
      ;;
    --dir=*)
      dir="${1#*=}"
      ;;
     --id=*)
      id="${1#*=}"
      ;;
    *)
  esac
  shift
done

if [ $gem5 == "priv" ]; then
  if [ $cmd_args -lt 5 ]; then
    printf "%%%% ${RED}ERROR:${NC} Invalid arguments\n"
    printf "%%%% Example Usage: ./run-gem5-experiments.sh --gem5=priv --bmk_ext=enc --gem5_branch=opt-se-128 --enc=40 --dir=dev-bin-se\n"
    exit 1
  fi
else
  if [ $cmd_args -lt 4 ]; then
    printf "%%%% ${RED}ERROR:${NC} Invalid arguments\n"
    printf "%%%% Example Usage: ./run-gem5-experiments.sh --gem5=clean --bmk_ext=enc --gem5_branch=na --dir=dev-bin-na\n"
    exit 1
  fi
fi


# start runs for each benchmark
curDIR=$PWD
for bmk in $BENCHMARK_DIRS; do
    echo "" 
    # copy run.sh into benchmark dir
    cp common/run.sh $BENCHMARK_HOME_DIR/$bmk/run.sh
    # start run.sh 
    cd $BENCHMARK_HOME_DIR/$bmk
    # Remove previous results folder (save memory for debug)
    # if [ $GEM5_DEBUG == true ]; then
    #   rm -rf results
    # fi
    nameId=$id
    if [ -n "$nameId" ]; then
      nameId=$id-
    fi
    mkdir -p results
    if [ -z "$enc" ]; then
      echo No encryption latency provided!
      ./run.sh --bmk=$bmk --gem5=$gem5 --bmk_ext=$bmk_ext --gem5_branch=$gem5_branch --dir=$dir --id=$id | tee results/run-$nameId$(date +'%Y.%m.%d').out &
    else
      ./run.sh --bmk=$bmk --gem5=$gem5 --bmk_ext=$bmk_ext --gem5_branch=$gem5_branch --enc=$enc --dir=$dir --id=$id | tee results/run-enc-$enc-$nameId$(date +'%Y.%m.%d').out &
    fi
    cd $curDIR
done
