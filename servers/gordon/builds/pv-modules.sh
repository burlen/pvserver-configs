#!/bin/bash

module unload intel/2011
module load gnu/4.6.1
module load python/2.7.3
# broken
#module load mvapich2_ib/1.8a1p1
module load openmpi_ib/1.4.1

prefix=/oasis/projects/nsf/gue998/bloring/installs

CMAKE=$prefix/cmake/2.8.11/
PV=$prefix/ParaView/4.0.0
MESA=$prefix/mesa/9.2.0/lib/
GCC=/opt/gnu/gcc/4.6.1

# my install of mpich 3.0.4
#MPICH=$prefix/installs/mpich/3.0.4/
#export PATH=$PV/bin:$MPICH/bin:$CMAKE/bin:$PATH
#export LD_LIBRARY_PATH=$PV/lib/paraview-4.0/:$MPICH/lib:$MESA/lib:$GCC/lib64/:$LD_LIBRARY_PATH

export PATH=$PV/bin:$CMAKE/bin:$PATH
export LD_LIBRARY_PATH=$PV/lib/paraview-4.0/:$MESA/lib:$GCC/lib64/:$LD_LIBRARY_PATH
