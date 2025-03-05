#!/bin/bash
source ~/ZeroRISC/gem5-experiments-scripts/paths.sh

AES_128=40
KCIPHER_128=3 
KCIPHER_320=4 
# Auth. encryption using OCB mode: https://eprint.iacr.org/2001/026.pdf
KCIPHER_192_OCB=10 

if [ "$1" == "na" ]; then
    # Build gem5
    cd $CLEAN_GEM5_DIR
    CC=gcc-5 CXX=g++-5 scons build/X86/gem5.opt -j8
    cd ../gem5-experiments-scripts

    # Build benchmarks 
    ./build-all-benchmarks.sh
    
    # Run gem5
    ./run-gem5-experiments.sh --gem5=clean --gem5_branch=master --bmk_ext=na 
    
fi
if [ "$1" == "se" ]; then
    # Build gem5
    cd $GEM5_DIR
    git checkout opt-se-128
    CC=gcc-5 CXX=g++-5 scons build/X86/gem5.opt -j8

    # Configure Encrypted library
    cd ../se-integrity-benchmarks
    ln -sf configs/config.mk.se config.mk
    ln -sf configs/config.h.se config.h
    
    # Build benchmarks, generate taints 
    cd ../gem5-experiments-scripts
    ./build-all-benchmarks.sh
    ./generate-all-metadata.sh
    
    # Run gem5
    ./run-gem5-experiments.sh --gem5=priv --gem5_branch=opt-se-128 --bmk_ext=enc --enc=$KCIPHER_128

fi
if [ "$1" == "se-ext" ]; then
    # Build gem5
    cd $GEM5_DIR
    git checkout opt-se-ext-320
    CC=gcc-5 CXX=g++-5 scons build/X86/gem5.opt -j8

    # Configure Encrypted Library
    cd ../se-integrity-benchmarks
    ln -sf configs/config.mk.se-ext config.mk
    ln -sf configs/config.h.se-ext config.h
    
    # Build benchmarks, generate taints
    cd ../gem5-experiments-scripts
    ./build-all-benchmarks.sh
    ./generate-all-metadata.sh
    
    # Run gem5
    ./run-gem5-experiments.sh --gem5=priv --gem5_branch=opt-se-ext-320 --bmk_ext=enc --enc=$KCIPHER_320

fi
if [ "$1" == "se-ext-ae" ]; then
    # Build gem5
    cd $GEM5_DIR
    git checkout opt-se-ext-ae
    CC=gcc-5 CXX=g++-5 scons build/X86/gem5.opt -j8

    # Configure Encrypted Library
    cd ../se-integrity-benchmarks
    ln -sf configs/config.mk.se-ext-ae config.mk
    ln -sf configs/config.h.se-ext-ae config.h
    
    # Build benchmarks, generate taints
    cd ../gem5-experiments-scripts
    ./build-all-benchmarks.sh
    ./generate-all-metadata.sh
    
    # Run gem5
    ./run-gem5-experiments.sh --gem5=priv --gem5_branch=opt-se-ext-ae --bmk_ext=enc --enc=$KCIPHER_192_OCB
fi