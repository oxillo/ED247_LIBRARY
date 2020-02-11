mkdir build
mkdir install
cd build
#
#cmake_variables=(COMPILER WORDSIZE LIBED247_VERSION DOXYGEN_PATH LCOV_PATH LCOV_EXE GENHTML_EXE GTEST_PATH LIBXML2_PATH XMLLINT_EXE)
#            cmake_variables+=(MINGW_PATH)
#            "SET(WORDSIZE x64)"

echo  "" > _dependencies.cmake

cmake .. -G"Ninja" \
    -DWORDSIZE=x64 \
    -DLIBED247_VERSION=1.0.0 \
    -DLIBXML2_PATH=${MINGW_PREFIX} \
    -DXMLLINT_EXE=xmllint.exe \
    -DLCOV_PATH=${MINGW_PREFIX} \
    -DLCOV_EXE=lcov.exe \
    -DGENHTML_EXE=genhtml.exe \
    -DCMAKE_INSTALL_PREFIX= ../install
cd ..