#!/bin/bash
 
if [ "$XTPE_LINK_TYPE" != "dynamic" ]
then
  echo "ERROR: You forgot export XTPE_LINK_TYPE=dynamic, I'll set it for you."
  export XTPE_LINK_TYPE=dynamic
fi

HDF5=/opt/cray/hdf5/1.8.7/gnu/46
MPI2=/opt/cray/mpt/5.5.2/gni/mpich2-gnu/47
MESA=/usr/common/graphics/ParaView/Mesa-7.10.1
PYTHON=/usr/common/usg/python/2.7.1
BOOST=/usr/common/graphics/ParaView/boost_1_46_1
COMP=/opt/gcc/4.7.1/bin

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
    -DCMAKE_INSTALL_PREFIX=/usr/common/graphics/ParaView/3.98-mom-so \
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
    -DOPENGL_gl_LIBRARY=$MESA/lib/libOSMesa32.so \
    -DOPENGL_glu_LIBRARY=$MESA/lib/libGLU.so \
    -DOPENGL_xmesa_INCLUDE_DIR=$MESA/include \
    -DOSMESA_INCLUDE_DIR=$MESA/include \
    -DOSMESA_LIBRARY=$MESA/lib/libOSMesa32.so \
    -DPARAVIEW_USE_MPI=ON \
    -DMPI_CXX_COMPILER=$COMP/g++ \
    -DMPI_C_COMPILER=$COMP/gcc \
    -DMPI_LIBRARY=$MPI2/lib/libmpich_gnu_47.so\
    -DMPI_EXTRA_LIBRARY=$MPI2/lib/libmpichcxx_gnu_47.so\;$MPI2/lib/libmpl.so\;/usr/lib64/librt.so\;/opt/cray/mpt/5.5.2/gni/sma/lib64/libsma.so\;/opt/cray/xpmem/0.1-2.0400.31280.3.1.gem/lib64/libxpmem.so\;/opt/cray/dmapp/3.2.1-1.0400.4255.2.159.gem/lib64/libdmapp.so\;/opt/cray/ugni/2.3-1.0400.4374.4.88.gem/lib64/libugni.so\;/opt/cray/pmi/3.0.1-1.0000.9101.2.26.gem/lib64/libpmi.so\;/usr/lib/alps/libalpslli.so\;/usr/lib/alps/libalpsutil.so\;/opt/cray/udreg/2.3.1-1.0400.4264.3.1.gem/lib64/libudreg.so\;/usr/lib64/libpthread.so\; \
    -DMPI_INCLUDE_PATH=$MPI2/include \
    -DMPIEXEC=/usr/common/usg/altd/1.0/bin/aprun \
    -DBOOST_ROOT=$BOOST \
    -DVTK_USE_BOOST=ON \
    -DPARAVIEW_USE_VISITBRIDGE=ON \
    -DVISIT_BUILD_READER_CGNS=OFF \
    -DVISIT_BUILD_READER_Silo=OFF \
    -DPARAVIEW_INSTALL_DEVELOPMENT=OFF \
    $* 
