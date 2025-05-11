#!/bin/bash

# Define the list of benchmarks you want to compile
BENCHMARKS_TO_COMPILE=(
    bfs
    hotspot
    myocyte
    nw
    pathfinder
    streamcluster
)

compile_benchmark() {
    case "$1" in
    btree)
    cd b+tree
    ../../../../paamBuild/bin/clang -S -emit-llvm -O3 -fopenmp -I/usr/lib/gcc/x86_64-linux-gnu/13/include main.c -o b++tree.ll
    if [ $? -eq 0 ]; then
        echo "b+tree compiled successfully."
    else
        echo "Failed to compile b+tree."
    fi
    cd ..
    ;;

    backprop)
    cd backprop
    ../../../../paamBuild/bin/clang++ -S -emit-llvm -O3 -fopenmp -I/usr/lib/gcc/x86_64-linux-gnu/13/include backprop.cpp -o backprop.ll
    if [ $? -eq 0 ]; then
        echo "backprop compiled successfully."
    else
        echo "Failed to compile backprop."
    fi
    cd ..
    ;;

    bfs)
    cd bfs
    ../../../../paamBuild/bin/clang++ -S -emit-llvm -O3 -fopenmp -I/usr/lib/gcc/x86_64-linux-gnu/13/include bfs.cpp -o bfs.ll
    if [ $? -eq 0 ]; then
        echo "bfs compiled successfully."
    else
        echo "Failed to compile bfs."
    fi
    cd ..
    ;;

    cfd)
    cd cfd
    ../../../../paamBuild/bin/clang++ -S -emit-llvm -O3 -fopenmp -I/usr/lib/gcc/x86_64-linux-gnu/13/include euler3d_cpu.cpp -o euler3d_cpu.ll
    if [ $? -eq 0 ]; then
        echo "bfs compiled successfully."
    else
        echo "Failed to compile bfs."
    fi
    cd ..
    ;;

    heartwall)
    cd heartwall
    ../../../../paamBuild/bin/clang++ -S -emit-llvm -O3 -fopenmp -I/usr/lib/gcc/x86_64-linux-gnu/13/include main.c -o heartwall.ll
    if [ $? -eq 0 ]; then
        echo "bfs compiled successfully."
    else
        echo "Failed to compile bfs."
    fi
    cd ..
    ;;

    hotspot)
    cd hotspot
    ../../../../paamBuild/bin/clang++ -S -emit-llvm -O3 -fopenmp -I/usr/lib/gcc/x86_64-linux-gnu/13/include hotspot_openmp.cpp -o hotspot.ll
    if [ $? -eq 0 ]; then
        echo "hotspot compiled successfully."
    else
        echo "Failed to compile hotspot."
    fi
    cd ..
    ;;

    hotspot3D)
    cd hotspot3D
    ../../../../paamBuild/bin/clang++ -S -emit-llvm -O3 -fopenmp -I/usr/lib/gcc/x86_64-linux-gnu/13/include 3D.cpp -o hotspot3D.ll
    if [ $? -eq 0 ]; then
        echo "hotspot3D compiled successfully."
    else
        echo "Failed to compile hotspot3D."
    fi
    cd ..
    ;;

    kmeans)
    cd kmeans/kmeans_openmp
    ../../../../paamBuild/bin/clang++ -S -emit-llvm -O3 -fopenmp -I/usr/lib/gcc/x86_64-linux-gnu/13/include kmeans.c -o kmeans.ll
    if [ $? -eq 0 ]; then
        echo "kmeans compiled successfully."
    else
        echo "Failed to compile kmeans."
    fi
    cd ../..
    ;;

    lavaMD)
    cd lavaMD
    ../../../../paamBuild/bin/clang++ -S -emit-llvm -O3 -fopenmp -I/usr/lib/gcc/x86_64-linux-gnu/13/include main.c -o lavaMD.ll
    if [ $? -eq 0 ]; then
        echo "lavaMD compiled successfully."
    else
        echo "Failed to compile lavaMD."
    fi
    cd ..
    ;;

    leukocyte)
    cd leukocyte
    ../../../../paamBuild/bin/clang++ -S -emit-llvm -O3 -fopenmp -I/usr/lib/gcc/x86_64-linux-gnu/13/include leukocyte.c -o leukocyte.ll
    if [ $? -eq 0 ]; then
        echo "leukocyte compiled successfully."
    else
        echo "Failed to compile leukocyte."
    fi
    cd ..
    ;;

    lud)
    cd lud
    ../../../../paamBuild/bin/clang++ -S -emit-llvm -O3 -fopenmp -I/usr/lib/gcc/x86_64-linux-gnu/13/include lud.cpp -o lud.ll
    if [ $? -eq 0 ]; then
        echo "lud compiled successfully."
    else
        echo "Failed to compile lud."
    fi
    cd ..
    ;;

    mummergpu)
    cd mummergpu
    ../../../../paamBuild/bin/clang++ -S -emit-llvm -O3 -fopenmp -I/usr/lib/gcc/x86_64-linux-gnu/13/include mummergpu.cpp -o mummergpu.ll
    if [ $? -eq 0 ]; then
        echo "mummergpu compiled successfully."
    else
        echo "Failed to compile mummergpu."
    fi
    cd ..
    ;;

    myocyte)
    cd myocyte
    ../../../../paamBuild/bin/clang++ -S -emit-llvm -O3 -fopenmp -I/usr/lib/gcc/x86_64-linux-gnu/13/include main.c -o myocyte.ll
    if [ $? -eq 0 ]; then
        echo "myocyte compiled successfully."
    else
        echo "Failed to compile myocyte."
    fi
    cd ..
    ;;

    nn)
    cd nn
    ../../../../paamBuild/bin/clang++ -S -emit-llvm -O3 -fopenmp -I/usr/lib/gcc/x86_64-linux-gnu/13/include nn_openmp.cpp -o nn.ll
    if [ $? -eq 0 ]; then
        echo "nn compiled successfully."
    else
        echo "Failed to compile nn."
    fi
    cd ..
    ;;

    nw)
    cd nw
    ../../../../paamBuild/bin/clang++ -S -emit-llvm -O3 -fopenmp -I/usr/lib/gcc/x86_64-linux-gnu/13/include needle.cpp -o nw.ll
    if [ $? -eq 0 ]; then
        echo "nw compiled successfully."
    else
        echo "Failed to compile nw."
    fi
    cd ..
    ;;

    particlefilter)
    cd particlefilter
    ../../../../paamBuild/bin/clang++ -S -emit-llvm -O3 -fopenmp -I/usr/lib/gcc/x86_64-linux-gnu/13/include ex_particle_OPENMP_seq.cpp -o particlefilter.ll
    if [ $? -eq 0 ]; then
        echo "particlefilter compiled successfully."
    else
        echo "Failed to compile particlefilter."
    fi
    cd ..
    ;;

    pathfinder)
    cd pathfinder
    ../../../../paamBuild/bin/clang++ -S -emit-llvm -O3 -fopenmp -I/usr/lib/gcc/x86_64-linux-gnu/13/include pathfinder.cpp -o pathfinder.ll
    if [ $? -eq 0 ]; then
        echo "pathfinder compiled successfully."
    else
        echo "Failed to compile pathfinder."
    fi
    cd ..
    ;;

    srad)
    cd srad/srad_v1
    ../../../../paamBuild/bin/clang++ -S -emit-llvm -O3 -fopenmp -I/usr/lib/gcc/x86_64-linux-gnu/13/include main.c -o srad.ll
    if [ $? -eq 0 ]; then
        echo "srad compiled successfully."
    else
        echo "Failed to compile srad."
    fi
    cd ../..
    ;;

    streamcluster)
    cd streamcluster
    ../../../../paamBuild/bin/clang++ -S -emit-llvm -O3 -fopenmp -I/usr/lib/gcc/x86_64-linux-gnu/13/include streamcluster_omp.cpp -o streamcluster.ll
    if [ $? -eq 0 ]; then
        echo "streamcluster compiled successfully."
    else
        echo "Failed to compile streamcluster."
    fi
    cd ..
    ;;

    gaussian)
    cd gaussian
    ../../../../paamBuild/bin/clang++ -S -emit-llvm -O3 -fopenmp -I/usr/lib/gcc/x86_64-linux-gnu/13/include gaussian.cpp -o gaussian.ll
    if [ $? -eq 0 ]; then
        echo "gaussian compiled successfully."
    else
        echo "Failed to compile gaussian."
    fi
    cd ..
    ;;

    *)
        echo "Benchmark $1 not recognized or not supported."
        ;;
    esac
}

# Run compilation only for selected benchmarks
find . -name "*.ll" -type f -delete
for bench in "${BENCHMARKS_TO_COMPILE[@]}"; do
    compile_benchmark "$bench"
done
