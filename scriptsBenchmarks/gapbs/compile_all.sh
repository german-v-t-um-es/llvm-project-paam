#!/bin/bash

# Define the list of benchmarks you want to compile
BENCHMARKS_TO_COMPILE=(
    bc
    bfs
    cc
    cc_sv
    pr
    pr_spmv
    sssp
    tc
)

compile_benchmark() {
    case "$1" in

    bc)
    ../../../paamBuild/bin/clang++ -S -emit-llvm -O3 -fopenmp -I/usr/lib/gcc/x86_64-linux-gnu/13/include bc.cc -o bc.ll
    if [ $? -eq 0 ]; then
        echo "bc compiled successfully."
    else
        echo "Failed to compile bc."
    fi
    ;;

    bfs)
    ../../../paamBuild/bin/clang++ -S -emit-llvm -O3 -fopenmp -I/usr/lib/gcc/x86_64-linux-gnu/13/include bfs.cc -o bfs.ll
    if [ $? -eq 0 ]; then
        echo "bfs compiled successfully."
    else
        echo "Failed to compile bfs."
    fi
    ;;

    cc)
    ../../../paamBuild/bin/clang++ -S -emit-llvm -O3 -fopenmp -I/usr/lib/gcc/x86_64-linux-gnu/13/include cc.cc -o cc.ll
    if [ $? -eq 0 ]; then
        echo "cc compiled successfully."
    else
        echo "Failed to compile cc."
    fi
    ;;

    cc_sv)
    ../../../paamBuild/bin/clang++ -S -emit-llvm -O3 -fopenmp -I/usr/lib/gcc/x86_64-linux-gnu/13/include cc_sv.cc -o cc_sv.ll
    if [ $? -eq 0 ]; then
        echo "cc_sv compiled successfully."
    else
        echo "Failed to compile cc_sv."
    fi
    ;;

    pr)
    ../../../paamBuild/bin/clang++ -S -emit-llvm -O3 -fopenmp -I/usr/lib/gcc/x86_64-linux-gnu/13/include pr.cc -o pr.ll
    if [ $? -eq 0 ]; then
        echo "pr compiled successfully."
    else
        echo "Failed to compile pr."
    fi
    ;;

    pr_spmv)
    ../../../paamBuild/bin/clang++ -S -emit-llvm -O3 -fopenmp -I/usr/lib/gcc/x86_64-linux-gnu/13/include pr_spmv.cc -o pr_spmv.ll
    if [ $? -eq 0 ]; then
        echo "pr_spmv compiled successfully."
    else
        echo "Failed to compile pr_spmv."
    fi
    ;;

    sssp)
    ../../../paamBuild/bin/clang++ -S -emit-llvm -O3 -fopenmp -I/usr/lib/gcc/x86_64-linux-gnu/13/include sssp.cc -o sssp.ll
    if [ $? -eq 0 ]; then
        echo "sssp compiled successfully."
    else
        echo "Failed to compile sssp."
    fi
    ;;

    tc)
    ../../../paamBuild/bin/clang++ -S -emit-llvm -O3 -fopenmp -I/usr/lib/gcc/x86_64-linux-gnu/13/include tc.cc -o tc.ll
    if [ $? -eq 0 ]; then
        echo "tc compiled successfully."
    else
        echo "Failed to compile tc."
    fi
    ;;


    *)
        echo "Benchmark $1 not recognized or not supported."
        ;;
    esac
}

# Run compilation only for selected benchmarks
cd src
find . -name "*.ll" -type f -delete
for bench in "${BENCHMARKS_TO_COMPILE[@]}"; do
    compile_benchmark "$bench"
done
