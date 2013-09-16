#!/bin/bash

if [ "$XTPE_LINK_TYPE" != "dynamic" ]
then
  echo "ERROR: You forgot export XTPE_LINK_TYPE=dynamic, I'll set it for you."
  export XTPE_LINK_TYPE=dynamic
fi

COMP=/opt/gcc/4.8.0/bin/
MPT=/opt/cray/mpt/6.0.0/gni/mpich2-gnu/48/
XPMEM=/opt/cray/xpmem/0.1-2.0500.41356.1.11.ari/
DMAP=/opt/cray/dmapp/6.0.1-1.0500.7263.9.31.ari/
UGNI=/opt/cray/ugni/5.0-1.0500.0.3.306.ari/
UDREG=/opt/cray/udreg/2.3.2-1.0500.6756.2.10.ari/
PMI=/opt/cray/pmi/4.0.1-1.0000.9725.84.2.ari/
RCA=/opt/cray/rca/1.0.0-2.0500.41336.1.120.ari/
SMA=/opt/cray/mpt/6.0.0/gni/sma/
ALPS=/opt/cray/alps/5.0.3-2.0500.8213.1.1.ari/
APRUN=/usr/common/usg/altd/1.0/
MESA=/usr/common/graphics/mesa/9.2.0/
PYTHON=/usr/common/usg/python/2.7.3/

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
    -DBUILD_SHARED_LIBS=ON \
    -DPARAVIEW_ENABLE_PYTHON=ON \
    -DPYTHON_EXECUTABLE=$PYTHON/bin/python \
    -DPYTHON_INCLUDE_DIR=$PYTHON/include/python2.7 \
    -DPYTHON_LIBRARY=$PYTHON/lib/libpython2.7.so \
    -DPYTHON_UTIL_LIBRARY=/usr/lib64/libutil.so \
    -DBUILD_TESTING=ON \
    -DVTK_DATA_ROOT=../VTKData \
    -DPARAVIEW_DATA_ROOT=../ParaViewData \
    -DPARAVIEW_BUILD_QT_GUI=OFF \
    -DVTK_USE_X=OFF \
    -DVTK_OPENGL_HAS_OSMESA=ON \
    -DOPENGL_INCLUDE_DIR=$MESA/include \
    -DOPENGL_gl_LIBRARY=$MESA/lib/libOSMesa.so \
    -DOPENGL_glu_LIBRARY=$MESA/lib/libOSMesa.so \
    -DOPENGL_xmesa_INCLUDE_DIR=$MESA/include \
    -DOSMESA_INCLUDE_DIR=$MESA/include \
    -DOSMESA_LIBRARY=$MESA/lib/libOSMesa.so \
    -DPARAVIEW_USE_MPI=ON \
    -DMPI_CXX_COMPILER=$COMP/g++ \
    -DMPI_C_COMPILER=$COMP/gcc \
    -DMPI_LIBRARY=$MPT/lib/libmpich_gnu_48.so\
    -DMPI_EXTRA_LIBRARY=$MPT/lib/libmpichcxx_gnu_48.so\;$MPT/lib/libmpl.so\;/usr/lib64/librt.so\;$SMA/lib64/libsma.so\;$XPMEM/lib64/libxpmem.so\;$DMAP/lib64/libdmapp.so\;$UGNI/lib64/libugni.so\;$PMI/lib64/libpmi.so\;$RCA/lib64/librca.so\;$ALPS/lib64/libalpslli.so\;$ALPS/lib64/libalpsutil.so\;$UDREG/lib64/libudreg.so\;/usr/lib64/libpthread.so\; \
    -DMPI_INCLUDE_PATH=$MPT/include \
    -DMPIEXEC=$APRUN/bin/aprun \
    -DPARAVIEW_USE_VISITBRIDGE=ON \
    -DVISIT_BUILD_READER_CGNS=OFF \
    -DVISIT_BUILD_READER_Silo=OFF \
    -DPARAVIEW_INSTALL_DEVELOPMENT=OFF \
    $*
