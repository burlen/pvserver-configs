#!/bin/bash

cmake \
  -DCMAKE_CXX_FLAGS=-Wall -Wextra \
  -DCMAKE_BUILD_TYPE=Debug \
  -DVTK_DEBUG_LEAKS=ON \
  -DBUILD_SHARED_LIBS=ON \
  -DBUILD_TESTING=ON \
  -DVTK_DATA_ROOT=../VTKData \
  $*

