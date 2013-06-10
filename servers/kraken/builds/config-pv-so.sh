#!/bin/bash

# export XTPE_LINK_TYPE=dynamic
BUILD_TYPE=Release
COMP=/opt/gcc/4.6.2/snos/
BOOST_PATH=/lustre/scratch/proj/sw/paraview/shared-dependencies/
MESA_PATH=/lustre/scratch/proj/sw/paraview/shared-dependencies/
PY_ROOT=/lustre/scratch/proj/sw/python-cnl/2.7.1/cnl3.1_gnu4.6.2
PY_EXEC=$PY_ROOT/bin/python
PY_INCL=$PY_ROOT/include/python2.7
PY_LIB=$PY_ROOT/lib/libpython2.7.so
PORTALS=/opt/cray/portals/2.2.0-1.0301.26633.6.9.ss/lib64
PMI=/opt/cray/pmi/2.1.4-1.0000.8596.15.1.ss/lib64
ISTAMBUL=/opt/xt-libsci/11.0.04/gnu/46/istanbul/lib
ALPS=/usr/lib/alps
MPI_PATH=/opt/cray/mpt/5.3.5/xt/seastar/mpich2-gnu/46/
MPT=$MPI_PATH/lib/

echo "PY_ROOT=$PY_ROOT"
echo "PY_EXEC=$PY_EXEC"
echo "PY_INCL=$PY_INCL"
echo "PY_LIB=$PY_LIB"
echo "MPI_PATH=$MPI_PATH"
echo "COMP=$COMP"
echo "MESA_PATH=$MESA_PATH"

cmake \
  -DCMAKE_C_COMPILER=$COMP/bin/gcc \
  -DCMAKE_CXX_COMPILER=$COMP/bin/g++ \
  -DBUILD_TESTING=OFF \
  -DBUILD_SHARED_LIBS=ON \
  -DCMAKE_BUILD_TYPE=$BUILD_TYPE \
  -DPARAVIEW_ENABLE_PYTHON=ON \
  -DPYTHON_EXECUTABLE=$PY_EXEC \
  -DPYTHON_INCLUDE_DIR=$PY_INCL\
  -DPYTHON_LIBRARY=$PY_LIB \
  -DPYTHON_EXTRA_LIBS=z\;pthread\;dl \
  -DPARAVIEW_INSTALL_DEVELOPMENT=OFF \
  -DPARAVIEW_USE_MPI=ON \
  -DMPI_INCLUDE_PATH=$MPI_PATH/include \
  -DMPI_C_LIBRARY=$MPI_PATH/lib/libmpich.so \
  -DMPI_CXX_LIBRARIES=$MPT/libmpichcxx_gnu.so\;$MPT/libmpich_gnu.so\;$PMI/libpmi.so\;$MPT/libmpl.so\;/usr/lib64/librt.so\;/usr/lib64/libpthread.so \
  -DPARAVIEW_BUILD_QT_GUI=OFF \
  -DVTK_USE_X=OFF \
  -DVTK_OPENGL_HAS_OSMESA=ON \
  -DOPENGL_INCLUDE_DIR=$MESA_PATH/include \
  -DOPENGL_gl_LIBRARY="" \
  -DOPENGL_glu_LIBRARY=$MESA_PATH/lib/libGLU.so \
  -DOPENGL_xmesa_INCLUDE_DIR=$MESA_PATH/include \
  -DOSMESA_INCLUDE_DIR=$MESA_PATH/include \
  -DOSMESA_LIBRARY=$MESA_PATH/lib/libOSMesa32.so \
  -DVTK_USE_BOOST=ON \
  -DBOOST_ROOT=$BOOST_PATH/boost_1_46_1 \
  -DPARAVIEW_BUILD_PLUGIN=EyeDomeLighting \
  -DPARAVIEW_USE_VISITBRIDGE=ON \
  -DVISIT_BUILD_READER_CGNS=OFF \
  -DVISIT_BUILD_READER_Silo=OFF \
  -DBUILD_DOCUMENTATION=OFF \
  -DPARAVIEW_GENERATE_PROXY_DOCUMENTATION=OFF \
  -DGENERATE_FILTERS_DOCUMENTATION=OFF \
  -DDOCUMENTATION_HTML_HELP=OFF \
  $*
