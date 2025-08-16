#!/bin/bash

# import paths 
# REQUIRES variables for GEM5_DIR
source ../../gem5-experiments-scripts/paths.sh


# parse script arguments 
# (these arguments can be updated to match project, 
# but any changes should also be reflected in other scripts)
gem5=${gem5:-clean} # clean, priv
bmk_ext=${bmk_ext:-na} # na, enc
gem5_branch=${gem5_branch:-} # se, se-ext
bmk=${bmk:-} # name of bmk dir
enc=${enc:-} # encryption latency
dir=${dir:-} # directory for pin taint metadata
id=${id:-} # experiment id
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
    --dir=*)
      dir="${1#*=}"
      ;;
    --id=*)
      id="${1#*=}"
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

mkdir -p $BENCHMARK_HOME_DIR/$bmk/$BIN_DIR
cp -r $BENCHMARK_HOME_DIR/$bmk/$dir/* $BENCHMARK_HOME_DIR/$bmk/$BIN_DIR

RESULT_DIR=results
CUR_DIR=$PWD

# correct if we are running clean-gem5
if [ "$gem5" == "clean" ]; then
        GEM5_DIR=$CLEAN_GEM5_DIR
fi
# add debug flags if we are running se
EXTRA_FLAG=' '
if [ "$gem5" != "clean" ]; then
  if [ $GEM5_BMK_RESULTS == true ]; then
    EXTRA_FLAG='--debug-flags=ExecEnable'
  fi
  if [ $GEM5_DEBUG == true ]; then
    # EXTRA_FLAG='--debug-flags=ExecEnable,ExecMicro,priv,csd'
    EXTRA_FLAG='--debug-flags=ExecEnable,csd'
  fi
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

# Default: AES-128 Latency
encryption=40

ln -sf $GEM5_DIR/ext/ ./ext

if [ -n "$enc" ]; then
  encryption=$enc
fi

$GEM5_DIR/build/X86/gem5.opt $EXTRA_FLAG --debug-file=debug.out --stats-file=stats.txt $CONFIG_FILE $encryption

cd $CUR_DIR

nameId=$id
if [ -n "$nameId" ]; then
  nameId=$id-
fi
m5dir=m5out-enc-$encryption-$gem5-$gem5_branch-$bmk_ext-$nameId$(date +'%Y.%m.%d-%H:%M')
if [[ $GEM5_DEBUG == true || $GEM5_BMK_RESULTS == true ]]; then
  cp $BIN_DIR/m5out/stats.txt $RESULT_DIR/$m5dir-stats.txt
  mv $BIN_DIR/m5out $RESULT_DIR/$m5dir 
  if [[ $bmk == "mnist-cnn" ]]; then
    cp $BIN_DIR/mnist-cnn.kan $RESULT_DIR/$m5dir
    cp $BIN_DIR/mnist-test-x.knd $RESULT_DIR/$m5dir
  fi
else
  mv $BIN_DIR/m5out/stats.txt $RESULT_DIR/$m5dir-stats.txt
fi

rm -rf $BIN_DIR/m5out
if [ $GEM5_DEBUG != true ]; then
  rm -rf $BIN_DIR
fi


