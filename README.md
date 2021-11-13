 [![Anaconda-Server Badge](https://anaconda.org/omnia-dev/openmm/badges/installer/conda.svg)](https://conda.anaconda.org/omnia-dev) [![Build Status](https://dev.azure.com/OmniaMD/conda-dev-recipes/_apis/build/status/omnia-md.conda-dev-recipes?branchName=master)](https://dev.azure.com/OmniaMD/conda-dev-recipes/_build/latest?definitionId=1&branchName=master)

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
conda install -c conda-forge -c omnia-dev -c omnia <package_name>
```

You can use channel labels to request a specific variant, like CUDA versions. For example, for CUDA 11.0:

```bash
conda install -c conda-forge -c omnia-dev/label/cuda110 -c omnia openmm
```

Default CUDA version is currently 11.0

### Build matrix

Python packages are built against:

* Python 3.6, 3.7, 3.8, 3.9
* CUDA 8.0, 9.0, 9.1, 9.2, 10.0, 10.1, 10.2, 11.0
* Linux-64, MacOS, Windows

#### Adding new Python versions

To add a new Python version:
* Edit `.conda_configs/gen_confs.py` to extend `PYTHONS` with the new Python version
* Re-run `gen_confs.py` to generate new YAML files
* Commit the new YAML files to the repository
* Update this `README.md` with the newly supported Python versions
* Edit YAML files in `.azure-pipelines/` to extend build matrix with new Python version

### Building the packages

The recipes here are automatically built using [Azure DevOps](https://azure.microsoft.com/en-us/services/devops/?cdn=disable)
for all platforms. For linux, we use a modified
[Conda-forge Linux Anvil](https://github.com/conda-forge/docker-images/tree/master/linux-anvil) to ensure that the
packages are fully compatible across multiple linux distributions and versions. These images are maintained in [`omnia-md/cf-docker-images`](https://github.com/omnia-md/cf-docker-images).

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
