# Directory setup
HOME_DIR=~/ZeroRISC
GEM5_DIR=$HOME_DIR/se-gem5
CLEAN_GEM5_DIR=$HOME_DIR/clean-gem5
BENCHMARK_HOME_DIR=$HOME_DIR/se-integrity-benchmarks
PIN_DIR=$HOME_DIR/encrypted-datatype-taint-tracking

NO_DEBUG=true


# Benchmarks without failing ones (mnist-cnn)
BENCHMARK_DIRS="bubble-sort distinctness edit-distance eulers-number-approx fft-int flood-fill gradient-descent kadane kepler-calc lda mersenne minspan nonlinear-nn nr-solver parrando rad-to-degree shortest-path string-search tea-cipher triangle-count"

# Formatting 
RED='\033[0;31m'
GREEN='\033[0;32m'
GREY='\033[0;33m'
NC='\033[0m' # No Color

