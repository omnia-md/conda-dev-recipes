#!/bin/bash
echo "CUDA_VERSION: $CUDA_VERSION"
echo "PATH: $PATH"

set -e
set -x

conda config --add channels conda-forge
conda config --add channels omnia
conda config --add channels omnia/label/dev

#conda install -yq conda\<=4.3.34
#conda install -yq conda-build==2.1.17 jinja2 anaconda-client

source /opt/docker/bin/entrypoint_source

/io/conda-build-all -vvv --python $PY_BUILD_VERSION $UPLOAD -- /io/*

#mv /anaconda/conda-bld/linux-64/*tar.bz2 /io/ || true
