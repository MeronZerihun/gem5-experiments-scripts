#!/bin/bash
# Command: ./stats-get-tainted-loads.sh m5out-enc-3 se

source paths.sh

curDIR=$PWD

mkdir -p csv

benchmark_stat_file=results/$1*stats.txt
filtered_stats=results/m5out_filtered_stats.out
final_stats=$PWD/csv/stats_tainted_load_$2.csv

for dir in $BENCHMARK_DIRS; do
    cd $BENCHMARK_HOME_DIR/$dir

    echo $dir > $filtered_stats

    # Tainted Instructions
    grep -rh 'cpu.commit.committedInstsTainted' $benchmark_stat_file >> $filtered_stats

    # Committed Tainted Load Instructions
    grep -rh 'metadata.committedTaintedLoadOps' $benchmark_stat_file >> $filtered_stats

    # Loads committed
    grep -rh 'cpu.commit.loads' $benchmark_stat_file >> $filtered_stats

    # Simulated microops (same as op_class_0::total)
    grep -rh 'sim_ops' $benchmark_stat_file >> $filtered_stats

    cd $curDIR
done


touch $final_stats
echo -e "Benchmarks,Committed Insts Tainted,Tainted Loads,Committed Loads,Simulated Total Ops" > $final_stats

for dir in $BENCHMARK_DIRS; do
    cd $BENCHMARK_HOME_DIR/$dir

    file_lines=()
    
    while read line; do
        # Process the line here
        file_lines+=("$line")
    done < $filtered_stats

    # Benchmark Name
    line=${file_lines[0]}, 

    # Committed Instructions Tainted
    stat=${file_lines[1]}
    IFS=' ' read -r -a arr <<< "${stat}"
    line+=${arr[1]},

    # Tainted Loads
    stat=${file_lines[2]}
    IFS=' ' read -r -a arr <<< "${stat}"
    line+=${arr[1]},

    # Loads Committed
    stat=${file_lines[3]}
    IFS=' ' read -r -a arr <<< "${stat}"
    line+=${arr[1]},

    # Simulated microops
    stat=${file_lines[4]}
    IFS=' ' read -r -a arr <<< "${stat}"
    line+=${arr[1]}

    echo -e $line >> $final_stats

    cd $curDIR
done
