mkdir build
pushd build 
conan install .. 

call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat" %WORDSIZE%

cmake .. -G "Ninja"
if %errorlevel% NEQ 0 (
    echo "Cmake cannot configure the project"
    exit /b 1
)
popd

cmake --build build --target all
if %errorlevel% NEQ 0 (
    echo "Cmake cannot build the project"
    exit /b 1
)


cmake --build build --target install
if %errorlevel% NEQ 0 (
    echo "Cmake cannot install the project"
    exit /b 1
)


rem C:\Program Files\Meson\ninja.EXE
rem C:\ProgramData\chocolatey\bin\ninja.exe
rem C:\Program Files (x86)\CMake\bin\cmake.exe