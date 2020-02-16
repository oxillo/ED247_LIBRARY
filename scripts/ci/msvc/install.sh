#!/bin/bash

#Download LibXML2 source
VER=2.9.10
wget -nv https://gitlab.gnome.org/GNOME/libxml2/-/archive/v$VER/libxml2-v$VER.zip

unzip libxml2-v$VER.zip
mv libxml2-v$VER libxml2
rm libxml2-v$VER.tar.gz

pushd libxml2/win32
cscript configure.js compiler=msvc
nmake /f Makefile.msvc
popd

#Download Ninja
wget -nv https://github.com/ninja-build/ninja/releases/download/v1.10.0/ninja-win.zip
unzip ninja-win.zip