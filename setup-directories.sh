#!/bin/bash

curDIR=$PWD

# color variables
RED='\033[01;31m'
GREEN='\033[0;32m'
GREY='\033[00;33m'
NC='\033[0m' # No Color
echo ""
# other formatting
indent() { sed 's/^/    /g'; }



echo -n "Would you like to install se-gem5? (y/n): " 
read opt
if [[ "$opt" = "y" ]]; then
    mkdir -p ../gem5-versions
    cd ../gem5-versions/
    printf "%%%% Installing gem5 simulator from git${GREY}\n"
    git clone git@bitbucket.org:se-integrity/se-gem5.git  
    cd se-gem5
    git checkout opt-se-128 
    cd $curDIR
    printf "${NC}%%%% Install completed.\n"
    printf "%%%% ${RED}WARNING:${NC} Checkout correct branch and build gem5 before using\n"
    echo "" 
fi



echo -n "Would you like to build se-gem5? (y/n): " 
read opt
if [[ "$opt" = "y" ]]; then
    cd ../gem5-versions/se-gem5
    printf "%%%% Building se-gem5 on X86 with eight threads${GREY}\n"
    CC=gcc-5 CXX=g++-5 scons build/X86/gem5.opt -j8 
    cd $curDIR
    printf "${NC}%%%% Build completed.\n\n" 
fi



echo -n "Would you like to install clean-gem5? (y/n): " 
read opt
if [[ "$opt" = "y" ]]; then
    cd ../gem5-versions/
    printf "%%%% Installing gem5 simulator from git${GREY}\n"
    git clone git@bitbucket.org:emtdprivacy/clean-gem5.git 
    cd $curDIR
    printf "${NC}%%%% Install completed.\n"
    echo "" 
fi



echo -n "Would you like to install pin metadata generator and related repositories? (y/n): " 
read opt
if [[ "$opt" = "y" ]]; then
    cd ..
    printf "%%%% Installing pin from git${GREY}\n"
    git clone git@bitbucket.org:emtdprivacy/encrypted-datatype-taint-tracking.git
    # build pin tool
    printf "${NC}%%%% Install completed.\n"
    printf "%%%% Building pin module${GREY}\n"
    cd encrypted-datatype-taint-tracking/source/tools/InsnTagging 
    mkdir -p obj-intel64
    make obj-intel64/taint_global_ciphertexts.so CC=gcc-5 CXX=g++-5
    cd ../../../../
    printf "${NC}%%%% Build completed.\n"
    printf "%%%% Installing metadata synthesis script from git${GREY}\n"
    git clone git@bitbucket.org:emtdprivacy/encrypted-metadata-generator.git 
    cd $curDIR
    printf "${NC}%%%% Install completed.\n"
    echo "" 
fi



echo -n "Would you like to install a benchmark directory (y/n): " 
read opt
if [[ "$opt" = "y" ]]; then
    cd ..
    printf "%%%% Installing benchmarks from git${GREY}\n"
    git clone git@bitbucket.org:se-integrity/se-integrity-benchmarks.git 
    cd se-integrity-benchmarks
    ln -sf configs/config.h.se config.h 
    ln -sf configs/config.mk.se config.mk 
    printf "${NC}%%%% Install completed.\n"
    cd $curDIR
    printf "%%%% ${RED}ERROR:${NC} This is a placeholder repo!\n"
    echo "" 
fi




printf "%%%%${NC} Before using this expirmental setup, update the correct directory paths in paths.sh\n" 
echo "  - ''build-all-benchmarks'' compiles each benchmark in BENCHMARK_HOME_DIR"
echo "  - ''generate-all-metadata'' generates pin metadata for each benchmark in BENCHMARK_HOME_DIR"
echo "  - ''run-gem5-experiments'' initates a gem5 run for each benchmark in BENCHMARK_HOME_DIR"
echo "  - ''print-all-gem5-results'' parses the m5out data for each benchmark in BENCHMARK_HOME_DIR"
echo " "
