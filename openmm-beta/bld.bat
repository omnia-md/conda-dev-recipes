mkdir build
cd build

cmake.exe .. -G "NMake Makefiles JOM" ^
    -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
    -DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%" ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DBUILD_TESTING=OFF ^
    -DCUDA_TOOLKIT_ROOT_DIR="C:/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v%CUDA_VER%" ^
    -DOPENCL_INCLUDE_DIR="C:/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v%CUDA_VER%/include" ^
    -DOPENCL_LIBRARY="C:/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v%CUDA_VER%/lib/x64/OpenCL.lib" ^
    || goto :error

jom -j %NUMBER_OF_PROCESSORS% || goto :error
jom -j %NUMBER_OF_PROCESSORS% install || goto :error
jom -j %NUMBER_OF_PROCESSORS% PythonInstall || goto :error

:: :: Workaround overlinking warnings (do not do this in Windows and save some MB)
:: copy %SP_DIR%\simtk\openmm\_openmm* %LIBRARY_BIN% || goto :error
:: copy %LIBRARY_LIB%\OpenMM* %LIBRARY_BIN% || goto :error
:: copy %LIBRARY_LIB%\plugins\OpenMM* %LIBRARY_BIN% || goto :error

:: Better location for examples
mkdir %LIBRARY_PREFIX%\share\openmm || goto :error
move %LIBRARY_PREFIX%\examples %LIBRARY_PREFIX%\share\openmm || goto :error

goto :EOF

:error
echo Failed with error #%errorlevel%.
exit /b %errorlevel%
