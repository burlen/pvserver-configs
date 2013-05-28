#!/bin/bash
 
# if [ "$XTPE_LINK_TYPE" != "dynamic" ]
# then
#   echo "ERROR: You forgot export XTPE_LINK_TYPE=dynamic, I'll set it for you."
#   export XTPE_LINK_TYPE=dynamic
# fi

HDF5=/opt/cray/hdf5/1.8.7/gnu/46
MPI2=/opt/cray/mpt/5.4.0/xt/gemini/mpich2-gnu/46
MESA=/usr/common/graphics/ParaView/3.14.0-mom
PYTHON=/usr/common/graphics/ParaView/3.14.0-mom
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


#    -DPARAVIEW_ENABLE_PYTHON=OFF \
#    -DPYTHON_EXECUTABLE=$PYTHON/bin/python \
#    -DPYTHON_INCLUDE_DIR=$PYTHON/include/python2.7 \
#    -DPYTHON_LIBRARY=$PYTHON/lib/libpython2.7.a \
#    -DPYTHON_UTIL_LIBRARY=/usr/lib64/libutil.a \

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
    -DCMAKE_BUILD_TYPE=Debug \
    -DCMAKE_C_COMPILER=$COMP/gcc \
    -DCMAKE_CXX_COMPILER=$COMP/g++ \
    -DCMAKE_EXE_LINKER=$COMP/g++ \
    -DCMAKE_C_FLAGS=-static -Wl,-Bstatic \
    -DCMAKE_CXX_FLAGS=-static -Wl,-Bstatic \
    -DCMAKE_EXE_LINKER_FLAGS=-Bstatic \
    -DCMAKE_MODULE_LINKER_FLAGS=-Bstatic \
    -DCMAKE_SHARED_LINKER_FLAGS=-Bdynamic \
    -DCMAKE_INSTALL_PREFIX=/usr/common/graphics/ParaView/3.14.0-mom \
    -DBUILD_SHARED_LIBS=OFF \
    -DBUILD_TESTING=OFF \
    -DPARAVIEW_BUILD_QT_GUI=OFF \
    -DVTK_USE_X=OFF \
    -DVTK_OPENGL_HAS_OSMESA=ON \
    -DOPENGL_INCLUDE_DIR=$MESA/include \
    -DOPENGL_gl_LIBRARY="" \
    -DOPENGL_glu_LIBRARY=$MESA/lib/libGLU.a \
    -DOPENGL_xmesa_INCLUDE_DIR=$MESA/include \
    -DOSMESA_INCLUDE_DIR=$MESA/include \
    -DOSMESA_LIBRARY=$MESA/lib/libOSMesa32.a \
    -DPARAVIEW_USE_MPI=ON \
    -DMPI_CXX_COMPILER=/opt/gcc/4.6.1/bin/g++ \
    -DMPI_C_COMPILER=/opt/gcc/4.6.1/bin/gcc \
    -DMPI_LIBRARY=m \
    -DMPI_EXTRA_LIBRARY=m\;-Wl,--start-group\;/opt/cray/mpt/5.4.0/xt/gemini/mpich2-gnu/46/lib/libmpich_gnu.a\;/opt/cray/mpt/5.4.0/xt/gemini/mpich2-gnu/46/lib/libmpl.a\;/opt/cray/ugni/2.3-1.0400.4127.5.20.gem/lib64/libugni.a\;/opt/cray/pmi/3.0.0-1.0000.8661.28.2807.gem/lib64/libpmi.a\;/opt/cray/udreg/2.3.1-1.0400.3911.5.13.gem/lib64/libudreg.a\;/opt/cray/xpmem/0.1-2.0400.30792.5.6.gem/lib64/libxpmem.a\;/opt/cray/dmapp/3.2.1-1.0400.3965.10.63.gem/lib64/libdmapp.a\;/usr/lib/alps/libalpslli.a\;/usr/lib/alps/libalpsutil.a\;/opt/cray/atp/1.4.1/lib/libAtpSigHandler.a\;-Wl,--end-group \
    -DMPI_INCLUDE_PATH=/opt/cray/mpt/5.4.0/xt/gemini/mpich2-gnu/46/include \
    -DBOOST_ROOT=$BOOST \
    -DVTK_USE_BOOST=ON \
    -DPARAVIEW_BUILD_PLUGIN=EyeDomeLighting \
    -DPARAVIEW_USE_VISITBRIDGE=ON \
    -DVISIT_BUILD_READER_CGNS=OFF \
    -DVISIT_BUILD_READER_Silo=OFF \
    -DPARAVIEW_INSTALL_DEVELOPMENT=OFF \
    $* 

