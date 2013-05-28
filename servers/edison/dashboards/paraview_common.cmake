# ParaView Common Dashboard Script
#
# This script contains basic dashboard driver code common to all
# clients.
#
# Put this script in a directory such as "~/Dashboards/Scripts" or
# "c:/Dashboards/Scripts".  Create a file next to this script, say
# 'my_dashboard.cmake', with code of the following form:
#
#   # Client maintainer: me@mydomain.net
#   set(CTEST_SITE "machine.site")
#   set(CTEST_BUILD_NAME "Platform-Compiler")
#   set(CTEST_BUILD_CONFIGURATION Debug)
#   set(CTEST_CMAKE_GENERATOR "Unix Makefiles")
#   include(${CTEST_SCRIPT_DIRECTORY}/paraview_common.cmake)
#
# Then run a scheduled task (cron job) with a command line such as
#
#   ctest -S ~/Dashboards/Scripts/my_dashboard.cmake -V
#
# By default the source and build trees will be placed in the path
# "../My Tests/" relative to your script location.
#
# The following variables may be set before including this script
# to configure it:
#
#   dashboard_model           = NightlyMaster | NightlyNext | Experimental | Continuous
#   dashboard_disable_loop    = For continuous dashboards, disable loop.
#   dashboard_root_name       = Change name of "My Tests" directory
#   dashboard_source_name     = Name of source directory (ParaView)
#   dashboard_binary_name     = Name of binary directory (ParaView-build)
#   dashboard_data_name       = Name of data directory (ParaViewData)
#   dashboard_cache           = Initial CMakeCache.txt file content
#   dashboard_cvs_tag         = CVS tag to checkout (ex: ParaView-3-8)
#   dashboard_do_coverage     = True to enable coverage (ex: gcov)
#   dashboard_do_memcheck     = True to enable memcheck (ex: valgrind)
#   CTEST_BUILD_FLAGS         = build tool arguments (ex: -j2)
#   CTEST_DASHBOARD_ROOT      = Where to put source and build trees
#   CTEST_TEST_CTEST          = Whether to run long CTestTest* tests
#   CTEST_TEST_TIMEOUT        = Per-test timeout length
#   CTEST_TEST_ARGS           = ctest_test args (ex: PARALLEL_LEVEL 4)
#   CMAKE_MAKE_PROGRAM        = Path to "make" tool to use
#   PARAVIEW_DATA_ROOT        = Where to put data tree
#
# Options to configure builds from experimental git repository:
#   dashboard_git_url      = Custom git clone url
#   dashboard_git_branch   = Custom remote branch to track
#   dashboard_git_crlf     = Value of core.autocrlf for repository
#
# For Makefile generators the script may be executed from an
# environment already configured to use the desired compilers.
# Alternatively the environment may be set at the top of the script:
#
#   set(ENV{CC}  /path/to/cc)   # C compiler
#   set(ENV{CXX} /path/to/cxx)  # C++ compiler
#   set(ENV{FC}  /path/to/fc)   # Fortran compiler (optional)
#   set(ENV{LD_LIBRARY_PATH} /path/to/vendor/lib) # (if necessary)

cmake_minimum_required(VERSION 2.8 FATAL_ERROR)

set(CTEST_PROJECT_NAME ParaView)
set(dashboard_user_home "$ENV{HOME}")

get_filename_component(dashboard_self_dir ${CMAKE_CURRENT_LIST_FILE} PATH)

# Select the top dashboard directory.
if(NOT DEFINED dashboard_root_name)
set(dashboard_root_name "My Tests")
endif()
if(NOT DEFINED CTEST_DASHBOARD_ROOT)
get_filename_component(CTEST_DASHBOARD_ROOT "${CTEST_SCRIPT_DIRECTORY}/../${dashboard_root_name}" ABSOLUTE)
endif()

# Select the model (Nightly, Experimental, Continuous).
if(NOT DEFINED dashboard_model)
set(dashboard_model NightlyNext)
endif()
if(NOT "${dashboard_model}" MATCHES "^(NightlyMaster|NightlyNext|Experimental|Continuous)$")
message(FATAL_ERROR "dashboard_model must be NightlyMaster, NightlyNext, Experimental, or Continuous")
endif()

if("${dashboard_model}" STREQUAL "NightlyMaster")
set(dashboard_track "Nightly (master)")
set(ctest_start_model Nightly)
elseif("${dashboard_model}" STREQUAL "NightlyNext")
set(dashboard_track "Nightly (next)")
set(ctest_start_model Nightly)
elseif("${dashboard_model}" STREQUAL "Continuous")
set(dashboard_track "Continuous (next)")
set(ctest_start_model Continuous)
else()
set(dashboard_track Experimental)
set(ctest_start_model Experimental)
endif()

# Default to a Debug build.
if(NOT DEFINED CTEST_CONFIGURATION_TYPE AND DEFINED CTEST_BUILD_CONFIGURATION)
set(CTEST_CONFIGURATION_TYPE ${CTEST_BUILD_CONFIGURATION})
endif()

if(NOT DEFINED CTEST_CONFIGURATION_TYPE)
set(CTEST_CONFIGURATION_TYPE Debug)
endif()

# Choose CTest reporting mode.
if(NOT "${CTEST_CMAKE_GENERATOR}" MATCHES "Make")
# Launchers work only with Makefile generators.
set(CTEST_USE_LAUNCHERS 0)
elseif(NOT DEFINED CTEST_USE_LAUNCHERS)
# The setting is ignored by CTest < 2.8 so we need no version test.
set(CTEST_USE_LAUNCHERS 1)
endif()

# Configure testing.
if(NOT DEFINED CTEST_TEST_CTEST)
set(CTEST_TEST_CTEST 1)
endif()
if(NOT CTEST_TEST_TIMEOUT)
set(CTEST_TEST_TIMEOUT 1500)
endif()


# Select Git source to use.
if(NOT DEFINED dashboard_git_url)
set(dashboard_git_url "git://paraview.org/ParaView.git")
endif()

# Select Git source to use.
if(NOT DEFINED dashboard_git_data_url)
set(dashboard_git_data_url "git://paraview.org/ParaViewData.git")
endif()

if(NOT DEFINED dashboard_git_branch)
if("${dashboard_model}" STREQUAL "NightlyMaster")
set(dashboard_git_branch nightly-master)
elseif("${dashboard_model}" STREQUAL "NightlyNext")
set(dashboard_git_branch nightly-next)
elseif("${dashboard_model}" STREQUAL "Continuous")
set(dashboard_git_branch next)
else()
set(dashboard_git_branch master)
endif()
endif()
if(NOT DEFINED dashboard_git_crlf)
if(UNIX)
set(dashboard_git_crlf false)
else(UNIX)
set(dashboard_git_crlf true)
endif(UNIX)
endif()

# Look for a GIT command-line client.
if(NOT DEFINED CTEST_GIT_COMMAND)
find_program(CTEST_GIT_COMMAND NAMES git git.cmd)
endif()

if(NOT DEFINED CTEST_GIT_COMMAND)
message(FATAL_ERROR "No Git Found.")
endif()

# Select a source directory name.
if(NOT DEFINED CTEST_SOURCE_DIRECTORY)
if(DEFINED dashboard_source_name)
set(CTEST_SOURCE_DIRECTORY ${CTEST_DASHBOARD_ROOT}/${dashboard_source_name})
else()
set(CTEST_SOURCE_DIRECTORY ${CTEST_DASHBOARD_ROOT}/ParaView)
endif()
endif()

# Select a build directory name.
if(NOT DEFINED CTEST_BINARY_DIRECTORY)
if(DEFINED dashboard_binary_name)
set(CTEST_BINARY_DIRECTORY ${CTEST_DASHBOARD_ROOT}/${dashboard_binary_name})
else()
set(CTEST_BINARY_DIRECTORY ${CTEST_SOURCE_DIRECTORY}-build)
endif()
endif()

if(NOT DEFINED PARAVIEW_DATA_ROOT)
if(DEFINED dashboard_data_name)
set(PARAVIEW_DATA_ROOT ${CTEST_DASHBOARD_ROOT}/${dashboard_data_name})
else()
set(PARAVIEW_DATA_ROOT ${CTEST_SOURCE_DIRECTORY}Data)
endif()
endif()

# Delete source tree if it is incompatible with current VCS.
if(EXISTS ${CTEST_SOURCE_DIRECTORY})
if(NOT EXISTS "${CTEST_SOURCE_DIRECTORY}/.git")
set(vcs_refresh "because it is not managed by git.")
endif()
if(vcs_refresh AND "${CTEST_SOURCE_DIRECTORY}" MATCHES "/ParaView[^/]*")
message("Deleting source tree\n  ${CTEST_SOURCE_DIRECTORY}\n${vcs_refresh}")
file(REMOVE_RECURSE "${CTEST_SOURCE_DIRECTORY}")
endif()
endif()

# Delete data tree if it is incompatible with current VCS.
if(EXISTS ${PARAVIEW_DATA_ROOT})
if(CTEST_GIT_COMMAND)
if(NOT EXISTS "${PARAVIEW_DATA_ROOT}/.git")
set(vcs_refresh "because it is not managed by git.")
endif()
endif()
if(vcs_refresh AND "${PARAVIEW_DATA_ROOT}" MATCHES "/ParaViewData[^/]*")
message("Deleting ParaViewData tree\n  ${CTEST_SOURCE_DIRECTORY}\n${vcs_refresh}")
file(REMOVE_RECURSE "${PARAVIEW_DATA_ROOT}")
endif()
endif()

if(NOT EXISTS "${PARAVIEW_DATA_ROOT}")
get_filename_component(_name "${PARAVIEW_DATA_ROOT}" NAME)
execute_process(
COMMAND "${CTEST_GIT_COMMAND}" clone "${dashboard_git_data_url}"
"${PARAVIEW_DATA_ROOT}")
endif()


message("!!CTEST_CHECKOUT_COMMAND ${CTEST_CHECKOUT_COMMAND}")

# Support initial checkout if necessary.
if(NOT EXISTS "${CTEST_SOURCE_DIRECTORY}/.git"
AND NOT DEFINED CTEST_CHECKOUT_COMMAND)
get_filename_component(_name "${CTEST_SOURCE_DIRECTORY}" NAME)
execute_process(COMMAND ${CTEST_GIT_COMMAND} --version OUTPUT_VARIABLE output)
string(REGEX MATCH "[0-9]+\\.[0-9]+\\.[0-9]+(\\.[0-9]+(\\.g[0-9a-f]+)?)?" GIT_VERSION "${output}")
if(NOT "${GIT_VERSION}" VERSION_LESS "1.6.5")
# Have "git clone -b <branch>" option.
set(git_branch_new "-b ${dashboard_git_branch}")
set(git_branch_old)
else()
# No "git clone -b <branch>" option.
set(git_branch_new)
set(git_branch_old "-b ${dashboard_git_branch} origin/${dashboard_git_branch}")
endif()

# Generate an initial checkout script.
set(ctest_checkout_script ${CTEST_DASHBOARD_ROOT}/${_name}-init.cmake)

############################## File #######################################
file(WRITE ${ctest_checkout_script} "# git repo init script for ${_name}
execute_process(
COMMAND \"${CTEST_GIT_COMMAND}\" clone -n ${git_branch_new} -- \"${dashboard_git_url}\"
\"${CTEST_SOURCE_DIRECTORY}\"
)
if(EXISTS \"${CTEST_SOURCE_DIRECTORY}/.git\")
execute_process(
COMMAND \"${CTEST_GIT_COMMAND}\" config core.autocrlf ${dashboard_git_crlf}
WORKING_DIRECTORY \"${CTEST_SOURCE_DIRECTORY}\"
)
execute_process(
COMMAND \"${CTEST_GIT_COMMAND}\" checkout ${git_branch_old}
WORKING_DIRECTORY \"${CTEST_SOURCE_DIRECTORY}\"
)
execute_process(
COMMAND \"${CTEST_GIT_COMMAND}\" submodule init
WORKING_DIRECTORY \"${CTEST_SOURCE_DIRECTORY}\"
)
execute_process(
COMMAND \"${CTEST_GIT_COMMAND}\" submodule update --
WORKING_DIRECTORY \"${CTEST_SOURCE_DIRECTORY}\"
)
endif()
")
############################## File #######################################

set(CTEST_CHECKOUT_COMMAND "\"${CMAKE_COMMAND}\" -P \"${ctest_checkout_script}\"")
# CTest delayed initialization is broken, so we put the
# CTestConfig.cmake info here.
set(CTEST_NIGHTLY_START_TIME "01:00:00 UTC")
set(CTEST_DROP_METHOD "http")
set(CTEST_DROP_SITE "www.cdash.org")
set(CTEST_DROP_LOCATION "/CDash/submit.php?project=ParaView")
set(CTEST_DROP_SITE_CDASH TRUE)
endif()

#-----------------------------------------------------------------------------

# Send the main script as a note.
list(APPEND CTEST_NOTES_FILES
"${CTEST_SCRIPT_DIRECTORY}/${CTEST_SCRIPT_NAME}"
"${CMAKE_CURRENT_LIST_FILE}"
)

# Check for required variables.
foreach(req
CTEST_CMAKE_GENERATOR
CTEST_SITE
CTEST_BUILD_NAME
)
if(NOT DEFINED ${req})
message(FATAL_ERROR "The containing script must set ${req}")
endif()
endforeach(req)

# Print summary information.
foreach(v
CTEST_SITE
CTEST_BUILD_NAME
CTEST_SOURCE_DIRECTORY
CTEST_BINARY_DIRECTORY
CTEST_CMAKE_GENERATOR
CTEST_BUILD_CONFIGURATION
CTEST_CVS_COMMAND
CTEST_GIT_COMMAND
CTEST_CHECKOUT_COMMAND
CTEST_SCRIPT_DIRECTORY
CTEST_USE_LAUNCHERS
PARAVIEW_DATA_ROOT
)
set(vars "${vars}  ${v}=[${${v}}]\n")
endforeach(v)
message("Dashboard script configuration:\n${vars}\n")

# CMake 2.8.0 and 2.8.1 do not properly update submodules. Write out a shell script
# that invokes git submodule upate when updating the parent repository.
if("${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION}.${CMAKE_PATCH_VERSION}" LESS 2.8.2)
if(UNIX)
configure_file(${dashboard_self_dir}/gitmod.sh.in
${CTEST_DASHBOARD_ROOT}/gitmod.sh
@ONLY)
set(CTEST_GIT_COMMAND ${CTEST_DASHBOARD_ROOT}/gitmod.sh)
else()
configure_file(${dashboard_self_dir}/gitmod.bat.in
${CTEST_DASHBOARD_ROOT}/gitmod.bat
@ONLY)
set(CTEST_GIT_COMMAND ${CTEST_DASHBOARD_ROOT}/gitmod.bat)
endif()
endif()

# Avoid non-ascii characters in tool output.
set(ENV{LC_ALL} C)

# Helper macro to write the initial cache.
macro(write_cache)
set(cache_build_type "")
set(cache_make_program "")
if(CTEST_CMAKE_GENERATOR MATCHES "Make")
set(cache_build_type CMAKE_BUILD_TYPE:STRING=${CTEST_BUILD_CONFIGURATION})
if(CMAKE_MAKE_PROGRAM)
set(cache_make_program CMAKE_MAKE_PROGRAM:FILEPATH=${CMAKE_MAKE_PROGRAM})
endif()
endif()
file(WRITE ${CTEST_BINARY_DIRECTORY}/CMakeCache.txt "
SITE:STRING=${CTEST_SITE}
BUILDNAME:STRING=${CTEST_BUILD_NAME}
CTEST_USE_LAUNCHERS:BOOL=${CTEST_USE_LAUNCHERS}
DART_TESTING_TIMEOUT:STRING=${CTEST_TEST_TIMEOUT}
PARAVIEW_DATA_ROOT:PATH=${PARAVIEW_DATA_ROOT}
PARAVIEW_DISABLE_VTK_TESTING:BOOL=ON
${cache_build_type}
${cache_make_program}
${dashboard_cache}
")
endmacro(write_cache)

# Start with a fresh build tree.
file(MAKE_DIRECTORY "${CTEST_BINARY_DIRECTORY}")
if(NOT "${CTEST_SOURCE_DIRECTORY}" STREQUAL "${CTEST_BINARY_DIRECTORY}")
message("Clearing build tree...")
ctest_empty_binary_directory(${CTEST_BINARY_DIRECTORY})
endif()

set(dashboard_continuous 0)
if("${dashboard_model}" STREQUAL "Continuous")
set(dashboard_continuous 1)
endif()
if (dashboard_continous_force)
set(dashboard_continuous 1)
endif()

# CTest 2.6 crashes with message() after ctest_test.
macro(safe_message)
if(NOT "${CMAKE_VERSION}" VERSION_LESS 2.8 OR NOT safe_message_skip)
message(${ARGN})
endif()
endmacro()

if(COMMAND dashboard_hook_init)
dashboard_hook_init()
endif()

set(dashboard_done 0)
while(NOT dashboard_done)
if(dashboard_continuous)
set(START_TIME ${CTEST_ELAPSED_TIME})
endif()
set(ENV{HOME} "${dashboard_user_home}")

# Start a new submission.
if(COMMAND dashboard_hook_start)
dashboard_hook_start()
endif()
ctest_start(${ctest_start_model} TRACK ${dashboard_track})

# Always build if the tree is fresh.
set(dashboard_fresh 0)
if(NOT EXISTS "${CTEST_BINARY_DIRECTORY}/CMakeCache.txt")
set(dashboard_fresh 1)
safe_message("Starting fresh build...")
write_cache()
endif()

# VTKData is not a submodule at this time, so use ctest_update
if(DEFINED VTK_DATA_ROOT)
ctest_update(SOURCE "${VTK_DATA_ROOT}")
endif()

# ParaViewData is not a submodule at this time, so use ctest_update
if(DEFINED PARAVIEW_DATA_ROOT)
ctest_update(SOURCE "${PARAVIEW_DATA_ROOT}")
endif()

# Look for updates.
ctest_update(SOURCE ${CTEST_SOURCE_DIRECTORY}
RETURN_VALUE count)
safe_message("Found ${count} changed files")

# fetch from pvvtk next sha1's
execute_process(
COMMAND "${CTEST_GIT_COMMAND}" fetch pvvtk
WORKING_DIRECTORY "${CTEST_SOURCE_DIRECTORY}/VTK"
)

# get newest submodule info
execute_process(
COMMAND "${CTEST_GIT_COMMAND}" submodule update --init
WORKING_DIRECTORY "${CTEST_SOURCE_DIRECTORY}"
)

if(dashboard_fresh OR NOT dashboard_continuous OR count GREATER 0)
  ctest_configure()
  ctest_submit(PARTS Update Configure Notes RETRY_COUNT 3 RETRY_DELAY 300)
  ctest_read_custom_files(${CTEST_BINARY_DIRECTORY})

  if(COMMAND dashboard_hook_build)
    dashboard_hook_build()
  endif()
  ctest_build(APPEND)
  ctest_submit(PARTS Build RETRY_COUNT 3 RETRY_DELAY 300)

  if(COMMAND dashboard_hook_test)
    dashboard_hook_test()
  endif()
  ctest_test(INCLUDE_LABEL "PARAVIEW" ${CTEST_TEST_ARGS} APPEND)
  ctest_submit(PARTS Test RETRY_COUNT 3 RETRY_DELAY 300)
  set(safe_message_skip 1) # Block furhter messages

  if(dashboard_do_coverage)
    ctest_coverage()
    ctest_submit(PARTS Coverage RETRY_COUNT 3 RETRY_DELAY 300)
  endif()
  if(dashboard_do_memcheck)
    ctest_memcheck()
    ctest_submit(PARTS MemCheck RETRY_COUNT 3 RETRY_DELAY 300)
  endif()
  if(COMMAND dashboard_hook_submit)
    dashboard_hook_submit()
  endif()
  if(COMMAND dashboard_hook_end)
    dashboard_hook_end()
  endif()
endif()

if(dashboard_continuous AND NOT dashboard_disable_loop)
# Delay until at least 5 minutes past START_TIME
ctest_sleep(${START_TIME} 300 ${CTEST_ELAPSED_TIME})
if(${CTEST_ELAPSED_TIME} GREATER 57600)
set(dashboard_done 1)
endif()
else()
# Not continuous, so we are done.
set(dashboard_done 1)
endif()
endwhile()


