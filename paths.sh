# Directory setup
HOME_DIR=~/VC
GEM5_DIR=~/VC/gem5-versions/se-gem5
CLEAN_GEM5_DIR=~/VC/gem5-versions/clean-gem5
BENCHMARK_HOME_DIR=~/VC/se-integrity-benchmarks
PIN_DIR=~/VC/encrypted-datatype-taint-tracking

#         ---- VIP-Bench Details ----
# boyer-moyer-search renamed to string-search
# benchmark-missing: scalar-gwas-chi2
# gem5 python-script missing: hamm-distance dot-product linear-reg poly-reg roberts-cross vector-gwas-chi2
# benchmarks not in SE paper: filtered-query primal-test
# 
# 21 Benchmarks to be added to the paper
# BENCHMARKS = "bubble-sort distinctness edit-distance eulers-number-approx fft-int flood-fill gradient-descent kadane kepler-calc lda mersenne minspan mnist-cnn nonlinear-nn nr-solver parrando rad-to-degree shortest-path string-search tea-cipher triangle-count" 
# Metadata Generation failing for: mnist-cnn (It fails with a segmentation fault)
# gem5 failing for reading unmapped memory: edit-distance flood-fill 
# Running gem5 on a bunch of benchmarks is also failing
# 

# benchmarks without failing ones (mnist-cnn, edit-distance, flood-fill)
BENCHMARK_DIRS="bubble-sort distinctness eulers-number-approx fft-int gradient-descent kadane kepler-calc lda mersenne minspan nonlinear-nn nr-solver parrando rad-to-degree shortest-path string-search tea-cipher triangle-count"
# BENCHMARK_DIRS="mnist-cnn"

# Formatting 
RED='\033[0;31m'
GREEN='\033[0;32m'
GREY='\033[0;33m'
NC='\033[0m' # No Color

