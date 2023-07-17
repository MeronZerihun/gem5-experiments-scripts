#!/bin/bash

curDIR=$PWD

echo ""

echo -n "Would you like to install gem5? (Y/N): " 
read opt
if [[ "$opt" = "Y" ]]; then
    echo "%% Installing gem5 simulator from git"
    cd ..
    git clone git@bitbucket.org:se-integrity/se-gem5.git
    cd $curDIR
    echo "%% Install completed." 
    echo "%% WARNING: Checkout correct branch and build gem5 before using"
    echo "" 
fi

echo -n "Would you like to install pin metadata generator and related repositories? (Y/N): " 
read opt
if [[ "$opt" = "Y" ]]; then
    echo "%% Installing pin from git"
    cd ..
    git clone git@bitbucket.org:emtdprivacy/encrypted-datatype-taint-tracking.git
    echo "%% Installing metadata synthesis script from git"
    git clone git@bitbucket.org:emtdprivacy/encrypted-metadata-generator.git
    cd ..
    cd $curDIR
    echo "%% Install completed." 
    echo "" 
fi

echo -n "Would you like to install a benchmark directory (Y/N): " 
read opt
if [[ "$opt" = "Y" ]]; then
    echo "%% ERROR: Manually complete benchmark install"
    echo "" 
fi



echo "Before using this expirmental setup, update the correct directory paths in paths.sh" 
echo "  - ''build-all-benchmarks'' compiles each benchmark in BENCHMARK_HOME_DIR"
echo "  - ''generate-benchmark-metadata'' generates pin metadata for each benchmark in BENCHMARK_HOME_DIR"
echo "  - ''run-gem5-experiments'' initates a gem5 run for each benchmark in BENCHMARK_HOME_DIR"
echo "  - ''print-gem5-results'' parses the m5out data for each benchmark in BENCHMARK_HOME_DIR"
echo " "
