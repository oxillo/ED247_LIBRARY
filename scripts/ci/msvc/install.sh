#!/bin/bash

VER=2.9.10

wget -nv https://gitlab.gnome.org/GNOME/libxml2/-/archive/v$VER/libxml2-v$VER.tar.gz

tar xzf libxml2-v$VER.tar.gz
mv libxml2-v$VER libxml2
rm libxml2-v$VER.tar.gz

pushd libxml2/win32
cscript configure.js compiler=msvc
popd