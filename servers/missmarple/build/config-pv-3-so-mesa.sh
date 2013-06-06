#!/bin/bash

MESA=/work/apps/mesa-dev/

cmake \
  -DCMAKE_CXX_FLAGS=-Wall -Wextra \
  -DCMAKE_BUILD_TYPE=Debug \
  -DVTK_DEBUG_LEAKS=ON \
  -DBUILD_SHARED_LIBS=ON \
  -DBUILD_TESTING=ON \
  -DVTK_DATA_ROOT=../VTKData \
  -DPARAVIEW_DATA_ROOT=/work/ext/ParaView/sqtk-pv/ParaViewData \
  -DVTK_DATA_ROOT=//work/ext/ParaView/sqtk-pv/VTKData \
  -DBOOST_ROOT=/work/ext/ParaView/boost_1_47_0 \
  -DVTK_USE_BOOST=ON \
  -DPARAVIEW_ENABLE_PYTHON=ON \
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
  $*

