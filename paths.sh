# Directory setup
HOME_DIR=~/Integrity/ZeroRISC-128
GEM5_DIR=~/Integrity/ZeroRISC-128/se-gem5
CLEAN_GEM5_DIR=~/Integrity/ZeroRISC-128/clean-gem5
BENCHMARK_HOME_DIR=~/Integrity/ZeroRISC-128/se-integrity-benchmarks
PIN_DIR=~/Integrity/ZeroRISC-128/encrypted-datatype-taint-tracking


# Benchmarks without failing ones (mnist-cnn, edit-distance, flood-fill)
BENCHMARK_DIRS="bubble-sort bitonic-sort distinctness eulers-number-approx fft-int gradient-descent kadane kepler-calc lda mersenne minspan nonlinear-nn nr-solver parrando rad-to-degree shortest-path string-search string-search-optimized tea-cipher triangle-count"

# Formatting 
RED='\033[0;31m'
GREEN='\033[0;32m'
GREY='\033[0;33m'
NC='\033[0m' # No Color

