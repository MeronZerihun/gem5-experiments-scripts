#!/bin/bash

# import paths 
# REQUIRES variables for GEM5_DIR
source ../../gem5-experiments-scripts/paths.sh


# parse script arguments 
# (these arguments can be updated to match project, 
#  but any changes should also be reflected in other scripts)
gem5=${gem5:-clean} #clean, priv
bmk_ext=${bmk_ext:-na} #na, enc
gem5_branch=${gem5_branch:-} #opt-se-128, #opt-se-ext-320
bmk=${bmk:-} #name of bmk dir
enc=${enc:-} #encryption latency

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
    --bmk=*)
      bmk="${1#*=}"
      ;;
     --enc=*)
      enc="${1#*=}"
      ;;
    *)
      printf "***************************\n"
      printf "* Error: Invalid argument.*\n"
      printf "***************************\n"
      exit 1
  esac
  shift
done

mkdir -p results
BIN_DIR=bin

rm -rf $BENCHMARK_HOME_DIR/$bmk/bin
if [[ $gem5_branch == *"se-128"* ]]; then
  mkdir -p $BENCHMARK_HOME_DIR/$bmk/bin
  cp -r $BENCHMARK_HOME_DIR/$bmk/bin-se/* $BENCHMARK_HOME_DIR/$bmk/bin
fi
if [[ $gem5_branch == *"se-ext"* ]]; then
  mkdir -p $BENCHMARK_HOME_DIR/$bmk/bin
  cp -r $BENCHMARK_HOME_DIR/$bmk/bin-se-ext/* $BENCHMARK_HOME_DIR/$bmk/bin
fi
if [[ $gem5_branch == *"se-ext-ae"* ]]; then
  mkdir -p $BENCHMARK_HOME_DIR/$bmk/bin
  cp -r $BENCHMARK_HOME_DIR/$bmk/bin-se-ae-ext/* $BENCHMARK_HOME_DIR/$bmk/bin
fi


RESULT_DIR=results
CUR_DIR=$PWD

# correct if we are running clean-gem5
if [ "$gem5" == "clean" ]; then
        GEM5_DIR=$CLEAN_GEM5_DIR
fi
# add debug flags if we are running se
EXTRA_FLAG=' '
if [ "$gem5" != "clean" ]; then
        # EXTRA_FLAG='--debug-flags=ExecEnable,ExecMicro,priv,csd'
        EXTRA_FLAG='--debug-flags=ExecEnable,csd'
fi

if [ "$bmk_ext" == "na" ]; then
  CONFIG_FILE=$GEM5_DIR/configs/priv/vip-bench/$bmk-native.py
else
  CONFIG_FILE=$GEM5_DIR/configs/priv/vip-bench/$bmk-$bmk_ext.py
fi

# color variables
RED='\033[01;31m'
GREEN='\033[0;32m'
GREY='\033[00;33m'
NC='\033[0m' # No Color
printf "%%%% ${RED}WARNING:${NC} gem5 configuration files have not been update for se-integrity. Using old config files.\n"

cd $BIN_DIR

ln -sf $GEM5_DIR/ext/ ./ext
if [ -z "$enc" ]; then
  $GEM5_DIR/build/X86/gem5.opt $EXTRA_FLAG --debug-file=debug.out --stats-file=stats.txt $CONFIG_FILE
  cd $CUR_DIR
  # If NO_DEBUG, remove debug results
  if [ "$NO_DEBUG" == "true" ]; then
    mv $BIN_DIR/m5out/stats.txt $RESULT_DIR/m5out-$gem5-$gem5_branch-$bmk_ext-$(date +'%Y.%m.%d-%H:%M')
    rm -rf $BIN_DIR/m5out
  else
    mv $BIN_DIR/m5out $RESULT_DIR/m5out-$gem5-$gem5_branch-$bmk_ext-$(date +'%Y.%m.%d-%H:%M')
  fi
else
  $GEM5_DIR/build/X86/gem5.opt $EXTRA_FLAG --debug-file=debug.out --stats-file=stats.txt $CONFIG_FILE $enc
  cd $CUR_DIR
  # If NO_DEBUG, remove debug results
  if [ "$NO_DEBUG" == "true" ]; then
    mv $BIN_DIR/m5out/stats.txt $RESULT_DIR/m5out-$gem5-$gem5_branch-$bmk_ext-$(date +'%Y.%m.%d-%H:%M')-stats.txt
    rm -rf $BIN_DIR/m5out
  else
    mv $BIN_DIR/m5out $RESULT_DIR/m5out-enc-$enc-$gem5-$gem5_branch-$bmk_ext-$(date +'%Y.%m.%d-%H:%M')
  fi
fi


