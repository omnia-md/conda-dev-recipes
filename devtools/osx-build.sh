#!/bin/bash
set -e -x

# Update homebrew
brew update -y --quiet

# Install latex.
brew tap -y --quiet Caskroom/cask;
brew install -y --quiet pv
sudo brew cask install -y --quiet mactex | pv > mactex-install.out
export PATH="/usr/texbin:${PATH}:/usr/bin"

# Install Miniconda
curl -s -O https://repo.continuum.io/miniconda/Miniconda3-latest-MacOSX-x86_64.sh;
bash Miniconda3-latest-MacOSX-x86_64.sh -b -p $HOME/anaconda;
export PATH=$HOME/anaconda/bin:$PATH;
conda config --add channels omnia;
conda install -yq conda-build jinja2 anaconda-client;

# Install OpenMM dependencies that can't be installed through
# conda package manager (doxygen + CUDA)
brew install -y --quiet doxygen
curl -O -s http://developer.download.nvidia.com/compute/cuda/7.5/Prod/network_installers/mac/x86_64/cuda_mac_installer_tk.tar.gz
curl -O -s http://developer.download.nvidia.com/compute/cuda/7.5/Prod/network_installers/mac/x86_64/cuda_mac_installer_drv.tar.gz
sudo tar -zxf cuda_mac_installer_tk.tar.gz -C /;
sudo tar -zxf cuda_mac_installer_drv.tar.gz -C /;
rm -f cuda_mac_installer_tk.tar.gz cuda_mac_installer_drv.tar.gz


# Build packages
./conda-build-all $CONDA_BUILD_ALL_FLAGS *;
