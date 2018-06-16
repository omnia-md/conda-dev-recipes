#!/bin/bash
echo "CUDA_VERSION: $CUDA_VERSION"
echo "PATH: $PATH"

set -e
set -x

# Activate
echo "Activating compiler toolchain"
source /opt/docker/bin/entrypoint_source
echo "PATH: $PATH"


# Make sure we are using the
echo "Adding conda to path"
export PATH="/opt/conda/bin:$PATH"
echo "PATH: $PATH"

#conda config --add channels omnia
# Move the conda-forge channel to the top
# Cannot just append omnia otherwise default would have higher priority
#conda config --add channels conda-forge
#conda install -yq conda\<=4.3.34
conda config --add channels omnia/label/dev
#conda install -yq conda-build==2.1.17 jinja2 anaconda-client

/io/conda-build-all -vvv --python $PY_BUILD_VERSION $UPLOAD -- /io/*

#mv /anaconda/conda-bld/linux-64/*tar.bz2 /io/ || true
