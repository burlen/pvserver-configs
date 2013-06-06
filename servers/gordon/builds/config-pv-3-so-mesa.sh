#!/bin/bash

prefix=/oasis/projects/nsf/gue998/bloring/installs

COMP=/opt/gnu/gcc/4.6.1/
MESA=$prefix/mesa/9.2.0/
BOOST=$prefix/boost_1_53_0
PYTHON=/opt/python/

# debugging opts
#  -DCMAKE_CXX_FLAGS=-Wall -Wextra \
#  -DCMAKE_BUILD_TYPE=Debug \
#  -DVTK_DEBUG_LEAKS=ON \

cmake \
  -DCMAKE_C_COMPILER=$COMP/bin/gcc \
  -DCMAKE_CXX_COMPILER=$COMP/bin/g++ \
  -DBUILD_SHARED_LIBS=ON \
  -DBUILD_TESTING=ON \
  -DVTK_DATA_ROOT=../VTKData \
  -DPARAVIEW_DATA_ROOT=../ParaViewData \
  -DVTK_DATA_ROOT=../VTKData \
  -DBOOST_ROOT=$BOOST \
  -DVTK_USE_BOOST=ON \
  -DPARAVIEW_ENABLE_PYTHON=ON \
  -DPYTHON_EXECUTABLE=$PYTHON/bin/python \
  -DPYTHON_EXTRA_LIBS="" \
  -DPYTHON_INCLUDE_DIR=$PYTHON/include/python2.7 \
  -DPYTHON_LIBRARY=/$PYTHON/lib/libpython2.7.so \
  -DPARAVIEW_USE_MPI=ON \
  -DPARAVIEW_BUILD_QT_GUI=OFF \
  -DVTK_USE_X=OFF \
  -DVTK_OPENGL_HAS_OSMESA=ON \
  -DOPENGL_INCLUDE_DIR=$MESA/include \
  -DOPENGL_gl_LIBRARY=$MESA/lib/libOSMesa32.so \
  -DOPENGL_glu_LIBRARY="" \
  -DOPENGL_glut_LIBRARY="" \
  -DGLUT_glut_LIBRARY="" \
  -DGLUT_INCLUDE_DIR="" \
  -DGLUT_Xi_LIBRARY="" \
  -DGLUT_Xmu_LIBRARY="" \
  -DGLUT_glut_LIBRARY="" \
  -DOPENGL_xmesa_INCLUDE_DIR=$MESA/include \
  -DOSMESA_INCLUDE_DIR=$MESA/include \
  -DOSMESA_LIBRARY=$MESA/lib/libOSMesa32.so \
  -DPARAVIEW_BUILD_PLUGIN=EyeDomeLighting \
  -DPARAVIEW_USE_VISITBRIDGE=ON \
  -DVISIT_BUILD_READER_CGNS=OFF \
  -DVISIT_BUILD_READER_Silo=OFF \
  -DVISIT_BUILD_READER_GMV=OFF \
  -DBUILD_FORTRAN_COPROCESSING_ADAPTORS=ON \
  -DBUILD_PHASTA_ADAPTOR=ON \
  -DENABLE_MPI4PY=ON \
  $*
