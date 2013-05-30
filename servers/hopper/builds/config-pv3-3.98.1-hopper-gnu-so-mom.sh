#!/bin/bash
 
if [ "$XTPE_LINK_TYPE" != "dynamic" ]
then
  echo "ERROR: You forgot export XTPE_LINK_TYPE=dynamic, I'll set it for you."
  export XTPE_LINK_TYPE=dynamic
fi

HDF5=/opt/cray/hdf5/1.8.7/gnu/46
MPI2=/opt/cray/mpt/5.5.2/gni/mpich2-gnu/47
MESA=/usr/common/graphics/ParaView/Mesa-7.10.1
PYTHON=/usr/common/usg/python/2.7.1
BOOST=/usr/common/graphics/ParaView/boost_1_46_1
COMP=/opt/gcc/4.7.1/bin



'-L/opt/cray/udreg/2.3.2-1.0401.5929.3.3.gem/lib64'
'-L/opt/cray/ugni/4.0-1.0401.5928.9.5.gem/lib64'
'-L/opt/cray/pmi/4.0.0-1.0000.9282.69.4.gem/lib64'
'-L/opt/cray/dmapp/3.2.1-1.0401.5983.4.5.gem/lib64'
'-L/opt/cray/xpmem/0.1-2.0401.36790.4.3.gem/lib64'
'-L/opt/cray/rca/1.0.0-2.0401.38656.2.2.gem/lib64'
'-I'
'/opt/cray/udreg/2.3.2-1.0401.5929.3.3.gem/include'
'-I'
'/opt/cray/ugni/4.0-1.0401.5928.9.5.gem/include'
'-I'
'/opt/cray/pmi/4.0.0-1.0000.9282.69.4.gem/include'
'-I'
'/opt/cray/dmapp/3.2.1-1.0401.5983.4.5.gem/include'
'-I'
'/opt/cray/gni-headers/2.1-1.0401.5675.4.4.gem/include'
'-I'
'/opt/cray/xpmem/0.1-2.0401.36790.4.3.gem/include'
'-I'
'/opt/cray/dvs/1.8.6_0.9.0-1.0401.1401.1.120/include'
'-I'
'/opt/cray/rca/1.0.0-2.0401.38656.2.2.gem/include'
'-I'
'/opt/cray-hss-devel/7.0.0/include'
'-I'
'/opt/cray/krca/1.0.0-2.0401.36792.3.70.gem/include'
'-D'
'__x86_64__'
'-D'
'__CRAYXE'
'-D'
'__CRAYXT_COMPUTE_LINUX_TARGET'
'-D'
'__TARGET_LINUX__'
'-I'
'/opt/cray/mpt/5.6.0/gni/mpich2-gnu/47/include'
'-I'
'/opt/cray/mpt/5.6.0/gni/sma/include'
'-I'
'/opt/cray/libsci/12.0.00/gnu/47/mc12/include'
'-I'
'/usr/include/alps'

-I '/opt/cray/mpt/5.6.0/gni/mpich2-gnu/47/include'
'-L/opt/cray/mpt/5.6.0/gni/mpich2-gnu/47/lib'
'-L/opt/cray/mpt/5.6.0/gni/sma/lib64'
'-L/opt/cray/libsci/12.0.00/gnu/47/mc12/lib'
'-L/usr/lib/alps'
'-L/usr/common/usg/darshan/2.2.5-pre3-cle4/lib'



/opt/gcc/4.7.2/snos/libexec/gcc/x86_64-suse-linux/4.7.2/collect2
--sysroot=
-m
elf_x86_64
-static
-u
pthread_mutex_trylock
-u
pthread_mutex_destroy
-u
pthread_create
/usr/lib/../lib64/crt1.o
/usr/lib/../lib64/crti.o
/opt/gcc/4.7.2/snos/lib/gcc/x86_64-suse-linux/4.7.2/crtbeginT.o
-L/usr/common/usg/darshan/2.2.5-pre3-cle4/lib
-L/opt/cray/udreg/2.3.2-1.0401.5929.3.3.gem/lib64
-L/opt/cray/ugni/4.0-1.0401.5928.9.5.gem/lib64
-L/opt/cray/pmi/4.0.0-1.0000.9282.69.4.gem/lib64
-L/opt/cray/dmapp/3.2.1-1.0401.5983.4.5.gem/lib64
-L/opt/cray/xpmem/0.1-2.0401.36790.4.3.gem/lib64
-L/opt/cray/rca/1.0.0-2.0401.38656.2.2.gem/lib64
-L/opt/cray/mpt/5.6.0/gni/mpich2-gnu/47/lib
-L/opt/cray/mpt/5.6.0/gni/sma/lib64
-L/opt/cray/libsci/12.0.00/gnu/47/mc12/lib
-L/usr/lib/alps
-L/usr/common/usg/darshan/2.2.5-pre3-cle4/lib
-L/opt/gcc/4.7.2/snos/lib/gcc/x86_64-suse-linux/4.7.2
-L/opt/gcc/4.7.2/snos/lib/gcc/x86_64-suse-linux/4.7.2/../../../../lib64
-L/lib/../lib64
-L/usr/lib/../lib64
-L/opt/gcc/4.7.2/snos/lib/gcc/x86_64-suse-linux/4.7.2/../../..
-rpath=/opt/gcc/default/snos/lib64
-lmpichcxx
-ldarshan-mpi-io
-lz
-u
MPI_Init
-u
MPI_Wtime
-wrap
write
-wrap
open
-wrap
creat
-wrap
creat64
-wrap
open64
-wrap
close
-wrap
read
-wrap
lseek
-wrap
lseek64
-wrap
pread
-wrap
pwrite
-wrap
readv
-wrap
writev
-wrap
__xstat
-wrap
__lxstat
-wrap
__fxstat
-wrap
__xstat64
-wrap
__lxstat64
-wrap
__fxstat64
-wrap
mmap
-wrap
mmap64
-wrap
fopen
-wrap
fclose
-wrap
fread
-wrap
fwrite
-wrap
fseek
-wrap
fopen64
-wrap
pread64
-wrap
pwrite64
-wrap
fsync
-wrap
fdatasync
-wrap
ncmpi_create
-wrap
ncmpi_open
-wrap
ncmpi_close
-wrap
H5Fcreate
-wrap
H5Fopen
-wrap
H5Fclose
-lrca
-L/opt/cray/atp/1.6.0/lib/
--undefined=_ATP_Data_Globals
--undefined=__atpHandlerInstall
-lAtpSigHCommData
-lAtpSigHandler
--start-group
-lgfortran
-lscicpp_gnu
-lsci_gnu_mp
-lgfortran
-lalpslli
-lalpsutil
-ludreg
-lpthread
-ldarshan-posix
-ldarshan-mpi-io
-lz
--end-group
-lgomp
-lpthread
-lstdc++
-lm
--start-group
-lgcc
-lgcc_eh
-lc
--end-group
/opt/gcc/4.7.2/snos/lib/gcc/x86_64-suse-linux/4.7.2/crtend.o
/usr/lib/../lib64/crtn.o
 /usr/lib/../lib64/crt1.o: In function `_start':
 /usr/src/packages/BUILD/glibc-2.11.1/csu/../sysdeps/x86_64/elf/start.S:109: undefined reference to `main'
 /usr/bin/ld: link errors found, deleting executable `a.out'
 collect2: error: ld returned 1 exit status

























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
    -DCMAKE_INSTALL_PREFIX=/usr/common/graphics/ParaView/3.98-mom-so \
    -DBUILD_SHARED_LIBS=ON \
    -DPARAVIEW_ENABLE_PYTHON=ON \
    -DPYTHON_EXECUTABLE=$PYTHON/bin/python \
    -DPYTHON_INCLUDE_DIR=$PYTHON/include/python2.7 \
    -DPYTHON_LIBRARY=$PYTHON/lib/libpython2.7.so \
    -DPYTHON_UTIL_LIBRARY=/usr/lib64/libutil.so \
    -DBUILD_TESTING=OFF \
    -DPARAVIEW_BUILD_QT_GUI=OFF \
    -DVTK_USE_X=OFF \
    -DVTK_OPENGL_HAS_OSMESA=ON \
    -DOPENGL_INCLUDE_DIR=$MESA/include \
    -DOPENGL_gl_LIBRARY=$MESA/lib/libOSMesa32.so \
    -DOPENGL_glu_LIBRARY=$MESA/lib/libGLU.so \
    -DOPENGL_xmesa_INCLUDE_DIR=$MESA/include \
    -DOSMESA_INCLUDE_DIR=$MESA/include \
    -DOSMESA_LIBRARY=$MESA/lib/libOSMesa32.so \
    -DPARAVIEW_USE_MPI=ON \
    -DMPI_CXX_COMPILER=$COMP/g++ \
    -DMPI_C_COMPILER=$COMP/gcc \
    -DMPI_LIBRARY=$MPI2/lib/libmpich_gnu_47.so\


/opt/cray/udreg/2.3.2-1.0401.5929.3.3.gem/lib64
/opt/cray/pmi/4.0.0-1.0000.9282.69.4.gem/lib64
/opt/cray/dmapp/3.2.1-1.0401.5983.4.5.gem/lib64
/opt/cray/ugni/4.0-1.0401.5928.9.5.gem/lib64
/opt/cray/xpmem/0.1-2.0401.36790.4.3.gem/lib64
/opt/cray/mpt/5.6.0/gni/mpich2-gnu/47/lib
/opt/cray/mpt/5.6.0/gni/sma/lib64

libmpichcxx_gnu_47.so
libmpich_gnu_47.so
libmpl.so
librt.so
libsma.so
libxpmem.so
libdmapp.so
libugni.so
libpmi.so



    -DMPI_EXTRA_LIBRARY=$MPI2/lib/libmpichcxx_gnu_47.so\;$MPI2/lib/libmpl.so\;/usr/lib64/librt.so\;/opt/cray/mpt/5.5.2/gni/sma/lib64/libsma.so\;/opt/cray/xpmem/0.1-2.0400.31280.3.1.gem/lib64/libxpmem.so\;/opt/cray/dmapp/3.2.1-1.0400.4255.2.159.gem/lib64/libdmapp.so\;/opt/cray/ugni/2.3-1.0400.4374.4.88.gem/lib64/libugni.so\;/opt/cray/pmi/3.0.1-1.0000.9101.2.26.gem/lib64/libpmi.so\;/usr/lib/alps/libalpslli.so\;/usr/lib/alps/libalpsutil.so\;/opt/cray/udreg/2.3.1-1.0400.4264.3.1.gem/lib64/libudreg.so\;/usr/lib64/libpthread.so\; \
    -DMPI_INCLUDE_PATH=$MPI2/include \
    -DMPIEXEC=/usr/common/usg/altd/1.0/bin/aprun \
    -DBOOST_ROOT=$BOOST \
    -DVTK_USE_BOOST=ON \
    -DPARAVIEW_USE_VISITBRIDGE=ON \
    -DVISIT_BUILD_READER_CGNS=OFF \
    -DVISIT_BUILD_READER_Silo=OFF \
    -DPARAVIEW_INSTALL_DEVELOPMENT=OFF \
    $* 
