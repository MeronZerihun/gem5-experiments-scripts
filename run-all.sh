#!/bin/bash
set -e # Exit script if encountered an error
source ~/ZeroRISC/gem5-experiments-scripts/paths.sh

AES_128=40
KCIPHER_128=3 
KCIPHER_320=4 
# OCB mode: https://eprint.iacr.org/2001/026.pdf
KCIPHER_OCB=10 

curDIR=$PWD

#  ---- For Taint Metadata Generation Only ----
if [ "$1" == "se-meta" ]; then

    # Configure Encrypted library
    cd $BENCHMARK_HOME_DIR
    ln -sf configs/config.mk.se config.mk
    ln -sf configs/config.h.se config.h
    
    # Build benchmarks, generate taints
    cd $curDIR
    ./build-all-benchmarks.sh $1 $2-bin-$1
    ./generate-all-metadata.sh --dir=$2-bin-$1

fi
if [ "$1" == "se-ext-meta" ]; then

    # Configure Encrypted Library
    cd $BENCHMARK_HOME_DIR
    ln -sf configs/config.mk.se-ext config.mk
    ln -sf configs/config.h.se-ext config.h
    
    # Build benchmarks, generate taints
    cd ../gem5-experiments-scripts
    ./build-all-benchmarks.sh $1 $2-bin-$1
    ./generate-all-metadata.sh --dir=$2-bin-$1

fi


# ---- gem5 Experiments ----
if [[ "$1" == "na" || "$1" == "do" ]]; then
    # Build gem5
    cd $CLEAN_GEM5_DIR
    CC=gcc-5 CXX=g++-5 scons build/X86/gem5.opt -j8
    cd ../gem5-experiments-scripts

    # Build benchmarks 
    ./build-all-benchmarks.sh $1 $2-bin
    
    # Run gem5
    ./run-gem5-experiments.sh --gem5=clean --gem5_branch=master --bmk_ext=$1 --dir=$2-bin
fi
if [ "$1" == "se" ]; then
    # Build gem5
    cd $GEM5_DIR
    git checkout $1
    CC=gcc-5 CXX=g++-5 scons build/X86/gem5.opt -j8

    # Set encrypted library
    cd $BENCHMARK_HOME_DIR
    ln -sf configs/config.mk.se config.mk
    ln -sf configs/config.h.se config.h
    
    # Build benchmarks, generate taints
    cd $curDIR
    ./build-all-benchmarks.sh $1 $2-bin-$1
    ./generate-all-metadata.sh --dir=$2-bin-$1
    
    # Run gem5
    ./run-gem5-experiments.sh --gem5=priv --gem5_branch=$1 --bmk_ext=enc --enc=$KCIPHER_128 --dir=$2-bin-$1
fi
if [ "$1" == "se-ext" ]; then
    # Build gem5
    cd $GEM5_DIR
    git checkout $1
    CC=gcc-5 CXX=g++-5 scons build/X86/gem5.opt -j8

    # Configure Encrypted Library
    cd ../se-integrity-benchmarks
    ln -sf configs/config.mk.se-ext config.mk
    ln -sf configs/config.h.se-ext config.h
    
    # Build benchmarks, generate taints
    cd ../gem5-experiments-scripts
    ./build-all-benchmarks.sh $1 $2-bin-$1
    ./generate-all-metadata.sh --dir=$2-bin-$1
    
    # Run gem5
    ./run-gem5-experiments.sh --gem5=priv --gem5_branch=$1 --bmk_ext=enc --enc=$KCIPHER_320 --dir=$2-bin-$1

fi
# SE with 320-bit struct, 2x loads, and encryption latency
if [ "$1" == "se-ext-opt-no-hash" ]; then

    myGem5=se
    myBmk=se-ext

    # Build gem5
    cd $GEM5_DIR
    git checkout $myGem5
    CC=gcc-5 CXX=g++-5 scons build/X86/gem5.opt -j8

    # Set encrypted library
    cd $BENCHMARK_HOME_DIR
    ln -sf configs/config.mk.$myBmk config.mk
    ln -sf configs/config.h.$myBmk config.h
    
    # Build benchmarks, generate taints
    cd $curDIR
    ./build-all-benchmarks.sh $myBmk $2-bin-$myBmk
    ./generate-all-metadata.sh --dir=$2-bin-$myBmk
    
    # Run gem5 (Check: should encryption latency be 128 or 320-bit?)
    ./run-gem5-experiments.sh --gem5=priv --gem5_branch=$myGem5 --bmk_ext=enc --enc=$KCIPHER_128 --dir=$2-bin-$myBmk --id=$1
fi
# SE with 320-bit struct, 5x loads, and encryption latency
if [ "$1" == "se-ext-no-hash" ]; then

    myGem5=$1
    myBmk=se-ext

    # Build gem5
    cd $GEM5_DIR
    git checkout $myGem5
    CC=gcc-5 CXX=g++-5 scons build/X86/gem5.opt -j8

    # Set encrypted library
    cd $BENCHMARK_HOME_DIR
    ln -sf configs/config.mk.$myBmk config.mk
    ln -sf configs/config.h.$myBmk config.h
    
    # Build benchmarks, generate taints
    cd $curDIR
    ./build-all-benchmarks.sh $myBmk $2-bin-$myBmk
    ./generate-all-metadata.sh --dir=$2-bin-$myBmk
    
    # Run gem5
    ./run-gem5-experiments.sh --gem5=priv --gem5_branch=$myGem5 --bmk_ext=enc --enc=$KCIPHER_320 --dir=$2-bin-$myBmk --id=$1
fi
# Ideal: SE with 128-bit struct, 2x loads, Encryption latency, Hash Latency
if [ "$1" == "se-hash" ]; then

    myGem5=$1
    myBmk=se

    # Build gem5
    cd $GEM5_DIR
    git checkout $myGem5
    CC=gcc-5 CXX=g++-5 scons build/X86/gem5.opt -j8

    # Set encrypted library
    cd $BENCHMARK_HOME_DIR
    ln -sf configs/config.mk.$myBmk config.mk
    ln -sf configs/config.h.$myBmk config.h
    
    # Build benchmarks, generate taints
    cd $curDIR
    ./build-all-benchmarks.sh $myBmk $2-bin-$myBmk
    ./generate-all-metadata.sh --dir=$2-bin-$myBmk
    
    # Run gem5
    ./run-gem5-experiments.sh --gem5=priv --gem5_branch=$myGem5 --bmk_ext=enc --enc=$KCIPHER_128 --dir=$2-bin-$myBmk --id=$1
fi
# SE with 448-bit struct, SE (2 loads) + 5 loads, Authenticated encryption + hash latency
if [ "$1" == "se-ext-ae" ]; then

    myGem5=$1
    myBmk=$1

    # Build gem5
    cd $GEM5_DIR
    git checkout $myGem5
    CC=gcc-5 CXX=g++-5 scons build/X86/gem5.opt -j8

    # Set encrypted library
    cd $BENCHMARK_HOME_DIR
    ln -sf configs/config.mk.$myBmk config.mk
    ln -sf configs/config.h.$myBmk config.h
    
    # Build benchmarks, generate taints
    cd $curDIR
    ./build-all-benchmarks.sh $myBmk $2-bin-$myBmk
    ./generate-all-metadata.sh --dir=$2-bin-$myBmk
    
    # Run gem5
    ./run-gem5-experiments.sh --gem5=priv --gem5_branch=$myGem5 --bmk_ext=enc --enc=$KCIPHER_OCB --dir=$2-bin-$myBmk --id=$1
fi