#!/bin/bash

./configure CFLAGS="-fPIC -O3" CXXFLAGS="-fPIC -O3" --disable-xvmc --disable-glx --disable-dri --with-dri-drivers= --with-gallium-drivers=swrast --enable-texture-float --disable-shared-glapi --disable-egl --with-egl-platforms= --enable-gallium-llvm --with-llvm-prefix=/home/bloring/installs/llvm/3.2/ --enable-osmesa --with-osmesa-bits=32 --prefix=/home/bloring/installs/mesa/9.2.0
