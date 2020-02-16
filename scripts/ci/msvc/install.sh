#!/bin/bash

choco install cmake
choco install ninja
choco install conan

conan install .

#Download LibXML2 source
VER=2.9.10
wget -nv https://gitlab.gnome.org/GNOME/libxml2/-/archive/v$VER/libxml2-v$VER.zip

unzip libxml2-v$VER.zip
dir
mv libxml2-v$VER libxml2
rm libxml2-v$VER.zip

pushd libxml2/win32
cscript configure.js compiler=msvc
nmake /f Makefile.msvc
popd

