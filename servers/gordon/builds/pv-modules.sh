#!/bin/bash

module unload initel/2011
module load gnu/4.6.1
module load python/2.7.3
module load mvapich2_ib/1.8a1p1

MESA=/home/bloring/installs/mesa/9.2.0/lib/
CMAKE=/home/bloring/installs/cmake/2.8.11/
GCC=/opt/gnu/gcc/4.6.1
export PATH=$CMAKE/bin:$PATH
export LD_LIBRARY_PATH=$MESA/lib:$GCC/lib64/:$LD_LIBRARY_PATH

