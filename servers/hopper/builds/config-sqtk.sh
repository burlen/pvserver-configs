#!/bin/bash
 
if [ "$XTPE_LINK_TYPE" != "dynamic" ]
then
  echo "ERROR: You forgot export XTPE_LINK_TYPE=dynamic, I'll set it for you."
  export XTPE_LINK_TYPE=dynamic
fi

HDF5=/opt/cray/hdf5/1.8.7/gnu/46
MPI2=/opt/cray/mpt/5.4.0/xt/gemini/mpich2-gnu/46
MESA=/usr/common/graphics/ParaView/Mesa-7.10.1
PYTHON=/usr/common/usg/python/2.7.1
BOOST=/usr/common/graphics/ParaView/boost_1_46_1
COMP=/opt/gcc/4.6.1/bin

echo
echo "MPI2=$MPI2"
echo "MESA=$MESA"
echo "PYTHON=$PYTHON"
echo "BOOST=$BOOST"
echo "COMP=$COMP"
echo "TOOLCHAIN=$TOOLCHAIN"
echo "NATIVE_BUILD=$NATIVE_BUILD"
echo

cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER=$COMP/gcc \
    -DCMAKE_CXX_COMPILER=$COMP/g++ \
    -DCMAKE_EXE_LINKER=$COMP/g++ \
    -DMPI_CXX_COMPILER=$COMP/g++ \
    -DMPI_C_COMPILER=$COMP/gcc \
    -DMPI_LIBRARY=/opt/cray/mpt/5.4.0/xt/gemini/mpich2-gnu/46/lib/libmpich_gnu.so \
    -DMPI_EXTRA_LIBRARY=/opt/cray/mpt/5.4.0/xt/gemini/mpich2-gnu/46/lib/libmpich_gnu.so\;/opt/cray/mpt/5.4.0/xt/gemini/mpich2-gnu/46/lib/libmpl.so\;/opt/cray/ugni/2.3-1.0400.4127.5.20.gem/lib64/libugni.so\;/opt/cray/pmi/3.0.0-1.0000.8661.28.2807.gem/lib64/libpmi.so\;/opt/cray/udreg/2.3.1-1.0400.3911.5.13.gem/lib64/libudreg.so\;/opt/cray/xpmem/0.1-2.0400.30792.5.6.gem/lib64/libxpmem.so\;/opt/cray/dmapp/3.2.1-1.0400.3965.10.63.gem/lib64/libdmapp.so\;/usr/lib/alps/libalpslli.so\;/usr/lib/alps/libalpsutil.so \
    -DMPI_INCLUDE_PATH=/opt/cray/mpt/5.4.0/xt/gemini/mpich2-gnu/46/include \
    $* 
