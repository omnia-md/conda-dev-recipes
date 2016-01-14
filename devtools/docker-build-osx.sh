#!/bin/bash

curl -s -O https://repo.continuum.io/miniconda/Miniconda3-latest-MacOSX-x86_64.sh;
bash Miniconda3-latest-MacOSX-x86_64.sh -b -p $HOME/anaconda;
export PATH=$HOME/anaconda/bin:$PATH;
conda config --add channels omnia;
conda install -yq conda-build jinja2 anaconda-client;

#if ! ./conda-build-all --dry-run openmm; then
brew install -y doxygen;
curl -O -s http://developer.download.nvidia.com/compute/cuda/7_0/Prod/network_installers/mac/cuda_mac_installer_tk.tar.gz ;
curl -O -s http://developer.download.nvidia.com/compute/cuda/7_0/Prod/network_installers/mac/cuda_mac_installer_drv.tar.gz ;
sudo tar -zxf cuda_mac_installer_tk.tar.gz -C /;
sudo tar -zxf cuda_mac_installer_drv.tar.gz -C /;
#fi

if [[ "${TRAVIS_PULL_REQUEST}" == "false" ]]; then
  ./conda-build-all $UPLOAD * || true;
else
  ./conda-build-all $UPLOAD *;
fi;
