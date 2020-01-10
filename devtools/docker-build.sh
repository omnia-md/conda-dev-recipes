#!/bin/bash

set -xeuo pipefail
export PYTHONUNBUFFERED=1
export FEEDSTOCK_ROOT="${FEEDSTOCK_ROOT:-/io}"
export RECIPE_ROOT="${RECIPE_ROOT:-/io/openmm}"
export CI_SUPPORT="${FEEDSTOCK_ROOT}/.conda_configs"
export CONFIG_FILE="${CI_SUPPORT}/${CONFIG}.yaml"
export CONDA_BLD_PATH="${HOME}/build_artifacts"
mkdir -p ${CONDA_BLD_PATH}

cat >~/.condarc <<CONDARC

conda-build:
 root-dir: ${CONDA_BLD_PATH}

CONDARC

# Channels are added in FIFO order here
conda config --add channels omnia
conda config --add channels conda-forge

conda install --yes conda conda-build anaconda-client

conda config --set show_channel_urls true
conda config --set auto_update_conda false
conda config --set add_pip_as_python_dependency false

conda info
conda config --show-sources
conda list --show-channel-urls


${FEEDSTOCK_ROOT}/conda-build-all $CBA_FLAGS -m ${CONFIG_FILE} -- /io/*

