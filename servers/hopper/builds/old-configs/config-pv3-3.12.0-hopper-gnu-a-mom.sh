#!/bin/bash
 
# if [ "$XTPE_LINK_TYPE" != "dynamic" ]
# then
#   echo "ERROR: You forgot export XTPE_LINK_TYPE=dynamic, I'll set it for you."
#   export XTPE_LINK_TYPE=dynamic
# fi

HDF5=/opt/cray/hdf5/1.8.7/gnu/46
MPI2=/opt/cray/mpt/5.4.0/xt/gemini/mpich2-gnu/46
MESA=/usr/common/graphics/ParaView/3.12.0-mom
PYTHON=/usr/common/graphics/ParaView/3.12.0-mom
BOOST=/usr/common/graphics/ParaView/boost_1_46_1
COMP=/opt/gcc/4.6.1/bin
#COMP=/opt/cray/xt-asyncpe/5.04/bin
 
# don't need a cross compile on MOM nodes
# TOOLCHAIN=/global/homes/l/loring/Hopper/ParaView/hopper_toolchain.cmake 
# NATIVE_BUILD=/global/homes/l/loring/Hopper/ParaView/PV3-3.10.0-so-login
#     -DCMAKE_SYSTEM_NAME=Linux \
#     -DCMAKE_CROSSCOMPILING=TRUE \
#     -DParaView3CompileTools_DIR=$NATIVE_BUILD \


#    -DVTK_USE_SYSTEM_HDF5=OFF \
#    -DHDF5_INCLUDE_DIR=$HDF5/include \
#    -DHDF5_INCLUDE_DIRS=$HDF5/include \
#    -DHDF5_LIBRARY_DIR=$HDF5/lib/libhdf5.a \
#    -DHDF5_LIBRARIES=$HDF5/lib/libhdf5.a \

#    -DPARAVIEW_ENABLE_PYTHON=OFF \
#    -DPYTHON_EXECUTABLE=$PYTHON/bin/python \
#    -DPYTHON_INCLUDE_DIR=$PYTHON/include/python2.7 \
#    -DPYTHON_LIBRARY=$PYTHON/lib/libpython2.7.a \
#    -DPYTHON_UTIL_LIBRARY=/usr/lib64/libutil.a \

echo
echo "MPI2=$MPI2"
echo "MESA=$MESA"
echo "PYTHON=$PYTHON"
echo "BOOST=$BOOST"
echo "COMP=$COMP"
echo "TOOLCHAIN=$TOOLCHAIN"
echo "NATIVE_BUILD=$NATIVE_BUILD"
echo


# this didn't work.
#    -DCMAKE_TOOLCHAIN_FILE=$TOOCHAIN \
#


# 
#    -DCMAKE_CFLAGS=-I/opt/cray/xe-sysroot/3.1.61.securitypatch.20110308/usr/include/ \


COMPILER_PATH=/opt/gcc/4.6.1/snos/libexec/gcc/x86_64-suse-linux/4.6.1/:/opt/gcc/4.6.1/snos/libexec/gcc/x86_64-suse-linux/4.6.1/:/opt/gcc/4.6.1/snos/libexec/gcc/x86_64-suse-linux/:/opt/gcc/4.6.1/snos/lib/gcc/x86_64-suse-linux/4.6.1/:/opt/gcc/4.6.1/snos/lib/gcc/x86_64-suse-linux/
LIBRARY_PATH=/opt/gcc/4.6.1/snos/lib/gcc/x86_64-suse-linux/4.6.1/:/opt/gcc/4.6.1/snos/lib/gcc/x86_64-suse-linux/4.6.1/../../../../lib64/:/lib/../lib64/:/usr/lib/../lib64/:/opt/gcc/4.6.1/snos/lib/gcc/x86_64-suse-linux/4.6.1/../../../:/lib/:/usr/lib/
COLLECT_GCC_OPTIONS='-u' 'pthread_mutex_trylock' '-u' 'pthread_mutex_destroy' '-u' 'pthread_create' '-static' '-v' '-L/opt/cray/udreg/2.3.1-1.0400.3911.5.13.gem/lib64' '-L/opt/cray/ugni/2.3-1.0400.4127.5.20.gem/lib64' '-L/opt/cray/dmapp/3.2.1-1.0400.3965.10.63.gem/lib64' '-L/opt/cray/xpmem/0.1-2.0400.30792.5.6.gem/lib64' '-L/opt/cray/pmi/3.0.0-1.0000.8661.28.2807.gem/lib64' '-I' '/opt/cray/udreg/2.3.1-1.0400.3911.5.13.gem/include' '-I' '/opt/cray/ugni/2.3-1.0400.4127.5.20.gem/include' '-I' '/opt/cray/dmapp/3.2.1-1.0400.3965.10.63.gem/include' '-I' '/opt/cray/gni-headers/2.1-1.0400.4156.6.1.gem/include' '-I' '/opt/cray/xpmem/0.1-2.0400.30792.5.6.gem/include' '-I' '/opt/cray/pmi/3.0.0-1.0000.8661.28.2807.gem/include' '-D' '__x86_64__' '-D' '__CRAYXE' '-D' '__CRAYXT_COMPUTE_LINUX_TARGET' '-D' '__TARGET_LINUX__' '-I' '/opt/cray/mpt/5.4.0/xt/gemini/mpich2-gnu/46/include' '-I' '/opt/xt-libsci/11.0.03/gnu/46/istanbul/include' '-I' '/usr/include/alps' '-L/opt/cray/mpt/5.4.0/xt/gemini/mpich2-gnu/46/lib' '-L/opt/xt-libsci/11.0.03/gnu/46/istanbul/lib' '-L/usr/lib/alps' '-mtune=generic' '-march=x86-64'


 /opt/gcc/4.6.1/snos/libexec/gcc/x86_64-suse-linux/4.6.1/collect2
 --sysroot= -m elf_x86_64 
-static 
-u 
pthread_mutex_trylock -u pthread_mutex_destroy -u pthread_create /usr/lib/../lib64/crt1.o /usr/lib/../lib64/crti.o /opt/gcc/4.6.1/snos/lib/gcc/x86_64-suse-linux/4.6.1/crtbeginT.o

 -L/opt/cray/udreg/2.3.1-1.0400.3911.5.13.gem/lib64
 -L/opt/cray/ugni/2.3-1.0400.4127.5.20.gem/lib64

 -L/opt/cray/dmapp/3.2.1-1.0400.3965.10.63.gem/lib64
 -L/opt/cray/xpmem/0.1-2.0400.30792.5.6.gem/lib64
 -L/opt/cray/pmi/3.0.0-1.0000.8661.28.2807.gem/lib64
 -L/opt/cray/mpt/5.4.0/xt/gemini/mpich2-gnu/46/lib

 -L/opt/xt-libsci/11.0.03/gnu/46/istanbul/lib
 -L/usr/lib/alps
 -L/opt/gcc/4.6.1/snos/lib/gcc/x86_64-suse-linux/4.6.1
 -L/opt/gcc/4.6.1/snos/lib/gcc/x86_64-suse-linux/4.6.1/../../../../lib64
 -L/lib/../lib64
 -L/usr/lib/../lib64
 -L/opt/gcc/4.6.1/snos/lib/gcc/x86_64-suse-linux/4.6.1/../../..
 -L/opt/cray/atp/1.4.1/lib/
 -lAtpSigHandler
 --undefined=__atpHandlerInstall
 --start-group
 -lgfortran -lscicpp_gnu -lsci_gnu_mp -lgfortran

 -lmpichcxx_gnu -lmpich_gnu -lmpichcxx_gnu -lmpl -lxpmem -ldmapp 



 --as-needed -lalpslli -lalpsutil --no-as-needed -ludreg -lpthread --end-group -lgomp -lpthread -lstdc++ -lm --start-group -lgcc -lgcc_eh -lc --end-group /opt/gcc/4.6.1/snos/lib/gcc/x86_64-suse-linux/4.6.1/crtend.o /usr/lib/../lib64/crtn.o
/usr/lib/../lib64/crt1.o: In function `_start':

    -DCMAKE_C_IMPLICIT_LINK_LIBRARIES="AtpSigHandler;stdc++;mpich_gnu;mpl;xpmem;dmapp;ugni;pmi;alpslli;alpsutil;udreg;pthread;m;gomp;pthread;c" \
    -DCMAKE_C_IMPLICIT_LINK_DIRECTORIES="/opt/cray/udreg/2.3.1-1.0400.3911.5.13.gem/lib64;/opt/cray/ugni/2.3-1.0400.4127.5.20.gem/lib64;/opt/cray/dmapp/3.2.1-1.0400.3965.10.63.gem/lib64;/opt/cray/xpmem/0.1-2.0400.30792.5.6.gem/lib64;/opt/cray/pmi/3.0.0-1.0000.8661.28.2807.gem/lib64;/opt/cray/mpt/5.4.0/xt/gemini/mpich2-gnu/46/lib;/usr/lib/alps;/opt/gcc/4.6.1/snos/lib64;/lib64;/usr/lib64;/opt/gcc/4.6.1/snos/lib;/opt/cray/atp/1.4.1/lib" \
    -DCMAKE_CXX_IMPLICIT_LINK_LIBRARIES="mpichcxx_gnu;mpich_gnu;mpichcxx_gnu;mpl;xpmem;dmapp;ugni;pmi;alpslli;alpsutil;udreg;pthread;gomp;pthread;stdc++;m;c" \
    -DCMAKE_CXX_IMPLICIT_LINK_DIRECTORIES="/opt/cray/udreg/2.3.1-1.0400.3911.5.13.gem/lib64;/opt/cray/ugni/2.3-1.0400.4127.5.20.gem/lib64;/opt/cray/dmapp/3.2.1-1.0400.3965.10.63.gem/lib64;/opt/cray/xpmem/0.1-2.0400.30792.5.6.gem/lib64;/opt/cray/pmi/3.0.0-1.0000.8661.28.2807.gem/lib64;/opt/cray/mpt/5.4.0/xt/gemini/mpich2-gnu/46/lib;/usr/lib/alps;/opt/gcc/4.6.1/snos/lib64;/lib64;/usr/lib64;/opt/gcc/4.6.1/snos/lib;/opt/cray/atp/1.4.1/lib" \




cmake \
    -DCMAKE_BUILD_TYPE=Debug \
    -DCMAKE_C_COMPILER=$COMP/gcc \
    -DCMAKE_CXX_COMPILER=$COMP/g++ \
    -DCMAKE_EXE_LINKER=$COMP/g++ \
    -DCMAKE_C_FLAGS=-static -Wl,-Bstatic \
    -DCMAKE_CXX_FLAGS=-static -Wl,-Bstatic \
    -DCMAKE_EXE_LINKER_FLAGS=-Bstatic \
    -DCMAKE_MODULE_LINKER_FLAGS=-Bstatic \
    -DCMAKE_SHARED_LINKER_FLAGS=-Bdynamic \
    -DCMAKE_INSTALL_PREFIX=/usr/common/graphics/ParaView/3.12.0-mom \
    -DBUILD_SHARED_LIBS=OFF \
    -DBUILD_TESTING=OFF \
    -DPARAVIEW_BUILD_QT_GUI=OFF \
    -DVTK_USE_X=OFF \
    -DVTK_OPENGL_HAS_OSMESA=ON \
    -DOPENGL_INCLUDE_DIR=$MESA/include \
    -DOPENGL_gl_LIBRARY="" \
    -DOPENGL_glu_LIBRARY=$MESA/lib/libGLU.a \
    -DOPENGL_xmesa_INCLUDE_DIR=$MESA/include \
    -DOSMESA_INCLUDE_DIR=$MESA/include \
    -DOSMESA_LIBRARY=$MESA/lib/libOSMesa32.a \
    -DPARAVIEW_USE_MPI=ON \
    -DMPI_INCLUDE_PATH=$MPI2/include \
    -DMPI_LIBRARY=$MPI2/lib/libmpich_gnu.a \
    -DMPI_EXTRA_LIBRARY=/usr/lib64/librt.a\;/usr/lib64/libpthread.a\;/opt/cray/mpt/5.4.0/xt/gemini/mpich2-gnu/46/lib/libmpl.a\;/opt/cray/ugni/2.3-1.0400.4127.5.20.gem/lib64/libugni.a\;/opt/cray/pmi/3.0.0-1.0000.8661.28.2807.gem/lib64/libpmi.a\;/opt/cray/udreg/2.3.1-1.0400.3911.5.13.gem/lib64/libudreg.a\;/opt/cray/xpmem/0.1-2.0400.30792.5.6.gem/lib64/libxpmem.a\;/opt/cray/dmapp/3.2.1-1.0400.3965.10.63.gem/lib64/libdmapp.a\;/usr/lib/alps/libalpslli.a\;/usr/lib/alps/libalpsutil.a \
    -DBOOST_ROOT=$BOOST \
    -DVTK_USE_BOOST=ON \
    -DPARAVIEW_BUILD_PLUGIN=EyeDomeLighting \
    -DPARAVIEW_USE_VISITBRIDGE=ON \
    -DVISIT_BUILD_READER_CGNS=OFF \
    -DVISIT_BUILD_READER_Silo=OFF \
    -DPARAVIEW_INSTALL_DEVELOPMENT=OFF \
    $* 

