# upgrade Bash to version 4, for associative array support
if [[ ${BASH_VERSINFO[0]} < 4 ]]; then
    brew install bash
    /usr/local/bin/bash -uxe $0
    exit $?
fi

#!/bin/bash
set -e -x
export MACOSX_DEPLOYMENT_TARGET="10.13"
# Clear existing locks
#rm -rf /usr/local/var/homebrew/locks
# Update homebrew cant disable this yet, -y and --quiet do nothing
#brew update-reset

# Install Miniconda
curl -s -O https://repo.continuum.io/miniconda/Miniconda3-4.6.14-MacOSX-x86_64.sh;
bash Miniconda3-4.6.14-MacOSX-x86_64.sh -b -p $HOME/anaconda;
export PATH=$HOME/anaconda/bin:$PATH;
conda config --add channels conda-forge;
conda config --add channels omnia;
conda install -yq conda\<=4.3.34;
#####################################################################
# WORKAROUND FOR BUG WITH ruamel_yaml
# "conda config --add channels omnia/label/dev" will fail if ruamel_yaml > 0.15.54
# This workaround is in place to avoid this failure until this is patched
# See: https://github.com/conda/conda/issues/7672
conda install --yes ruamel_yaml==0.15.53 conda\<=4.3.34;
#####################################################################
conda config --add channels omnia/label/dev
conda install -yq conda-env conda-build==2.1.7 jinja2 anaconda-client;
conda config --show;
conda clean -tipsy;

# Do this step last to make sure conda-build, conda-env, and conda updates come from the same channel first


#export INSTALL_CUDA=`./conda-build-all --dry-run -- openmm`
export INSTALL_OPENMM_PREREQUISITES=true
if [ "$INSTALL_OPENMM_PREREQUISITES" = true ] ; then
    # Install OpenMM dependencies that can't be installed through
    # conda package manager (doxygen + CUDA)
    brew install https://raw.githubusercontent.com/Homebrew/homebrew-core/5b680fb58fedfb00cd07a7f69f5a621bb9240f3b/Formula/doxygen.rb

    # Install CUDA
    # Use solution from https://github.com/JuliaGPU/CUDAapi.jl/pull/81/files
    declare -A installers
    installers["7.5"]="http://developer.download.nvidia.com/compute/cuda/7.5/Prod/local_installers/cuda_7.5.27_mac.dmg"
    installers["8.0"]="https://developer.nvidia.com/compute/cuda/8.0/Prod2/local_installers/cuda_8.0.61_mac-dmg"
    installers["9.0"]="https://developer.nvidia.com/compute/cuda/9.0/Prod/local_installers/cuda_9.0.176_mac-dmg"
    installers["9.1"]="https://developer.nvidia.com/compute/cuda/9.1/Prod/local_installers/cuda_9.1.128_mac"
    installers["9.2"]="https://developer.nvidia.com/compute/cuda/9.2/Prod/local_installers/cuda_9.2.64_mac"
    installers["10.0"]="https://developer.nvidia.com/compute/cuda/10.0/Prod/local_installers/cuda_10.0.130_mac"
    installers["10.1"]="https://developer.nvidia.com/compute/cuda/10.1/Prod/local_installers/cuda_10.1.105_mac.dmg"
    installer=${installers[$CUDA_VERSION]}
    wget -O cuda.dmg "$installer"

    brew install p7zip
    7z x cuda.dmg
    [[ -f 5.hfs ]] && 7z x 5.hfs

    brew install gnu-tar
    # Install CUDA driver (which contains libcuda.so)
    sudo gtar -x --skip-old-files --exclude='*uninstall*' -f CUDAMacOSXInstaller/CUDAMacOSXInstaller.app/Contents/Resources/payload/cuda_mac_installer_drv.tar.gz -C /
    # Install CUDA toolkit
    sudo gtar -x --skip-old-files --exclude='*uninstall*' -f CUDAMacOSXInstaller/CUDAMacOSXInstaller.app/Contents/Resources/payload/cuda_mac_installer_tk.tar.gz -C /

    # Install latex.
#    echo $PATH
#    export PATH="/Library/TeX/texbin/:/usr/texbin:$PATH:/usr/bin"
#    echo $PATH
#    #brew cask install --no-quarantine basictex
#    #mkdir -p /usr/texbin
#    # Path based on https://github.com/caskroom/homebrew-cask/blob/master/Casks/basictex.rb location
#    # .../texlive/{YEAR}basic/bin/{ARCH}/{Location of actual binaries}
#    # Sym link them to the /usr/texbin folder in the path
#    export TLREPO=http://ctan.math.utah.edu/ctan/tex-archive/systems/texlive/tlnet
#    #ln -s /usr/local/texlive/*basic/bin/*/* /usr/texbin/
#    sudo tlmgr --repository=$TLREPO update --self
#    sleep 5
#    sudo tlmgr --persistent-downloads --repository=$TLREPO install \
#        titlesec framed threeparttable wrapfig multirow collection-fontsrecommended hyphenat xstring \
#        fncychap tabulary capt-of eqparbox environ trimspaces \
#        cmap fancybox titlesec framed fancyvrb threeparttable \
#        mdwtools wrapfig parskip upquote float multirow hyphenat caption \
#        xstring fncychap tabulary capt-of eqparbox environ trimspaces \
#        varwidth needspace
    # Clean up brew
    #brew cleanup -s
fi;

# Build packages
export CUDA_SHORT_VERSION

# Make sure we have the appropriate channel added
conda config --add channels omnia/label/cuda${CUDA_SHORT_VERSION};
conda config --add channels omnia/label/rc;
conda config --add channels omnia/label/rccuda${CUDA_SHORT_VERSION};
#conda config --add channels omnia/label/beta;
conda config --add channels omnia/label/betacuda${CUDA_SHORT_VERSION};
#conda config --add channels omnia/label/dev;
#conda config --add channels omnia/label/devcuda${CUDA_SHORT_VERSION};

for PY_BUILD_VERSION in "27" "35" "36" "37"; do
#for PY_BUILD_VERSION in "37" "36" "35" "27"; do
    ./conda-build-all -vvv --python $PY_BUILD_VERSION --check-against omnia/label/beta --check-against omnia/label/betacuda${CUDA_SHORT_VERSION} --check-against omnia/label/dev --check-against omnia/label/devcuda${CUDA_SHORT_VERSION} --numpy "1.15" $UPLOAD -- *
done
