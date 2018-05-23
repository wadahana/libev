#!/bin/bash

platform=`uname -s |tr [A-Z] [a-z]`
arch=`uname -m | tr [A-Z] [a-z]`

path=$(cd "$(dirname "$0")"; pwd)
build_path="${path}/BUILD"
target_path="${path}/${platform}"

mkdir -p "${build_path}"
mkdir -p "${target_path}/include"
mkdir -p "${target_path}/lib"

function build_libev() {
    libev_build_path="${build_path}/${platform}-${arch}.build"
    libev_install_path="${build_path}/${platform}-${arch}.target"
    libev_src_path="${path}/src"
    if [ ! -f $libev_src_path/configure ] ; then 
        pushd $libev_src_path
        chmod 755 autogen.sh
        ./autogen.sh
        popd
    fi
    mkdir -p "${libev_build_path}"
    pushd "${libev_build_path}"
    if [ -f Makefile ]; then
        make distclean
    fi
    $libev_src_path/configure --prefix=$libev_install_path
    make
    make install
    popd
    cp -R ${libev_install_path}/lib/*.a "${target_path}/lib/"
    cp -R ${libev_install_path}/include/* "${target_path}/include/"
}

echo -e "build libev."

build_libev



