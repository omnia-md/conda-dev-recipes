#!/bin/bash
set -e
set -x
conda config --set channel_priority false
conda config --add channels omnia
conda install -yq conda-build jinja2 anaconda-client

#DEBUG
gcc --version
g++ --version
echo $CC
echo $CXX
readlink -f `which cc`
readlink -f `which c++`


/io/conda-build-all -vvv --python $PY_BUILD_VERSION $UPLOAD -- /io/*

#mv /anaconda/conda-bld/linux-64/*tar.bz2 /io/ || true
