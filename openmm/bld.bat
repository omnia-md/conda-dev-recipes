mkdir build
cd build

cmake.exe .. -G "NMake Makefiles JOM" ^
    -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
    -DCMAKE_PREFIX_PATH="%LIBRARY_PREFIX%" ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DBUILD_TESTING=OFF ^
    -DCUDA_TOOLKIT_ROOT_DIR="%LIBRARY_BIN%" ^
    || goto :error

:: Re-add above when CUDA is available
::    -DCUDA_TOOLKIT_ROOT_DIR="%LIBRARY_BIN%" ^

jom -j %NUMBER_OF_PROCESSORS% || goto :error
jom -j %NUMBER_OF_PROCESSORS% install || goto :error
jom -j %NUMBER_OF_PROCESSORS% PythonInstall || goto :error

:: Workaround overlinking warnings
copy %SP_DIR%\simtk\openmm\_openmm* %LIBRARY_BIN% || goto :error
copy %LIBRARY_LIB%\OpenMM* %LIBRARY_BIN% || goto :error
copy %LIBRARY_LIB%\plugins\OpenMM* %LIBRARY_BIN% || goto :error

:: Better location for examples
mkdir %LIBRARY_PREFIX%\share\openmm || goto :error
move %LIBRARY_PREFIX%\examples %LIBRARY_PREFIX%\share\openmm || goto :error

goto :EOF

:error
echo Failed with error #%errorlevel%.
exit /b %errorlevel%

REM :: Use python version to select which Visual Studio to use
REM :: For win-64, we'll need more, since those are separate compilers
REM :: Build in subdirectory.
REM mkdir build
REM cd build

REM set CMAKE_FLAGS=-DCMAKE_INSTALL_PREFIX=%PREFIX%
REM set CMAKE_FLAGS=%CMAKE_FLAGS% -DCMAKE_BUILD_TYPE=Release
REM set CMAKE_FLAGS=%CMAKE_FLAGS% -DOPENMM_BUILD_PME_PLUGIN=ON
REM set CMAKE_FLAGS=%CMAKE_FLAGS% -DFFTW_LIBRARY=%LIBRARY_LIB%\libfftwf-3.3.lib
REM set CMAKE_FLAGS=%CMAKE_FLAGS% -DFFTW_INCLUDES=%LIBRARY_INC%
REM set CMAKE_FLAGS=%CMAKE_FLAGS% -DCMAKE_BUILD_TYPE=Release
REM :: set CMAKE_FLAGS=%CMAKE_FLAGS% -DOPENCL_INCLUDE_DIR="C:/Program Files (x86)/AMD APP SDK/3.0/include"
REM :: set CMAKE_FLAGS=%CMAKE_FLAGS% -DOPENCL_LIBRARY="C:/Program Files (x86)/AMD APP SDK/3.0/lib/x86_64/OpenCL.lib"

REM cmake -G "NMake Makefiles" %CMAKE_FLAGS% ..

REM :: jom all DoxygenApiDocs :: sphinxpdf
REM jom install
REM if errorlevel 1 exit 1


REM set OPENMM_INCLUDE_PATH=%PREFIX%\include
REM set OPENMM_LIB_PATH=%PREFIX%\lib
REM cd python
REM %PYTHON% setup.py install
REM cd ..

REM :: Build manuals
REM mkdir openmm-docs
REM move %PREFIX%\docs\* openmm-docs
REM move openmm-docs %PREFIX%\docs\openmm
REM jom sphinxpdf
REM move sphinx-docs\userguide\latex\*.pdf %PREFIX%\docs\openmm
REM move sphinx-docs\developerguide\latex\*.pdf %PREFIX%\docs\openmm

REM :: Put examples into an appropriate subdirectory.
REM mkdir %PREFIX%\share\openmm
REM move %PREFIX%\examples %PREFIX%\share\openmm

REM :: Put docs into a subdirectory.
REM :: cd %PREFIX%\docs
REM :: mkdir openmm
REM :: move *.html openmm
REM :: move *.pdf openmm
REM :: move api-* openmm

REM if errorlevel 1 exit 1
