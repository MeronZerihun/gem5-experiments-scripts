#!/bin/bash

# Build and run gem5
cd $PWD/se-gem5
git checkout opt-se-128-QARMA
CC=gcc-5 CXX=g++-5 scons build/X86/gem5.opt -j8


cd ../gem5-experiments-scripts
./build-all-benchmarks.sh
./generate-all-metadata.sh
./run-gem5-experiments.sh --gem5=priv --gem5_branch=opt-se-128-QARMA --bmk_ext=enc