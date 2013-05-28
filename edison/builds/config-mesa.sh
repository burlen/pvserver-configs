#!/bin/bash

./configure --disable-xvmc --disable-glx --disable-dri --with-dri-drivers= --with-gallium-drivers=swrast --enable-texture-float --disable-shared-glapi --disable-egl --with-egl-platforms= --enable-gallium-llvm --with-llvm-prefix=/usr/common/graphics/llvm/3.2/ --enable-osmesa --prefix=/usr/common/graphics/mesa/9.2.0
