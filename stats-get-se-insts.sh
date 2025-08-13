#!/bin/bash
# Command: ./stats-get-se-insts.sh m5out-enc-3 se
source paths.sh

curDIR=$PWD

mkdir -p csv

benchmark_stat_file=results/$1*stats.txt
filtered_stats=results/m5out_filtered_stats.out
final_stats=$PWD/csv/stats_all_$2.csv
se_alu_stats=$PWD/csv/stats_alu_$2.csv

for dir in $BENCHMARK_DIRS; do
    cd $BENCHMARK_HOME_DIR/$dir

    echo $dir > $filtered_stats

    # Committed Instructions
    grep -rh 'cpu.committedInsts' $benchmark_stat_file >> $filtered_stats

    # Tainted Instructions
    grep -rh 'cpu.commit.committedInstsTainted' $benchmark_stat_file >> $filtered_stats

    # Loads committed
    grep -rh 'cpu.commit.loads' $benchmark_stat_file >> $filtered_stats

    # Simulated microops (same as op_class_0::total)
    grep -rh 'sim_ops' $benchmark_stat_file >> $filtered_stats

    # Simulated SE ALU microops
    grep -rh 'op_class_0::Enc' $benchmark_stat_file | grep -v 'op_class_0::Encrypt' >> $filtered_stats

    # Simulated SE Encryptions
    grep -rh 'op_class_0::Encrypt' $benchmark_stat_file >> $filtered_stats

    # Simulated SE Decryptions
    grep -rh 'op_class_0::Dec' $benchmark_stat_file >> $filtered_stats

    cd $curDIR
done


touch $final_stats
echo -e "Benchmarks,Committed Insts,Committed Insts Tainted,Committed Loads,Simulated Total Ops,Simulated SE ALU Operations,Simulated SE Encryptions,Simulated SE Decryptions" > $final_stats

echo -e "Benchmarks,EncIntAlu,EncIntDiv,EncIntMult,EncFPALU,EncFloatMult,EncFloatMultAcc,EncFloatDiv,EncFloatMisc,EncFloatSqrt,EncSIMDInst" > $se_alu_stats

for dir in $BENCHMARK_DIRS; do
    cd $BENCHMARK_HOME_DIR/$dir

    file_lines=()
    
    while read line; do
        # Process the line here
        file_lines+=("$line")
    done < $filtered_stats

    # Benchmark Name
    line=${file_lines[0]}, 

    # Committed Instructions
    stat=${file_lines[1]}
    IFS=' ' read -r -a arr <<< "${stat}"
    line+=${arr[1]},

    # Tainted Instructions
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
    line+=${arr[1]},

    # Simulated SE ALU microops
    sum=0
    alu=
    for i in {5..41}
    do
        stat=${file_lines[i]}
        IFS=' ' read -r -a arr <<< "${stat}"
        count=${arr[1]}
        sum=$((sum + count))
    done
    line+=${sum},

    # Simulated SE Encryptions
    sum=0
    for i in {42..82}
    do
        stat=${file_lines[i]}
        IFS=' ' read -r -a arr <<< "${stat}"
        count=${arr[1]}
        sum=$((sum + count))
    done
    line+=${sum},

    # Simulated SE Decryptions
    sum=0
    for i in {83..84}
    do
        stat=${file_lines[i]}
        IFS=' ' read -r -a arr <<< "${stat}"
        count=${arr[1]}
        sum=$((sum + count))
    done
    line+=${sum}

    echo -e $line >> $final_stats

    # Benchmark Name
    line=${file_lines[0]}, 

    # EncIntALU
    alu=0
    stat=${file_lines[5]}
    IFS=' ' read -r -a arr <<< "${stat}"
    count=${arr[1]}
    alu=$count
    line+=${alu},

    # EncIntDiv
    alu=0
    stat=${file_lines[7]}
    IFS=' ' read -r -a arr <<< "${stat}"
    count=${arr[1]}
    alu=$count
    line+=${alu},

    # EncIntMult
    stat=${file_lines[6]}
    IFS=' ' read -r -a arr <<< "${stat}"
    line+=${arr[1]},

    # EncFPALU
    alu=0
    for i in {8..10}
    do
        stat=${file_lines[i]}
        IFS=' ' read -r -a arr <<< "${stat}"
        count=${arr[1]}
        alu=$((alu + count))
    done
    line+=${alu},

    # EncFloatMult, EncFloatMultAcc, EncFloatDiv, EncFloatMisc, EncFloatSqrt 
    for i in {11..15}
    do
        stat=${file_lines[i]}
        IFS=' ' read -r -a arr <<< "${stat}"
        line+=${arr[1]},
    done

    # EncSIMDInst
    alu=0
    for i in {16..41}
    do
        stat=${file_lines[i]}
        IFS=' ' read -r -a arr <<< "${stat}"
        count=${arr[1]}
        alu=$((alu + count))
    done
    line+=${alu}

    echo -e $line >> $se_alu_stats

    cd $curDIR
done
