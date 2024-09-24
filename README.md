# ZeroRISC Experiment Setup
This environment includes all files we use to evaluate the costs of adding integrity to SE.

## Building gem5
We build gem5 on Ubuntu 18.04 system. 

### Dependencies
#### Python and dependencies
```bash
apt update
apt upgrade
apt install -y python2.7
# Install pip for python 2.7 
apt install wget
wget -c https://bootstrap.pypa.io/pip/2.7/get-pip.py get-pip.py
python get-pip.py
# Fix for gem5 build fail: "Module six not found" 
pip install six
```
#### GCC-5:
```bash
apt install -y g++-5 gcc-5
```
#### General gem5 dependencies
```bash
apt install -y build-essential git m4 scons zlib1g zlib1g-dev libprotobuf-dev protobuf-compiler libprotoc-dev libgoogle-perftools-dev
```

#### Building gem5
```bash
$GEM5_ROOT_DIR = ~/Integrity/ZeroRISC-128/se-gem5
cd $GEM5_ROOT_DIR
CC=gcc-5 CXX=g++-5 scons build/X86/gem5.opt -j8
``` 

## Running ZeroRISC simulation 
```bash
cd /Integrity/ZeroRISC-128
./gem5-experiments-scripts/run-all.sh
```

# Modifying gem5
I have found issues committing changes to se-gem5 due to a style checker throwing invalid line-length and whitespaces error. I have tried word wrapping but it doesn't seem to help so a work around it will be to disable the pre-commit hook as follows:
```bash
git commit -m [your-message] --no-verify
```

## Experiments 

#### Missing benchmarks
- These benchmarks are missing from `se-integrity-benchmarks`:
    - scalar-gwas-chi2
- These benchmarks are missing a python-script file in `se-gem5`
    - hamm-distance 
    - dot-product 
    - linear-reg 
    - poly-reg 
    - roberts-cross 
    - vector-gwas-chi2
- These benchmarks are not in the SEED paper for SE:         
    - filtered-query 
    - primal-test

#### Tested benchmarks
- boyer-moyer-search has been renamed to string-search
- We are using 21 benchmarks: 
    1. bubble-sort 
    2. distinctness 
    3. edit-distance 
    4. eulers-number-approx 
    5. fft-int 
    6. flood-fill 
    7. gradient-descent 
    8. kadane 
    9. kepler-calc 
    10. lda 
    11. mersenne 
    12. minspan 
    13. mnist-cnn 
    14. nonlinear-nn 
    15. nr-solver 
    16. parrando 
    17. rad-to-degree 
    18. shortest-path 
    19. string-search 
    20. tea-cipher 
    21. triangle-count
- We have added `bitonic-sort` and optimized boyer-moore string-search (`string-search-optimized`) from the ISPASS paper.
#### Failing Experiments 
- Pin Taint metadata generation is failing for: mnist-cnn (error: seg fault)
- gem5 simulation is failing for: edit-distance flood-fill (error: reading unmapped memory)

