
import sys
import re
import glob 
import os


dir = sys.argv[1]
m5out_path = sys.argv[2]

stats_titles = [
    "sim_ticks",
    "system.cpu.numCycles",
    "system.cpu.committedInsts",
    "system.cpu.committedOps",
    "system.cpu.cpi_total",
    "system.cpu.ipc_total",
    "system.cpu.commit.branches",
    "system.cpu.commit.branchMispredicts",
    "system.cpu.branchPred.indirectLookups",
    "system.cpu.branchPred.indirectMisses",
    "system.cpu.branchPredindirectMispredicted",
    "system.cpu.icache.overall_accesses::total",
    "system.cpu.icache.overall_misses::total",
    "system.cpu.icache.overall_miss_rate::total", # Derived from misses/accesses
    "system.cpu.icache.overall_miss_latency::total",
    "system.cpu.dcache.overall_accesses::total",
    "system.cpu.dcache.overall_misses::total",
    "system.cpu.dcache.overall_miss_rate::total", # Derived from misses/accesses
    "system.cpu.dcache.overall_miss_latency::total",
    "system.l2cache.overall_accesses::total",
    "system.l2cache.overall_misses::total",
    "system.l2cache.overall_miss_rate::total",    # Derived from misses/accesses
    "system.l2cache.overall_miss_latency::total", # Also broken down by I$, D$, and prefetcher
    "system.mem_ctrl.bw_total::.cpu.dcache.prefetcher",   # Total bandwidth to/from this memory (bytes/s)
    "system.mem_ctrl.bw_total::total",            # Total bandwidth to/from this memory (bytes/s)
    "system.cpu.dcache.WriteReq_accesses::total",
    "system.cpu.dcache.ReadReq_accesses::total",
    "system.cpu.dcache.overall_avg_miss_latency::total",
    "system.cpu.dcache.replacements"
]



stat_count = len(stats_titles)

if "print" in dir:
# Print heading 
    print("Benchmark,\tRun Name", end='')
    for i in range(stat_count):
        print(",\t{0}".format(stats_titles[i]), end='')
    print("\n", end='')

else:
    # Parse results file
    filePaths = glob.glob(os.path.join(m5out_path,'stats.txt'))
    stats = stats_titles.copy()
    if filePaths:
        # Scan file for stats_titles of interest
        fp = open(filePaths[0], 'r')
        line = fp.readline() # Skip header
        line = fp.readline() # Skip header
        line = fp.readline()
        cont = True
        while line and cont:
            if"Begin Simulation Statistics" in line:
                cont = False
            line = fp.readline()
        
        cont = True
        while line and cont:
            if"Begin Simulation Statistics" in line:
                cont = False
            values = line.split()
            if(len(values)>0):
                stat_title = values[0]
                stat_value = values[1]
                # Save stats_titles of interest 
                if stat_title in stats_titles:
                    idx = stats_titles.index(stat_title)
                    stats[idx] = stat_value
            line = fp.readline()
        fp.close()

    # Print found stats_titles for this benchmark
    print("{0},\t{1}".format(dir, run_name), end='')
    for i in range(stat_count):
        print(",\t{0}".format(stats[i]), end='')
    print("\n", end='')







