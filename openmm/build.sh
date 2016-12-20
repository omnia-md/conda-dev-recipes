#!/bin/bash

# Fix hbb issues
ln -s /opt/rh/devtoolset-2/root/usr/lib/gcc/x86_64-CentOS-linux/ /opt/rh/devtoolset-2/root/usr/lib/gcc/x86_64-redhat-linux
ln -s /opt/rh/devtoolset-2/root/usr/include/c++/4.8.2/x86_64-CentOS-linux/ /opt/rh/devtoolset-2/root/usr/include/c++/4.8.2/x86_64-redhat-linux

# Save anaconda path
export PYTHON=`which python`
export PYTHONBIN=`dirname $PYTHON`

# holy build box paths
export HBB_PREFIX="/hbb_shlib"
export PATH=$HBB_PREFIX/bin:/hbb/bin:$PATH
export C_INCLUDE_PATH=$HBB_PREFIX/include
export CPLUS_INCLUDE_PATH=$HBB_PREFIX/include
export LIBRARY_PATH=$HBB_PREFIX/lib
export PKG_CONFIG_PATH=$HBB_PREFIX/lib/pkgconfig:/usr/lib/pkgconfig

export CPPFLAGS="-I$HBB_PREFIX/include"
export LDPATHFLAGS="-L$HBB_PREFIX/lib"
export MINIMAL_CFLAGS="-g -O3 $CPPFLAGS"

export CFLAGS="$MINIMAL_CFLAGS"
export CXXFLAGS="$MINIMAL_CFLAGS"
export LDFLAGS="$LDPATHFLAGS -static-libstdc++"
export STATICLIB_CFLAGS="$MINIMAL_CFLAGS -fPIC"
export STATICLIB_CXXFLAGS="$MINIMAL_CFLAGS -fPIC"
export SHLIB_CFLAGS="$MINIMAL_CFLAGS"
export SHLIB_CXXFLAGS="$MINIMAL_CFLAGS"
export SHLIB_LDFLAGS="$LDPATHFLAGS -static-libstdc++"

# Clang paths
export CLANG_PREFIX="/opt/clang"
export PATH=$CLANG_PREFIX/bin:$PATH

# Add back anaconda path at front
export PATH=$PYTHONBIN:$PATH

# OpenMM paths
CMAKE_FLAGS="-DCMAKE_INSTALL_PREFIX=$PREFIX -DBUILD_TESTING=OFF"

# Ensure we build a release
CMAKE_FLAGS+=" -DCMAKE_BUILD_TYPE=Release"

CUDA_VERSION="8.0"

if [[ "$OSTYPE" == "linux-gnu" ]]; then
    CUDA_PATH="/usr/local/cuda-${CUDA_VERSION}"
    CMAKE_FLAGS+=" -DCUDA_CUDART_LIBRARY=${CUDA_PATH}/lib64/libcudart.so"
    CMAKE_FLAGS+=" -DCUDA_NVCC_EXECUTABLE=${CUDA_PATH}/bin/nvcc"
    CMAKE_FLAGS+=" -DCUDA_SDK_ROOT_DIR=${CUDA_PATH}/"
    CMAKE_FLAGS+=" -DCUDA_TOOLKIT_INCLUDE=${CUDA_PATH}/include"
    CMAKE_FLAGS+=" -DCUDA_TOOLKIT_ROOT_DIR=${CUDA_PATH}/"
    CMAKE_FLAGS+=" -DCMAKE_CXX_FLAGS=-I/usr/include/nvidia/"
    # Use clang 3.8.1 inside omnia-build-box docker image
    CMAKE_FLAGS+=" -DCMAKE_C_COMPILER=$CLANG_PREFIX/bin/clang -DCMAKE_CXX_COMPILER=$CLANG_PREFIX/bin/clang++"
    # AMD APP SDK 3.0 OpenCL
    CMAKE_FLAGS+=" -DOPENCL_INCLUDE_DIR=/opt/AMDAPPSDK-3.0/include/"
    CMAKE_FLAGS+=" -DOPENCL_LIBRARY=/opt/AMDAPPSDK-3.0/lib/x86_64/libOpenCL.so"
    # Don't build tests or examples
    CMAKE_FLAGS+=" -DOPENMM_BUILD_CUDA_TESTS=off"
    CMAKE_FLAGS+=" -DOPENMM_BUILD_OPENCL_TESTS=off"
    #CMAKE_FLAGS+=" -DOPENMM_BUILD_EXAMPLES=off"
    # CUDA OpenCL
    #CMAKE_FLAGS+=" -DOPENCL_INCLUDE_DUR=${CUDA_PATH}/include/"
    #CMAKE_FLAGS+=" -DOPENCL_LIBRARY=${CUDA_PATH}/lib64/libOpenCL.so"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    CMAKE_FLAGS+=" -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++"
    CMAKE_FLAGS+=" -DCMAKE_OSX_DEPLOYMENT_TARGET=10.9"
    CMAKE_FLAGS+=" -DCUDA_SDK_ROOT_DIR=/Developer/NVIDIA/CUDA-${CUDA_VERSION}"
    CMAKE_FLAGS+=" -DCUDA_TOOLKIT_ROOT_DIR=/Developer/NVIDIA/CUDA-${CUDA_VERSION}"
    CMAKE_FLAGS+=" -DCMAKE_OSX_SYSROOT=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.9.sdk"
fi

# Generate API docs
CMAKE_FLAGS+=" -DOPENMM_GENERATE_API_DOCS=ON"

# Set location for FFTW3 on both linux and mac
CMAKE_FLAGS+=" -DFFTW_INCLUDES=$PREFIX/include"
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    CMAKE_FLAGS+=" -DFFTW_LIBRARY=$PREFIX/lib/libfftw3f.so"
    CMAKE_FLAGS+=" -DFFTW_THREADS_LIBRARY=$PREFIX/lib/libfftw3f_threads.so"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    CMAKE_FLAGS+=" -DFFTW_LIBRARY=$PREFIX/lib/libfftw3f.dylib"
    CMAKE_FLAGS+=" -DFFTW_THREADS_LIBRARY=$PREFIX/lib/libfftw3f_threads.dylib"
fi

# Build in subdirectory and install.
mkdir build
cd build
cmake .. $CMAKE_FLAGS
make -j$CPU_COUNT all
make -j$CPU_COUNT install PythonInstall

# Clean up paths for API docs.
mkdir openmm-docs
mv $PREFIX/docs/* openmm-docs
mv openmm-docs $PREFIX/docs/openmm

# Build PDF manuals
make -j$CPU_COUNT sphinxpdf
mv sphinx-docs/userguide/latex/*.pdf $PREFIX/docs/openmm/
mv sphinx-docs/developerguide/latex/*.pdf $PREFIX/docs/openmm/

# Put examples into an appropriate subdirectory.
if [ -d examples ]; then
    mkdir $PREFIX/share/openmm/
    mv $PREFIX/examples $PREFIX/share/openmm/
fi
