#!/bin/bash

curDIR=$PWD

# color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
GREY='\033[0;33m'
NC='\033[0m' # No Color
echo ""


echo -n "Would you like to install se-gem5? (y/n): " 
read opt
if [[ "$opt" = "y" ]]; then
    cd ../gem5-versions/
    printf "%%%% ${GREEN}Installing gem5 simulator from git${NC}\n"
    git clone git@bitbucket.org:se-integrity/se-gem5.git
    cd se-gem5
    git checkout opt-se-128
    cd $curDIR
    echo "%% Install completed." 
    printf "%% ${RED}WARNING:${NC} Checkout correct branch and build gem5 before using\n"
    echo "" 
fi

echo -n "Would you like to build se-gem5? (y/n): " 
read opt
if [[ "$opt" = "y" ]]; then
    cd ../gem5-versions/se-gem5
    printf "%%%% ${GREEN}Building se-gem5 on X86 with eight threads${NC}\n"
    python2 `which scons` build/X86/gem5.opt -j8
    # CC=gcc-5 CXX=g++-5 scons build/X86/gem5.opt -j8 <-- This is the command I used to use, 
    # but it is giving me errors on the new poisonivy update...
    echo "%% Build completed." 
    echo "" 
fi

echo -n "Would you like to install clean-gem5? (y/n): " 
read opt
if [[ "$opt" = "y" ]]; then
    cd ../gem5-versions/
    printf "%%%% ${GREEN}Installing gem5 simulator from git${NC}\n"
    git clone git@bitbucket.org:emtdprivacy/clean-gem5.git
    cd $curDIR
    echo "%% Install completed." 
    echo "" 
fi

echo -n "Would you like to install pin metadata generator and related repositories? (y/n): " 
read opt
if [[ "$opt" = "y" ]]; then
    cd ..
    printf "%%%% ${GREEN}Installing pin from git${NC}\n"
    git clone git@bitbucket.org:emtdprivacy/encrypted-datatype-taint-tracking.git
    echo "%% Install completed." 
    printf "%%%% ${GREEN}Installing metadata synthesis script from git${NC}\n"
    git clone git@bitbucket.org:emtdprivacy/encrypted-metadata-generator.git
    cd $curDIR
    echo "%% Install completed." 
    echo "" 
fi

echo -n "Would you like to install a benchmark directory (y/n): " 
read opt
if [[ "$opt" = "y" ]]; then
    cd ..
    printf "%%%% ${GREEN}Installing benchmarks from git${NC}\n"
    git clone git@bitbucket.org:se-integrity/se-integrity-benchmarks.git
    cd se-integrity-benchmarks
    ln -sf configs/config.h.se config.h
    ln -sf configs/config.mk.se config.mk
    echo "%% Install completed." 
    cd $curDIR
    printf "%%%% ${RED}ERROR:${NC} This is a placeholder repo!\n"
    echo "" 
fi

# echo -n "Would you like to install a placeholder for the SE type library? (y/n): " 
# read opt
# if [[ "$opt" = "y" ]]; then
#     cd ..
#     printf "%%%% ${GREEN}Installing SE type library from git${NC}\n"
#     git clone git@bitbucket.org:emtdprivacy/encrypted-datatype-library.git
#     echo "%% Install completed." 
#     git checkout vip-bench-support
#     cd $curDIR
#     printf "%%%% ${RED}ERROR:${NC} This is a placeholder repo!\n"
#     echo "" 
# fi



printf "%%%% ${RED}WARNING:${NC} Before using this expirmental setup, update the correct directory paths in paths.sh\n" 
echo "  - ''build-all-benchmarks'' compiles each benchmark in BENCHMARK_HOME_DIR"
echo "  - ''generate-all-metadata'' generates pin metadata for each benchmark in BENCHMARK_HOME_DIR"
echo "  - ''run-gem5-experiments'' initates a gem5 run for each benchmark in BENCHMARK_HOME_DIR"
echo "  - ''print-all-gem5-results'' parses the m5out data for each benchmark in BENCHMARK_HOME_DIR"
echo " "
