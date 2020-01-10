#!/bin/bash

# Channels are added in FIFO order here
conda config --add channels omnia
conda config --add channels conda-forge

conda update --yes conda conda-build anaconda-client

chmod +x /io/conda-build-all

/io/conda-build-all $CBA_FLAGS -m /conda_configs/$CONFIG.yaml -- /io/*

