mkdir build
pushd build 
conan install .. 
set
where ninja
where cmake
where nmake
vcvarsall.bat
cmake .. -G "Ninja"
popd