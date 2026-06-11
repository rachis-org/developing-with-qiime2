(facilitating-installation)=
# Facilitating installation of your plugin for users

(install-in-existing-distro)=
## Installing your plugin on top of an existing QIIME 2 Distribution (recommended)

The easiest way to instruct users to install your plugin in the context of an existing QIIME 2 Distribution is to create a conda environment file that they can use to install a specific distribution of QIIME 2 including your plugin, all while using a single command.

In the top-level directory of your plugin, create the following directory:

```
environment-files/
```

Within this directory, create environment file(s) for current and/or past installable versions of your plugin.
You can name them with a pattern like `<package-name>-rachis-<target-distribution>-<target-epoch>.yml` (for example, `q2-dwq2-rachis-qiime2-2026.4.yml`).

The contents of your environment file should look something like this:

```
channels:
- https://packages.qiime2.org/qiime2/<target-epoch>/<target-distribution>/released
- conda-forge
- bioconda
dependencies:
  - rachis-<target-distribution>
  - pip
  - pip:
    - <package-name>@git+https://github.com/<owner>/<repository-name>.git@<target-branch>
```

With the following terms defined:
- `<target-epoch>`: the QIIME 2 epoch that your plugin should be installed under (e.g., `2026.1` or `2026.4`)
- `<target-distribution>`: the QIIME 2 distribution that your plugin should be installed under (e.g., `qiime2` or `moshpit`)
- `<package-name>`: your plugin's package name (e.g., `q2-dwq2`)
- `<owner>`: the github organization your plugin is hosted under, or your personal github account name
- `<repository-name>`: the name of your plugin repository on GitHub (this often will be the same as your plugin's package name, e.g., `q2-dwq2`)
- `<target-branch>` (optional): the relevant branch that users should be utilizing to install your plugin - if not specified, this will default to your repository's *Default branch* (e.g., `main`). If you don't include this, you should leave off the `@` symbol following `.git`

``````{Note}
In the examples provided in this guide, we utilize the `released` channel for our QIIME 2 packages (i.e. `packages.qiime2.org/qiime2/<target-epoch>/<target-distribution>/released`).
If you are interested in creating and/or sharing instructions for installing a version of your plugin that relies on one of our development environments (meaning the current development cycle environment prior to an official release version), you'll want to target the `passed` channel of that particular distribution.
Here's an example of what this channel might look like (as of June 2026, prior to the 2026.7 release):
```
https://packages.qiime2.org/qiime2/2026.7/qiime2/passed
```
``````

Using the above guidelines, you can provide the following install instructions for your users:
```
conda env create \
 -n <target-epoch>-<package-name> \
 -f https://raw.githubusercontent.com/<owner>/<repository-name>/<target-branch>/environment-files/<package-name>-rachis-<target-distribution>-<target-epoch>.yml
```

Again, you'll fill in the values enclosed in the `<` and `>` brackets.
As above, `<target-branch>` is the branch that your users should install, but in this case it is required.
(Often this will be `main`.)

This method also provides a familiar way for users to install new versions of your plugin.
By maintaining release branches on your repository, you can create a new environment file for each release that targets the corresponding release branch.

As an example, your branch structure could look like the following:

```
release-2026.4 # the 2026.4 release of your plugin
main # your main branch, usually what would be installed for a "development" installation
```

You could then have environment files and install instructions for these different branches that look like the following (in this example, `qiime2` is the target distribution):

`````{tab-set}

````{tab-item} release-2026.4

Environment file: `q2-dwq2-rachis-qiime2-2026.4.yml`

```
channels:
- https://packages.qiime2.org/qiime2/2026.4/qiime2/released
- conda-forge
- bioconda
dependencies:
  - rachis-qiime2
  - pip
  - pip:
    - q2-dwq2@git+https://github.com/caporaso-lab/q2-dwq2.git@release-2026.4
```

Install instructions:

```
conda env create \
 -n q2-dwq2 \
 -f https://raw.githubusercontent.com/caporaso-lab/q2-dwq2.git/main/environment-files/q2-dwq2-rachis-qiime2-2026.4.yml
```

````

````{tab-item} main (development)

Environment file: `q2-dwq2-rachis-qiime2-development.yml`

```
channels:
- https://packages.qiime2.org/qiime2/2026.7/qiime2/passed
- conda-forge
- bioconda
dependencies:
  - rachis-qiime2
  - pip
  - pip:
    - q2-dwq2@git+https://github.com/caporaso-lab/q2-dwq2.git
```

Install instructions:

```
conda env create \
 -n q2-dwq2 \
 -f https://raw.githubusercontent.com/caporaso-lab/q2-dwq2.git/main/environment-files/q2-dwq2-rachis-qiime2-development.yml
```

````
`````

In the above examples, the `main` branch location houses all of the environment files, regardless of which release they're associated with.
This is reflected by each `conda env create` command referring to a URL like `https://raw.githubusercontent.com/.../main/environment-files/...`.
We recommend having all of your environment files available on a single branch, which makes finding and referencing them easier.

## Installing your plugin using the Tiny Distribution and any custom required plugins

If you are working on a plugin that is not compatible with one of our existing distributions but depends on some plugins in those distributions, you can utilize a similar approach to that outlined [above](install-in-existing-distro) but with a more customized environment file.
As a reminder, while this approach is fairly straightforward to implement, **we don't recommend this if the option presented above is possible for your plugin** as this will be more difficult for us to assist you with and for you to help your users troubleshoot.
As long as you are aware of these limitations and wish to proceed in this way, you can follow the steps below.

Start by following the same suggestions presented above for creating an `environment-files/` directory and naming your environment file.
We'll put some different content in the environment file(s) this time.

As an example, the contents of an environment file for a plugin that depends on the `q2-feature-table` and `q2-composition` plugins would look something like this:

```
channels:
- https://packages.qiime2.org/qiime2/2026.4/tiny/released
- https://packages.qiime2.org/qiime2/2026.4/qiime2/released
- conda-forge
- bioconda
dependencies:
  - rachis-tiny
  - q2-feature-table
  - q2-composition
  - pip
  - pip:
    - q2-dwq2@git+https://github.com/caporaso-lab/q2-dwq2.git@release-2026.4
```

In this example, the plugin being developed (`q2-dwq2`) requires `q2-feature-table` and `q2-composition`, but we're assuming that it's not compatible with the entire qiime2 distribution.
Because this plugin still requires a basic QIIME 2 environment, the `rachis-tiny` distribution will be installed from the first channel listed.
The `q2-feature-table` and `q2-composition` dependencies are not part of the `rachis-tiny` distribution however, but are a part of the qiime2 distribution.
Therefore the second channel listed is the `qiime2` channel.
We then list the dependencies as `rachis-tiny` (the `tiny` distribution) and then the two additional plugins.
Those are all followed by the installation of the `q2-dwq2` plugin, as in the previous example.

Generally, your customized environment files will be structured as follows:
```
channels:
- https://packages.qiime2.org/qiime2/<target-epoch>/tiny/released
- https://packages.qiime2.org/qiime2/<target-epoch>/<target-distribution>/released
- conda-forge
- bioconda
dependencies:
  - rachis-tiny
  - <other-plugin-dependency-1>
  - <other-plugin-dependency-2>
  - pip
  - pip:
    - q2-dwq2@git+https://github.com/caporaso-lab/q2-dwq2.git@<target-branch>
```

In this case, `<other-plugin-dependency-1>` and `<other-plugin-dependency-2>` are plugins that are distributed through `<target-distribution>`.
Note that if you have plugin dependencies that span multiple distributions, you'll need to include each distribution's channel in your environment file.
