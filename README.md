* Travis-CI `linux`and `osx` builds [![Travis Build Status](https://travis-ci.org/omnia-md/conda-dev-recipes.svg?branch=master)](https://travis-ci.org/omnia-md/conda-dev-recipes)
* Appveyor-CI `windows` builds [![Appveyor Build status](https://ci.appveyor.com/api/projects/status/tsjbbgtobpbb4xps?svg=true)](https://ci.appveyor.com/project/jchodera/conda-dev-recipes)

omnia-md/conda-dev-recipes
--------------------------

The development recipes here create conda packages for scientific and numerical software
components associated with the Omnia project. The packages built from these
recipes are shared with the community on [anaconda.org](https://anaconda.org/omnia).

These are development recipes for building packages from the bleeding-edge latest source
versions of selected packages.

Packages are built twice daily by [the Travis CI cron trigger](http://traviscron.pythonanywhere.com/).

To install a development package
```
# Add the Omnia channel
$ conda config --add channels omnia

conda install openmm-dev
```


### Supported versions

Python packages are built against latest two releases of python and python 2.7.
Packages which have a binary dependency on Numpy are built against the latest
two releases of Numpy.

### Building the packages

The recipes here are automatically built using [Appveyor-CI](http://www.appveyor.com/)
and [Travis-CI](https://travis-ci.org/). For linux, we use the
[Holy Build Box](http://phusion.github.io/holy-build-box/) to ensure that the
packages are fully compatible accross multiple linux distributions and versions.

To build a package yourself, run `conda build <package_name>`, or
`./conda-build-all ./*` to build multiple packages accross each of the
supported Python/Numpy configurations.
