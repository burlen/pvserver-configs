#!/bin/bash

MESA=/work/apps/mesa-dev
# -DOPENGL_glu_LIBRARY=$MESA/lib/libGLU.so \
cmake \
  -DCMAKE_CXX_FLAGS=-Wall -Wextra \
  -DCMAKE_BUILD_TYPE=Debug \
  -DVTK_DEBUG_LEAKS=ON \
  -DBUILD_SHARED_LIBS=ON \
  -DBUILD_TESTING=ON \
  -DVTK_DATA_ROOT=../VTKData \
  -DBOOST_ROOT=/work/ext/ParaView/boost_1_47_0 \
  -DVTK_USE_BOOST=ON \
  -DVTK_USE_X=OFF \
  -DVTK_OPENGL_HAS_OSMESA=ON \
  -DOPENGL_INCLUDE_DIR=$MESA/include \
  -DOPENGL_gl_LIBRARY=$MESA/lib/libOSMesa.so \
  -DOPENGL_xmesa_INCLUDE_DIR=$MESA/include \
  -DOSMESA_INCLUDE_DIR=$MESA/include \
  -DOSMESA_LIBRARY=$MESA/lib/libOSMesa.so \
  $*

