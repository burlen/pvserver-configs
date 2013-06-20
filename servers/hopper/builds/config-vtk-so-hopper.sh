#!/bin/bash

HDF5=/opt/cray/hdf5/1.8.7/gnu/46
MESA=/usr/common/graphics/mesa/9.2.0/
PYTHON=/usr/common/usg/python/2.7.1
BOOST=/usr/common/graphics/ParaView/boost_1_46_1
COMP=/opt/gcc/4.7.1/bin

MPT=/opt/cray/mpt/5.6.0/gni/mpich2-gnu/47/lib
RCA=/opt/cray/rca/1.0.0-2.0401.38656.2.2.gem/lib64
XPMEM=/opt/cray/xpmem/0.1-2.0401.36790.4.3.gem/lib64
DMAPP=/opt/cray/dmapp/3.2.1-1.0401.5983.4.5.gem/lib64
PMI=/opt/cray/pmi/4.0.0-1.0000.9282.69.4.gem/lib64
UGNI=/opt/cray/ugni/4.0-1.0401.5928.9.5.gem/lib64
UDREG=/opt/cray/udreg/2.3.2-1.0401.5929.3.3.gem/lib64
SCI=/opt/cray/libsci/12.0.00/GNU/47/mc12/lib
SMA=/opt/cray/mpt/5.6.0/gni/sma/lib64
SMA64=/opt/cray/mpt/5.6.0/gni/sma64/lib64
ALPS=/usr/lib/alps

echo
echo "MPT=$MPT"
echo "MESA=$MESA"
echo "PYTHON=$PYTHON"
echo "BOOST=$BOOST"
echo "COMP=$COMP"
echo "TOOLCHAIN=$TOOLCHAIN"
echo "NATIVE_BUILD=$NATIVE_BUILD"
echo

cmake \
    -DCMAKE_C_COMPILER=$COMP/gcc \
    -DCMAKE_CXX_COMPILER=$COMP/g++ \
    -DCMAKE_EXE_LINKER=$COMP/g++ \
    -DBUILD_TESTING=ON \
    -DVTK_DATA_ROOT=../VTKData \
    -DBUILD_SHARED_LIBS=ON \
    -DVTK_WRAP_PYTHON=ON \
    -DPYTHON_EXECUTABLE=$PYTHON/bin/python \
    -DPYTHON_INCLUDE_DIR=$PYTHON/include/python2.7 \
    -DPYTHON_LIBRARY=$PYTHON/lib/libpython2.7.so \
    -DPYTHON_UTIL_LIBRARY=/usr/lib64/libutil.so \
    -DBUILD_TESTING=OFF \
    -DVTK_USE_X=OFF \
    -DVTK_OPENGL_HAS_OSMESA=ON \
    -DOPENGL_INCLUDE_DIR=$MESA/include \
    -DOPENGL_gl_LIBRARY=$MESA/lib/libOSMesa32.so \
    -DOPENGL_glu_LIBRARY="" \
    -DOPENGL_xmesa_INCLUDE_DIR=$MESA/include \
    -DOSMESA_INCLUDE_DIR=$MESA/include \
    -DOSMESA_LIBRARY=$MESA/lib/libOSMesa32.so \
    -DBOOST_ROOT=$BOOST \
    -DVTK_USE_BOOST=ON \
    $*
