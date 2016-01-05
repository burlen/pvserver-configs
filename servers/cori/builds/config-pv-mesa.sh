#!/bin/bash

LIB_EXT=so
PY_LIB_EXT=so
MESA_LIB_EXT=so
DSO=OFF
COMP_FLAGS="-fPIC -Ofast -mavx -msse -march=native -Wl,-L/opt/cray/atp/1.8.3/libApp/ -L/opt/cray/atp/1.7.5/lib -lAtpSigHandler -lAtpSigHCommData -Wl,--undefined=_ATP_Data_Globals -Wl,--undefined=__atpHandlerInstall"
MESA_DRIVER=llvmpipe
export XTPE_LINK_TYPE=dynamic

CCOMP=`which gcc`
CXXCOMP=`which g++`
FTNCOMP=`which gfortran`

MPT=/opt/cray/mpt/7.2.5/gni/mpich2-gnu/51/
#RCA=/opt/cray/rca/1.0.0-2.0502.60530.1.62.ari/
XPMEM=/opt/cray/xpmem/0.1-2.0502.64982.5.3.ari/
DMAP=/opt/cray/dmapp/7.0.1-1.0502.11080.8.76.ari/
UGNI=/opt/cray/ugni/6.0-1.0502.10863.8.29.ari/
UDREG=/opt/cray/udreg/2.3.2-1.0502.10518.2.17.ari/
PMI=/opt/cray/pmi/5.0.9-1.0000.10911.0.0.ari/
SMA=/opt/cray/mpt/7.2.5/gni/sma/
WLM=
ALPS=/opt/cray/alps/5.2.4-2.0502.9774.31.11.ari/
SRUN=/opt/slurm/default/

MESA=/usr/common/graphics/mesa/11.0.6/
LLVM=/usr/common/graphics/llvm/3.7.0/
LLVM_VER=3.7.0
GLU=/usr/common/graphics/glu/9.0.0/
PYTHON=/usr/common/software/python/2.7.10/
BOOST=/usr/common/software/boost/1.59/hsw/gnu/
HDF5=
ZLIB=/usr/lib64/

# from PDACS project, but they never actually used our
# builds as far as I can tell. So disable these until
# they complain.
#    -DPARAVIEW_ENABLE_COSMOTOOLS=ON \
#    -DCOSMOTOOLS_INCLUDE_DIR=/usr/common/graphics/ParaView/PDACS/cosmotools/include \
#    -DCOSMOTOOLS_LIBRARIES=/usr/common/graphics/ParaView/PDACS/cosmotools/lib/libcosmotools.a \
#    -DGENERIC_IO_INCLUDE_DIR=/usr/common/graphics/ParaView/PDACS/genericio/include \
#    -DGENERIC_IO_LIBRARIES=/usr/common/graphics/ParaView/PDACS/genericio/lib/libGenericIO.a \

#    -DVISIT_BUILD_READER_GMV=$DSO \
#    -DPARAVIEW_BUILD_PLUGIN_AdiosReader=FALSE \
#    -DPARAVIEW_BUILD_PLUGIN_AnalyzeNIfTIIO=$DSO \
#    -DPARAVIEW_BUILD_PLUGIN_ArrowGlyph=$DSO \
#    -DPARAVIEW_BUILD_PLUGIN_EyeDomeLighting=$DSO \
#    -DPARAVIEW_BUILD_PLUGIN_ForceTime=FALSE \
#    -DPARAVIEW_BUILD_PLUGIN_GMVReader=$DSO \
#    -DPARAVIEW_BUILD_PLUGIN_H5PartReader=$DSO \
#    -DPARAVIEW_BUILD_PLUGIN_InSituExodus=FALSE \
#    -DPARAVIEW_BUILD_PLUGIN_Moments=$DSO \
#    -DPARAVIEW_BUILD_PLUGIN_Nektar=FALSE \
#    -DPARAVIEW_BUILD_PLUGIN_NonOrthogonalSource=$DSO \
#    -DPARAVIEW_BUILD_PLUGIN_PacMan=$DSO \
#    -DPARAVIEW_BUILD_PLUGIN_PointSprite=$DSO \
#    -DPARAVIEW_BUILD_PLUGIN_PrismPlugin=$DSO \
#    -DPARAVIEW_BUILD_PLUGIN_QuadView=$DSO \
#    -DPARAVIEW_BUILD_PLUGIN_SLACTools=$DSO \
#    -DPARAVIEW_BUILD_PLUGIN_SciberQuestToolKit=ON \
#    -DPARAVIEW_BUILD_PLUGIN_SierraPlotTools=$DSO \
#    -DPARAVIEW_BUILD_PLUGIN_StreamingParticles=$DSO \
#    -DPARAVIEW_BUILD_PLUGIN_SurfaceLIC=ON \
#    -DPARAVIEW_BUILD_PLUGIN_UncertaintyRendering=$DSO \
#    -DPARAVIEW_BUILD_PLUGIN_VaporPlugin=FALSE \

echo
echo "BUILD_TYPE=$BUILD_TYPE"
echo "LIB_EXT=$LIB_EXT"
echo "DSO=$DSO"
echo "MPI2=$MPI2"
echo "MESA=$MESA"
echo "PYTHON=$PYTHON"
echo "BOOST=$BOOST"
echo "COMP=$COMP"
echo "TOOLCHAIN=$TOOLCHAIN"
echo "NATIVE_BUILD=$NATIVE_BUILD"
echo

cmake \
    -DCMAKE_C_COMPILER=$CCOMP \
    -DCMAKE_CXX_COMPILER=$CXXCOMP \
    -DCMAKE_Fortran_COMPILER=$FTNCOMP \
    -DCMAKE_BUILD_TYPE=RelWithDebInfo \
    -DCMAKE_CXX_FLAGS=$COMP_FLAGS \
    -DCMAKE_C_FLAGS=$COMP_FLAGS \
    -DBUILD_SHARED_LIBS=OFF \
    -DZLIB_LIBRARY=$ZLIB/libz.$LIB_EXT \
    -DPARAVIEW_ENABLE_PYTHON=ON \
    -DPYTHON_EXECUTABLE=$PYTHON/bin/python \
    -DPYTHON_INCLUDE_DIR=$PYTHON/include/python2.7 \
    -DPYTHON_LIBRARY=$PYTHON/lib/libpython2.7.$PY_LIB_EXT \
    -DPYTHON_UTIL_LIBRARY=/usr/lib64/libutil.$PY_LIB_EXT \
    -DPARAVIEW_FREEZE_PYTHON=ON \
    -DBUILD_TESTING=OFF \
    -DPARAVIEW_BUILD_QT_GUI=OFF \
    -DCMAKE_X_LIBS="" \
    -DX11_LIBRARIES="" \
    -DVTK_USE_X=OFF \
    -DVTK_OPENGL_HAS_OSMESA=ON \
    -DOSMESA_INCLUDE_DIR=$MESA/include \
    -DOSMESA_LIBRARY="$MESA/lib/libOSMesa.$MESA_LIB_EXT;$LLVM/lib/libLLVM-$LLVM_VER.$LIB_EXT;" \
    -DOPENGL_INCLUDE_DIR=$MESA/include \
    -DOPENGL_gl_LIBRARY=$MESA/lib/libOSMesa.$MESA_LIB_EXT \
    -DOPENGL_glu_LIBRARY=$GLU/lib/libGLU.$MESA_LIB_EXT \
    -DOPENGL_xmesa_INCLUDE_DIR=$MESA/include \
    -DPARAVIEW_USE_MPI=ON \
    -DMPI_CXX_COMPILER=$COMP/g++ \
    -DMPI_C_COMPILER=$COMP/gcc \
    -DMPI_Fortran_COMPILER=$COMP/gfortran \
    -DMPI_C_LIBRARIES="-Wl,--start-group;$MPT/lib/libmpich_gnu_51.$LIB_EXT;$MPT/lib/libmpl.$LIB_EXT;/usr/lib64/librt.$LIB_EXT;$SMA/lib64/libsma.$LIB_EXT;$XPMEM/lib64/libxpmem.$LIB_EXT;$DMAP/lib64/libdmapp.$LIB_EXT;$UGNI/lib64/libugni.$LIB_EXT;$PMI/lib64/libpmi.$LIB_EXT;$ALPS/lib64/libalpslli.$LIB_EXT;$ALPS/lib64/libalpsutil.$LIB_EXT;$UDREG/lib64/libudreg.$LIB_EXT;-Wl,--end-group;" \
    -DMPI_Fortran_LIBRARIES="-Wl,--start-group;$MPT/lib/libmpichf90.$LIB_EXT;$MPT/lib/libmpifort.$LIB_EXT;$MPT/lib/libmpich_gnu_51.$LIB_EXT;$MPT/lib/libmpl.$LIB_EXT;/usr/lib64/librt.$LIB_EXT;$SMA/lib64/libsma.$LIB_EXT;$XPMEM/lib64/libxpmem.$LIB_EXT;$DMAP/lib64/libdmapp.$LIB_EXT;$UGNI/lib64/libugni.$LIB_EXT;$PMI/libpmi.$LIB_EXT;$ALPS/lib64/libalpslli.$LIB_EXT;$ALPS/lib64/libalpsutil.$LIB_EXT;$UDREG/lib64/libudreg.$LIB_EXT;-Wl,--end-group;" \
    -DMPI_CXX_LIBRARIES="" \
    -DMPI_INCLUDE_PATH=$MPT/include \
    -DMPI_C_INCLUDE_PATH=$MPT/include \
    -DMPI_Fortran_INCLUDE_PATH=$MPT/include \
    -DMPIEXEC=$SRUN/bin/srun \
    -DPARAVIEW_USE_VISITBRIDGE=ON \
    -DBoost_INCLUDE_DIR=$BOOST/include \
    -DVISIT_BUILD_READER_CGNS=OFF \
    -DVISIT_BUILD_READER_Silo=OFF \
    -DVTK_USE_SYSTEM_HDF5=OFF \
    -DPARAVIEW_INSTALL_DEVELOPMENT=ON \
    $*
