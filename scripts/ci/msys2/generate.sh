mkdir build
mkdir install
cd build
cmake .. -G"Ninja" \
    -DWORDSIZE=x64 \
    -DLIBED247_VERSION=1.0.0 \
    -DLIBXML2_PATH=${MINGW_PREFIX} \
    -DXMLLINT_EXE=xmllint.exe \
    -DLCOV_PATH=${MINGW_PREFIX} \
    -DLCOV_EXE=lcov.exe \
    -DGENHTML_EXE=genhtml.exe \
    -DCMAKE_INSTALL_PREFIX= install
cd ..