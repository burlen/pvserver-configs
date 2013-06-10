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
#COMP=/opt/cray/xt-asyncpe/5.04/bin
 
# don't need a cross compile on MOM nodes
# TOOLCHAIN=/global/homes/l/loring/Hopper/ParaView/hopper_toolchain.cmake 
# NATIVE_BUILD=/global/homes/l/loring/Hopper/ParaView/PV3-3.10.0-so-login
#     -DCMAKE_SYSTEM_NAME=Linux \
#     -DCMAKE_CROSSCOMPILING=TRUE \
#     -DParaView3CompileTools_DIR=$NATIVE_BUILD \


# this didn't work.
#    -DCMAKE_TOOLCHAIN_FILE=$TOOCHAIN \
#



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
    -DCMAKE_INSTALL_PREFIX=/usr/common/graphics/ParaView/3.14.0-mom-so \
    -DBUILD_SHARED_LIBS=ON \
    -DPARAVIEW_ENABLE_PYTHON=ON \
    -DPYTHON_EXECUTABLE=$PYTHON/bin/python \
    -DPYTHON_INCLUDE_DIR=$PYTHON/include/python2.7 \
    -DPYTHON_LIBRARY=$PYTHON/lib/libpython2.7.so \
    -DPYTHON_UTIL_LIBRARY=/usr/lib64/libutil.so \
    -DBUILD_TESTING=OFF \
    -DPARAVIEW_BUILD_QT_GUI=OFF \
    -DVTK_USE_X=OFF \
    -DVTK_OPENGL_HAS_OSMESA=ON \
    -DOPENGL_INCLUDE_DIR=$MESA/include \
    -DOPENGL_gl_LIBRARY="" \
    -DOPENGL_glu_LIBRARY=$MESA/lib/libGLU.so \
    -DOPENGL_xmesa_INCLUDE_DIR=$MESA/include \
    -DOSMESA_INCLUDE_DIR=$MESA/include \
    -DOSMESA_LIBRARY=$MESA/lib/libOSMesa32.so \
    -DPARAVIEW_USE_MPI=ON \
    -DMPI_CXX_COMPILER=$COMP/g++ \
    -DMPI_C_COMPILER=$COMP/gcc \
    -DMPI_LIBRARY=/opt/cray/mpt/5.4.0/xt/gemini/mpich2-gnu/46/lib/libmpich_gnu.so \
    -DMPI_EXTRA_LIBRARY=/opt/cray/mpt/5.4.0/xt/gemini/mpich2-gnu/46/lib/libmpich_gnu.so\;/opt/cray/mpt/5.4.0/xt/gemini/mpich2-gnu/46/lib/libmpl.so\;/opt/cray/ugni/2.3-1.0400.4127.5.20.gem/lib64/libugni.so\;/opt/cray/pmi/3.0.0-1.0000.8661.28.2807.gem/lib64/libpmi.so\;/opt/cray/udreg/2.3.1-1.0400.3911.5.13.gem/lib64/libudreg.so\;/opt/cray/xpmem/0.1-2.0400.30792.5.6.gem/lib64/libxpmem.so\;/opt/cray/dmapp/3.2.1-1.0400.3965.10.63.gem/lib64/libdmapp.so\;/usr/lib/alps/libalpslli.so\;/usr/lib/alps/libalpsutil.so \
    -DMPI_INCLUDE_PATH=/opt/cray/mpt/5.4.0/xt/gemini/mpich2-gnu/46/include \
    -DBOOST_ROOT=$BOOST \
    -DVTK_USE_BOOST=ON \
    -DPARAVIEW_USE_VISITBRIDGE=ON \
    -DVISIT_BUILD_READER_CGNS=OFF \
    -DVISIT_BUILD_READER_Silo=OFF \
    -DPARAVIEW_INSTALL_DEVELOPMENT=OFF \
    $* 

