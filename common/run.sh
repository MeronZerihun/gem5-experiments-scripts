#!/bin/bash

# import paths 
# REQUIRES variables for GEM5_DIR
source ../../gem5-experiments-scripts/paths.sh


# parse script arguments 
# (these arguments can be updated to match project, 
#  but any changes should also be reflected in other scripts)
gem5=${gem5:-clean} #clean, priv
bmk_ext=${bmk_ext:-na} #na, enc
gem5_branch=${gem5_branch:-} #naive-se-128, naive-se-256, opt-se-128, opt-se-256i
bmk=${bmk:-} #name of bmk dir

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
RESULT_DIR=results
CUR_DIR=$PWD

# correct if we are running clean-gem5
clean=clean
if [[ "$gem5" == "$clean" ]]; then
        GEM5_DIR=CLEAN_GEM5_DIR
fi
# add debug flags if we are running se
EXTRA_FLAG=' '
if [[ "$gem5" != "$clean" ]]; then
        EXTRA_FLAG='--debug-flags=Exec,priv,csd'
fi


CONFIG_FILE=$GEM5_DIR/configs/priv/vip-bench/$bmk-$bmk_ext.py

# color variables
RED='\033[01;31m'
GREEN='\033[0;32m'
GREY='\033[00;33m'
NC='\033[0m' # No Color
printf "%%%% ${RED}WARNING:${NC} gem5 configuration files have not been update for se-integrity. Using old config files.\n"



cd $BIN_DIR

ln -sf $GEM5_DIR/ext/ ./ext

$GEM5_DIR/build/X86/gem5.opt $EXTRA_FLAG --debug-file=debug.out --stats-file=stats.txt $CONFIG_FILE

cd $CUR_DIR

mv $BIN_DIR/m5out $RESULT_DIR/m5out-$gem5-$gem5_branch-$bmk_ext-$(date +'%Y.%m.%d-%H:%M')
