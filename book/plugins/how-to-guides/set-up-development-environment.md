(setup-dev-environment)=
# Set up your development environment

This how-to guide describes how to install and set up a QIIME 2 development environment.
The development environment you create will be suitable for creating new or contributing to existing QIIME 2 plugins or interfaces, or contributing to the development of the QIIME 2 framework.

```{warning}
QIIME 2 support for Windows is restricted to Windows Subsystem for Linux (WSL).
The QIIME 2 development team doesn't have much experience developing QIIME 2 in the context of Windows.
If you're comfortable with creating development environments with WSL, we expect that it should work just fine.
If you expect that you might need help setting up your development environment, we'll be able to provide better assistance if you're developing on a Linux or macOS system.
```

## Install Prerequisites

{{ miniconda_url }} provides the ``conda`` environment and package manager, and is currently the only supported way to install QIIME 2.
Follow the instructions for downloading and installing Miniconda.

```{note}
We are experimentally supporting [miniforge](https://github.com/conda-forge/miniforge) instead of Miniconda.
miniforge use is more permissive (notably it doesn't ever use Anaconda's `defaults` channel).
Consider installing and using miniforge instead of Miniconda, and let us know on [the Forum](https://forum.qiime2.org) if you run into any issues.
```

After installing and opening a new terminal, make sure you're running the latest version of ``conda``:

```bash
conda update conda
```

## Install the latest development version of the QIIME 2 "Tiny Distribution" and activate its environment

The QIIME 2 "Tiny Distribution" is a minimal set of QIIME 2 functionality for building and using plugins through the QIIME 2 command line, and is intended for use by developers who want a minimal QIIME 2 environment to work in.

```{note}
We recommend starting your development with the "Tiny Distribution", unless you specifically need plugins that are installed in other QIIME 2 distributions, such as the Amplicon Distribution or MOSHPIT (previously known as the Metagenome Distribution), in which case see [](other-distros).
```

```{note}
The commands on this page add the current date to the conda environment names, which can be helpful for managing development environments.
QIIME 2 keeps track of the versions of all dependencies in data provenance (including specific git commits for packages in the QIIME 2 ecosystem) so that information -- not the conda environment name -- is the definitive source of specific versions that were used to generate a result.
Things change relatively quickly with development environments, so it doesn't hurt to remove old ones and create new ones regularly (e.g., every few weeks).
```


`````{tab-set}
````{tab-item} macOS
```bash
__Q2DEV_ENV_NAME=q2dev-tiny-$(date "+%Y-%m-%d")
conda env create -n $__Q2DEV_ENV_NAME --file https://raw.githubusercontent.com/qiime2/distributions/dev/latest/passed/qiime2-tiny-macos-latest-conda.yml
conda activate $__Q2DEV_ENV_NAME
```
````

````{tab-item} Linux
```bash
__Q2DEV_ENV_NAME=q2dev-tiny-$(date "+%Y-%m-%d")
conda env create -n $__Q2DEV_ENV_NAME --file https://raw.githubusercontent.com/qiime2/distributions/dev/latest/passed/qiime2-tiny-ubuntu-latest-conda.yml
conda activate $__Q2DEV_ENV_NAME
```
````

````{tab-item} macOS (Apple Silicon)
```bash
__Q2DEV_ENV_NAME=q2dev-tiny-$(date "+%Y-%m-%d")
CONDA_SUBDIR=osx-64 conda env create -n $__Q2DEV_ENV_NAME --file https://raw.githubusercontent.com/qiime2/distributions/dev/latest/passed/qiime2-tiny-macos-latest-conda.yml
conda activate $__Q2DEV_ENV_NAME
conda config --env --set subdir osx-64
```
````
`````

## Test your new environment

After activating your new environment, you can test it by running:

```bash
qiime info
```

You should see something like the following, though the version numbers you'll see will be different:

```
System versions
Python version: 3.10.14
QIIME 2 release: 2025.4
QIIME 2 version: 2025.4.0.dev0+18.g9414a65
q2cli version: 2025.4.0.dev0+21.g97e80cc

Installed plugins
metadata: 2025.4.0.dev0+8.g66139ab
types: 2025.4.0.dev0+16.g229da69

Application config directory
/Users/q2-user/miniforge3/envs/q2dev-tiny-2025-04-30/var/q2cli

Config
Config Source: /Users/q2-user/miniforge3/envs/q2dev-tiny-2025-04-30/etc/qiime2_config.toml

Getting help
To find help and learning resources, visit https://qiime2.org.
To get help with configuring and/or understanding QIIME 2 parallelization, visit https://use.qiime2.org/en/latest/references/parallel-configuration.html
```

The versions listed here, for QIIME 2, q2cli, q2-types, and q2-metadata are development versions as defined by [versioneer](https://github.com/python-versioneer/python-versioneer), and these indicate that you're working in a QIIME 2 development environment (as opposed to working with a specific release version of QIIME 2).

At this stage you should now have a working development environment - time to start hacking!

## Next steps

### Building your first plugin

If you're creating your first plugin, you can now move on to [](plugin-tutorial-intro).

### Contributing to existing plugins
If you want to make changes to the QIIME 2 framework, q2cli, or any existing plugins, follow these steps (for the sake of this example, we will focus on the example of contributing to developing ``q2-types``):

```bash
# Grab the package source from the relevant source repository.
git clone https://github.com/qiime2/q2-types
cd q2-types

# Install any additional build-time dependencies needed for this project.
# Check ci/recipe/meta.yaml in any QIIME 2 repository under the QIIME 2 GitHub
# organization for build or test requirements. For example, see
# https://github.com/qiime2/q2-types/blob/dev/ci/recipe/meta.yaml
conda install pytest flake8

# Install local source in "development mode", and build any package assets.
make dev

# Run package tests to ensure that everything is okay.
make test
```

(other-distros)=
## Installing other QIIME 2 distributions

### Amplicon distribution

`````{tab-set}
````{tab-item} macOS
```bash
__Q2DEV_ENV_NAME=q2dev-amplicon-$(date "+%Y-%m-%d")
conda env create -n $__Q2DEV_ENV_NAME --file https://raw.githubusercontent.com/qiime2/distributions/dev/latest/passed/qiime2-amplicon-macos-latest-conda.yml
conda activate $__Q2DEV_ENV_NAME
```
````

````{tab-item} Linux
```bash
__Q2DEV_ENV_NAME=q2dev-amplicon-$(date "+%Y-%m-%d")
conda env create -n $__Q2DEV_ENV_NAME --file https://raw.githubusercontent.com/qiime2/distributions/dev/latest/passed/qiime2-amplicon-ubuntu-latest-conda.yml
conda activate $__Q2DEV_ENV_NAME
```
````

````{tab-item} macOS (Apple Silicon)
```bash
__Q2DEV_ENV_NAME=q2dev-amplicon-$(date "+%Y-%m-%d")
CONDA_SUBDIR=osx-64 conda env create -n $__Q2DEV_ENV_NAME --file https://raw.githubusercontent.com/qiime2/distributions/dev/latest/passed/qiime2-amplicon-macos-latest-conda.yml
conda activate $__Q2DEV_ENV_NAME
conda config --env --set subdir osx-64
```
````
`````

### MOSHPIT (previously known as the *Metagenome distribution*)

`````{tab-set}
````{tab-item} macOS
```bash
__Q2DEV_ENV_NAME=moshpit-dev-$(date "+%Y-%m-%d")
conda env create -n $__Q2DEV_ENV_NAME --file https://raw.githubusercontent.com/qiime2/distributions/dev/latest/passed/qiime2-moshpit-macos-latest-conda.yml
conda activate $__Q2DEV_ENV_NAME
```
````

````{tab-item} Linux
```bash
__Q2DEV_ENV_NAME=moshpit-dev-$(date "+%Y-%m-%d")
conda env create -n $__Q2DEV_ENV_NAME --file https://raw.githubusercontent.com/qiime2/distributions/dev/latest/passed/qiime2-moshpit-ubuntu-latest-conda.yml
conda activate $__Q2DEV_ENV_NAME
```
````

````{tab-item} macOS (Apple Silicon)
```bash
__Q2DEV_ENV_NAME=moshpit-dev-$(date "+%Y-%m-%d")
CONDA_SUBDIR=osx-64 conda env create -n $__Q2DEV_ENV_NAME --file https://raw.githubusercontent.com/qiime2/distributions/dev/latest/passed/qiime2-moshpit-macos-latest-conda.yml
conda activate $__Q2DEV_ENV_NAME
conda config --env --set subdir osx-64
```
````
`````
