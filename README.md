* Travis-CI `linux`and `osx` builds [![Travis Build Status](https://travis-ci.org/omnia-md/conda-dev-recipes.svg?branch=master)](https://travis-ci.org/omnia-md/conda-dev-recipes)

omnia-md/conda-dev-recipes
--------------------------

The development recipes here create conda packages for scientific and numerical software
components associated with the Omnia project. The packages built from these
recipes are shared with the community on [anaconda.org](https://anaconda.org/omnia).

These are development recipes for building packages from the bleeding-edge latest source
versions of selected packages.

Packages are built daily by Azure's Schedules.

To install a development package, use
```bash
conda install -c omnia-dev <package_name>
```
Or to install a specific commit hash, use
```bash
conda install -c omnia-dev <package_name>=<version>=<build_string>
```
For example, to install the Python 3.7, CUDA 7.5 version of `openmm` with git hash 689e2bc, use
```bash
conda install -c omnia-dev openmm=7.4.0=openmm-7.4.0-py37_cuda75_689e2bc_1
```

### Supported versions

Python packages are built against latest two releases of python and python 2.7.
Packages which have a binary dependency on Numpy are built against the latest
two releases of Numpy.

### Building the packages

The recipes here are automatically built using [Azure DevOps](https://azure.microsoft.com/en-us/services/devops/?cdn=disable)
for all platforms. For linux, we use a modified
[Conda-forge Linux Anvil](https://github.com/conda-forge/docker-images/tree/master/linux-anvil) to ensure that the
packages are fully compatible across multiple linux distributions and versions.

To build a package yourself, run `conda build <package_name>`, or
`./conda-build-all ./*` to build multiple packages across each of the
supported Python/Numpy configurations.

### Conda-build-all additional flags

The `conda-build-all` script supports certain flags and modifications to the `meta.yaml` files to help control the 
build environment.

* meta.yaml `extra`: `include_omnia_label {str}`: Allows specifying a specific tag in the Omnia channel to check the package 
    for dependencies and building against.
* meta.yaml `extra`: `scheduled: {bool}`: Flags a recipe to be built in the nightly builds, but will always upload to the `omnia-dev` channel
* meta.yaml `extra`: `force_upload {bool}`: Forces the built recipes to be uploaded, even if they already exist on omnia (normally pre-existing blocks a build)


