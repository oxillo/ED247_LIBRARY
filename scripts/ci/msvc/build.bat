mkdir build
pushd build 
conan install .. 
set
where ninja
where cmake
where nmake
dir "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build"
call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat" %WORDSIZE%
cmake .. -G "Ninja"
popd

rem C:\Program Files\Meson\ninja.EXE
rem C:\ProgramData\chocolatey\bin\ninja.exe
rem C:\Program Files (x86)\CMake\bin\cmake.exe