#!/bin/bash

COMP=/opt/gcc/4.7.2/bin/
MPT=/opt/cray/mpt/5.6.1/gni/
MPI2=$MPT/mpich2-gnu/47/
XPMEM=/opt/cray/xpmem/0.1-2.0500.39645.2.7.ari/
DMAP=/opt/cray/dmapp/5.0.1-1.0500.6257.4.208.ari/
UGNI=/opt/cray/ugni/5.0-1.0500.6415.7.120.ari/
ALPS=/opt/cray/alps/5.0.2-2.0500.7827.1.1.ari/
APRUN=/usr/common/usg/altd/1.0/
MESA=/usr/common/graphics/mesa/9.2.0
PYTHON=/usr/common/usg/python/2.7.3/
PMI=/opt/cray/pmi/4.0.1-1.0000.9421.73.3.ari/
UDREG=/opt/cray/udreg/2.3.2-1.0500.6003.1.18.ari/

# -DOPENGL_glu_LIBRARY=$MESA/lib/libGLU.so \
# -DCMAKE_CXX_FLAGS=-Wall -Wextra \
# -DVTK_DEBUG_LEAKS=ON \
cmake \
  -DCMAKE_C_COMPILER=$COMP/gcc \
  -DCMAKE_CXX_COMPILER=$COMP/g++ \
  -DCMAKE_EXE_LINKER=$COMP/g++ \
  -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_SHARED_LIBS=ON \
  -DVTK_WRAP_PYTHON=ON \
  -DPYTHON_EXECUTABLE=$PYTHON/bin/python \
  -DPYTHON_INCLUDE_DIR=$PYTHON/include/python2.7 \
  -DPYTHON_LIBRARY=$PYTHON/lib/libpython2.7.so \
  -DPYTHON_UTIL_LIBRARY=/usr/lib64/libutil.so \
  -DBUILD_TESTING=ON \
  -DVTK_DATA_ROOT=../VTKData \
  -DVTK_USE_BOOST=ON \
  -DVTK_USE_PYTHON=ON \
  -DVTK_USE_X=OFF \
  -DVTK_OPENGL_HAS_OSMESA=ON \
  -DOPENGL_INCLUDE_DIR=$MESA/include \
  -DOPENGL_gl_LIBRARY=$MESA/lib/libOSMesa.so \
  -DOPENGL_glu_LIBRARY="" \
  -DOPENGL_xmesa_INCLUDE_DIR=$MESA/include \
  -DOSMESA_INCLUDE_DIR=$MESA/include \
  -DOSMESA_LIBRARY=$MESA/lib/libOSMesa.so \
  -DVTK_USE_PARALLEL=ON \
  -DMPI_CXX_COMPILER=$COMP/g++ \
  -DMPI_C_COMPILER=$COMP/gcc \
  -DMPI_LIBRARY=$MPI2/lib/libmpich_gnu_47.so\
  -DMPI_EXTRA_LIBRARY=$MPI2/lib/libmpichcxx_gnu_47.so\;$MPI2/lib/libmpl.so\;/usr/lib64/librt.so\;$MPT/sma/lib64/libsma.so\;$XPMEM/lib64/libxpmem.so\;$DMAP/lib64/libdmapp.so\;$UGNI/lib64/libugni.so\;$PMI/lib64/libpmi.so\;$ALPS/lib64/libalpslli.so\;$ALPS/lib64/libalpsutil.so\;$UDREG/lib64/libudreg.so\;/usr/lib64/libpthread.so\; \
  -DMPI_INCLUDE_PATH=$MPI2/include \
  -DMPIEXEC=$APRUN/bin/aprun \
  $*

nice -n 19 make -j 8 && nice -n 19 make -j 8 install
