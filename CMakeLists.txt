###############################################################################
# The MIT Licence                                                             #
#                                                                             #
# Copyright (c) 2019 Airbus Operations S.A.S                                  #
#                                                                             #
# Permission is hereby granted, free of charge, to any person obtaining a     #
# copy of this software and associated documentation files (the "Software"),  #
# to deal in the Software without restriction, including without limitation   #
# the rights to use, copy, modify, merge, publish, distribute, sublicense,    #
# and/or sell copies of the Software, and to permit persons to whom the       #
# Software is furnished to do so, subject to the following conditions:        #
#                                                                             #
# The above copyright notice and this permission notice shall be included     #
# in all copies or substantial portions of the Software.                      #
#                                                                             #
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  #
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,    #
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE #
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER      #
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING     #
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER         #
# DEALINGS IN THE SOFTWARE.                                                   #
###############################################################################

CMAKE_MINIMUM_REQUIRED(VERSION 3.12)
cmake_policy(SET CMP0048 NEW) #Use VERSION data from PROJECT() 
set(CMAKE_MODULE_PATH ${CMAKE_BINARY_DIR})
message(${CMAKE_BINARY_DIR})

PROJECT(ED247_LIBRARY VERSION 1.0.0) 

# Hardcoded options
SET(FT_PERFOS_MASTER_WITH_GPROF FALSE) # Enable compilation of FT_PERFOS_MASTER with GPROF compatible options
SET(LIBED247_VERBOSE_DEBUG FALSE) # Enable verbose debug logging


# User configuration
OPTION(ENABLE_LCOV "Generate LCOV report" OFF)



SET( LIBXML2_PATH "" CACHE PATH "LIBXML2 root path" )
SET( GTEST_PATH "" CACHE PATH "GTest root path" )
SET( LCOV_PATH "" CACHE PATH "Lcov root path" )
SET( DOXYGEN_PATH "" CACHE PATH "Doxygen root path" )

# Print some useful information to screen
STRING(TIMESTAMP CMAKE_CONFIGURE_DATE UTC)
MESSAGE("##############")
MESSAGE("# System Name [${CMAKE_SYSTEM_NAME}]")
MESSAGE("# Processor   [${CMAKE_SYSTEM_PROCESSOR}]")
MESSAGE("# Compiler    [${COMPILER}]")
MESSAGE("# Word size   [${WORDSIZE}]")
MESSAGE("# Project     [${PROJECT_NAME}]")
MESSAGE("# Directory   [${CMAKE_SOURCE_DIR}]")
MESSAGE("# Version     [${ED247_LIBRARY_VERSION}]")
MESSAGE("# Date        [${CMAKE_CONFIGURE_DATE}]")
MESSAGE("##############")

# LIBXML2
MESSAGE("Checking for LibXml2 ...")
FIND_PACKAGE(LIBXML2 REQUIRED GLOBAL)
#            PATHS ${LIBXML2_PATH} ${CMAKE_BINARY_DIR})

# xmllint.exe not detected as part of libXML2 package; try to detect it differently
IF( LIBXML2_XMLLINT_EXECUTABLE )
    SET(XMLLINT_PROGRAM ${LIBXML2_XMLLINT_EXECUTABLE})
ELSE()
    FIND_PROGRAM(XMLLINT_PROGRAM NAMES xmllint xmllint.exe 
             HINTS ${LIBXML2_PATH}/bin)
ENDIF()

# Deal with exe dependencies
FIND_PROGRAM(XMLLINT_PROGRAM NAMES xmllint xmllint.exe 
             HINTS ${LIBXML2_PATH}/bin)
MESSAGE("# xmllint     ${XMLLINT_PROGRAM}")

IF( ${ENABLE_LCOV} )
    FIND_PROGRAM(LCOV_PROGRAM NAMES lcov lcov.exe 
             HINTS ${LCOV_PATH}/bin )
    MESSAGE("# lcov        ${LCOV_PROGRAM}")
    
    FIND_PROGRAM(GENHTML_PROGRAM NAMES genhtml genhtml.exe 
             HINTS ${LCOV_PATH}/bin )
    MESSAGE("# genhtml     ${GENHTML_PROGRAM}")
ENDIF(${ENABLE_LCOV})
MESSAGE("##############")

# Fail configuration if all exe were not found
IF( NOT( XMLLINT_PROGRAM ) OR 
    ( ENABLE_LCOV AND NOT (LCOV_PROGRAM AND GENHTML_PROGRAM) )   )
    MESSAGE(FATAL_ERROR "Some required executables were not found - see above for details")
ENDIF() 




# Deal with libraries dependencies
SET(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/src/cmake")


# GTest
FIND_PACKAGE(GTest REQUIRED GLOBAL)
#            PATHS ${GTEST_PATH})
if(GTest_FOUND AND NOT TARGET GTest::gtest)
    add_library(GTest::gtest INTERFACE IMPORTED)
    set_target_properties(GTest::gtest PROPERTIES
        INTERFACE_LINK_LIBRARIES "gtest"
    )
    add_library(GTest::gtest_main INTERFACE IMPORTED)
    set_target_properties(GTest::gtest_main PROPERTIES
        INTERFACE_LINK_LIBRARIES "gtest_main"
    )
    add_library(GTest::gmock INTERFACE IMPORTED)
    set_target_properties(GTest::gmock PROPERTIES
        INTERFACE_LINK_LIBRARIES "gmock"
    )
    add_library(GTest::gmock_main INTERFACE IMPORTED)
    set_target_properties(GTest::gmock_main PROPERTIES
        INTERFACE_LINK_LIBRARIES "gmock_main"
    )
endif()



#[==[
get_cmake_property(_variableNames VARIABLES)
list (SORT _variableNames)
foreach (_variableName ${_variableNames})
    message(STATUS "${_variableName}=${${_variableName}}")
endforeach()
#]==]



#FIND_PACKAGE(pkgconfig REQUIRED)
#MESSAGE("Checking for GTest ...")
#pkg_check_modules (PC_GTEST REQUIRED gtest_main)
#pkg_check_modules (PC_GMOCK REQUIRED gmock_main)
#IF(PC_GTEST_FOUND AND PC_GMOCK_FOUND)
#    MESSAGE("## Using googleTest from pkg-config")
#    SET(GTEST_LIBRARIES ${PC_GMOCK_LIBRARIES})
#    SET(GTEST_INCLUDE_DIRS ${PC_GMOCK_INCLUDE_DIRS})
#ELSE()
#    INCLUDE(GoogleTest)
#    SET(CMAKE_SIZEOF_VOID_P_MEM ${CMAKE_SIZEOF_VOID_P})
#    IF(${WORDSIZE} MATCHES "x86")
#        SET(CMAKE_SIZEOF_VOID_P "4")
#    ENDIF(${WORDSIZE} MATCHES "x86")
#    
#    SET(CMAKE_SIZEOF_VOID_P ${CMAKE_SIZEOF_VOID_P_MEM})
#    SET(GTEST_LIBRARIES GTest::gtest GTest::gtest_main GTest::gmock GTest::gmock_main)
#ENDIF()


# Compilation flags and options
IF(COMPILER MATCHES "^msvc.*")
    SET(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} /NODEFAULTLIB:MSVCRT")
    SET(CMAKE_INSTALL_UCRT_LIBRARIES TRUE)
    SET(CMAKE_INSTALL_DEBUG_LIBRARIES TRUE)
    SET(CMAKE_INSTALL_SYSTEM_RUNTIME_DESTINATION "lib")
    INCLUDE(InstallRequiredSystemLibraries)
ELSE(COMPILER MATCHES "^msvc.*")
    SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g -std=c11 -O0 -Wall -Wextra -Wno-unused-parameter -Wno-unknown-pragmas -fvisibility=hidden")
    SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g -std=c++11 -O0 -Wall -Wextra -Wno-unused-parameter -Wno-unknown-pragmas -fvisibility=hidden")
    IF(WORDSIZE MATCHES "x86")
        SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -m32")
        SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -m32")
        SET(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -m32")
    ENDIF(WORDSIZE MATCHES "x86")
    IF(COMPILER MATCHES "^gcc.*")
        SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -D_GNU_SOURCE -rdynamic")
        SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -D_GNU_SOURCE -rdynamic")
    ELSE()
        SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -static-libgcc -static-libstdc++")
        SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -static-libgcc -static-libstdc++")
    ENDIF()
ENDIF(COMPILER MATCHES "^msvc.*")

IF(LIBED247_VERBOSE_DEBUG)
    MESSAGE("# Enable verboe debug mode")
    ADD_DEFINITIONS(-DLIBED247_VERBOSE_DEBUG)
ENDIF(LIBED247_VERBOSE_DEBUG)

# Install
SET(CMAKE_INSTALL_RPATH "$ORIGIN:$ORIGIN/../../lib")

# Subdirectories
ADD_SUBDIRECTORY(src)
ADD_SUBDIRECTORY(tests)
ADD_SUBDIRECTORY(doc)

INSTALL(FILES LICENSE.md DESTINATION .)

