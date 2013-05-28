set(PV_TEST_NAME "gcc-mpt-py-osmesa")
set(PV_TEST_HOST "edison.nersc.gov")
set(PV_NP 32)
set(PV_TEST_ROOT "/global/common/edison/graphics/ParaView/dashboards")
set(PV_BUILD_TYPE Debug)

set(COMP "/opt/gcc/4.7.2/bin/")
set(MPT "/opt/cray/mpt/5.6.1/gni/")
set(MPI2 "${MPT}/mpich2-gnu/47/")
set(XPMEM "/opt/cray/xpmem/0.1-2.0500.39645.2.7.ari/")
set(DMAP "/opt/cray/dmapp/5.0.1-1.0500.6257.4.208.ari/")
set(UGNI "/opt/cray/ugni/5.0-1.0500.6415.7.120.ari/")
set(UDREG "/opt/cray/udreg/2.3.2-1.0500.6003.1.18.ari/")
set(PMI "/opt/cray/pmi/4.0.1-1.0000.9421.73.3.ari/")
set(ALPS "/opt/cray/alps/5.0.2-2.0500.7827.1.1.ari/")
set(APRUN "/usr/common/usg/altd/1.0/")
set(MESA "/usr/common/graphics/mesa/9.2.0")
set(PYTHON "/usr/common/usg/python/2.7.3")

set(ENV{XTPE_LINK_TYPE} dynamic)
set(ENV{GIT_DISCOVERY_ACROSS_FILESYSTEM} 1)
set(ENV{CRAY_ROOTFS} DSL)

message("MPI2=${MPI2}")
message("MESA=${MESA}")
message("PYTHON=${PYTHON}")
message("BOOST=${BOOST}")
message("COMP=${COMP}")
message("XTPE_LINK_TYPE=$ENV{XTPE_LINK_TYPE}")

set (dashboard_cache "
CMAKE_CXX_FLAGS=-Wall -Wextra
CMAKE_C_FLAGS=-Wall -Wextra
CMAKE_BUILD_TYPE=Release
CMAKE_C_COMPILER=${COMP}/gcc
CMAKE_CXX_COMPILER=${COMP}/g++
CMAKE_EXE_LINKER=${COMP}/g++
CMAKE_INSTALL_PREFIX=/usr/common/graphics/ParaView/next
BUILD_SHARED_LIBS=ON
PARAVIEW_ENABLE_PYTHON=ON
PYTHON_EXECUTABLE=${PYTHON}/bin/python
PYTHON_INCLUDE_DIR=${PYTHON}/include/python2.7
PYTHON_LIBRARY=${PYTHON}/lib/libpython2.7.so
PYTHON_UTIL_LIBRARY=/usr/lib64/libutil.so
BUILD_TESTING=ON
PARAVIEW_DISABLE_VTK_TESTING=OFF
VTK_BUILD_ALL_MODULES_FOR_TESTS=ON
PARAVIEW_BUILD_QT_GUI=OFF
VTK_USE_X=OFF
VTK_OPENGL_HAS_OSMESA=ON
OPENGL_INCLUDE_DIR=${MESA}/include
OPENGL_gl_LIBRARY=${MESA}/lib/libOSMesa.so
OPENGL_glu_LIBRARY=${MESA}/lib/libOSMesa.so
OPENGL_xmesa_INCLUDE_DIR=${MESA}/include
OSMESA_INCLUDE_DIR=${MESA}/include
OSMESA_LIBRARY=${MESA}/lib/libOSMesa.so
PARAVIEW_USE_MPI=ON
MPI_CXX_COMPILER=${COMP}/g++
MPI_C_COMPILER=${COMP}/gcc
MPI_LIBRARY=${MPI2}/lib/libmpich_gnu_47.so
MPI_EXTRA_LIBRARY=${MPI2}/lib/libmpichcxx_gnu_47.so\;${MPI2}/lib/libmpl.so\;/usr/lib64/librt.so\;${MPT}/sma/lib64/libsma.so\;${XPMEM}/lib64/libxpmem.so\;${DMAP}/lib64/libdmapp.so\;${UGNI}/lib64/libugni.so\;${PMI}/lib64/libpmi.so\;${ALPS}/lib64/libalpslli.so\;${ALPS}/lib64/libalpsutil.so\;${UDREG}/lib64/libudreg.so\;/usr/lib64/libpthread.so\;
MPI_INCLUDE_PATH=${MPI2}/include
MPIEXEC=${APRUN}/bin/aprun
MPIEXEC_NUMPROC_FLAG=-n
PARAVIEW_USE_VISITBRIDGE=ON
VISIT_BUILD_READER_CGNS=OFF
VISIT_BUILD_READER_Silo=OFF
VISIT_BUILD_READER_GMV=OFF
PARAVIEW_INSTALL_DEVELOPMENT=OFF
")

set(dashboard_model NightlyNext)  # NightlyMaster | NightlyNext | Experimental | Continuous
set(dashboard_disable_loop TRUE)
set(dashboard_root_name "")
set(dashboard_source_name ParaView)
set(dashboard_binary_name ParaView-build)
set(dashboard_data_name ParaViewData)
set(dashboard_do_coverage FALSE)
set(dashboard_do_memcheck FALSE)
#set(CTEST_BUILD_FLAGS -j${PV_NP})
set(CTEST_BUILD_COMMAND "${PV_TEST_ROOT}/make_on_login.sh ${PV_TEST_ROOT}/${PV_TEST_NAME}/ParaView-build")
set(CTEST_DASHBOARD_ROOT ${PV_TEST_ROOT}/${PV_TEST_NAME})
set(CTEST_BUILD_CONFIGURATION ${PV_BUILD_TYPE})
set(CTEST_CMAKE_GENERATOR "Unix Makefiles")
set(CTEST_SITE ${PV_TEST_HOST})
set(CTEST_BUILD_NAME Cray-XC30-${PV_TEST_NAME})
set(CTEST_TEST_ARGS PARALLEL_LEVEL 1)
set(PARAVIEW_DATA_ROOT ${PV_TEST_ROOT}/${PV_TEST_NAME}/ParaViewData)
set(VTK_DATA_ROOT ${PV_TEST_ROOT}/${PV_TEST_NAME}/VTKData)

include(paraview_common.cmake)
