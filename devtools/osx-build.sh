#!/usr/bin/env bash

set -x

echo -e "\n\nInstalling a fresh version of Miniforge."

MINIFORGE_URL="https://github.com/conda-forge/miniforge/releases/latest/download"
MINIFORGE_FILE="Miniforge3-MacOSX-x86_64.sh"
curl -L -O "${MINIFORGE_URL}/${MINIFORGE_FILE}"
bash $MINIFORGE_FILE -b

echo -e "\n\nConfiguring conda."

source ${HOME}/miniforge3/etc/profile.d/conda.sh
conda activate base

echo -e "\n\nInstalling conda-forge-ci-setup=3 and conda-build."
conda install -n base --quiet --yes conda-forge-ci-setup=3 'conda-build>=3.19.2,<=3.20.4' pip

echo -e "\n\nSetting up the condarc and mangling the compiler."
setup_conda_rc ./ ./recipe ./.conda_configs/${CONFIG}.yaml
mangle_compiler ./ ./recipe .conda_configs/${CONFIG}.yaml

echo -e "\n\nMangling homebrew in the CI to avoid conflicts."
/usr/bin/sudo mangle_homebrew
/usr/bin/sudo -k

echo -e "\n\nRunning the build setup script."
source run_conda_forge_build_setup

set -e

echo -e "\n\nSome more conda configuration"
conda config --add channels omnia
conda config --add channels conda-forge

conda info --all
conda config --show-sources
conda list --show-channel-urls

echo -e "\n\nRunning conda-build-all"
python conda-build-all $CBA_FLAGS -m .conda_configs/${CONFIG}.yaml -- recipes/*/