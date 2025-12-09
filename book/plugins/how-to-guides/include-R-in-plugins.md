(howto-incorporate-r-software)=
# How to Incorporate R Software into a Plugin
Whether you have existing software written in the R programming language that you wish to integrate into a QIIME 2 plugin, or you are more comfortable writing R than writing Python, there are ways to seamlessly use R behind the scenes while retaining all the advantages of a fully functioning QIIME 2 plugin. In this guide we will cover the techniques for doing so, along with important considerations that should be made along the way.

## The Two Main Approahces: Separated or Embedded
### The Separated Approach
The are two different high-level approaces to including R software in a plugin. The first, which we'll refer to as the separated approach, integrates R software either by storing raw R source code in the plugin or by including a dependency on R software, and using a standardized interface such as the shell to invoke the software. There is little to no interaction between the Python software and the R software, besides the invocation of the latter by the former. Another defining feature of the separated approach is that the interaction with the R software is higher-level, and usually involves well-defined and mature APIs. This approach is appropriate when one wishes to make use of pre-existing, stand-alone R packages, for example.

As a concrete example of this approach we will refer to the `q2-dada2` plugin, which can be visited [here](https://github.com/qiime2/q2-dada2). DADA2 is an R package that denoises raw sequencing data. It is fully self-sufficient and does not depend on other software to function, the QIIME 2 plugin or otherwise. To make it available to QIIME 2 users, the following steps were followed.

First, the DADA2 dependency was specified in the `conda-recipe/meta.yaml` file. See the documentation about QIIME 2 plugin package structures [here](https://develop.qiime2.org/en/latest/plugins/explanations/package-structure.html#plugin-package-explanation) for more information. The DADA2 software has a conda package available through [bioconductor](https://www.bioconductor.org) which greatly simplifies the process of dependency installation. Conda packages should always be the preffered method of dependency installation. However, of course not all R software packages that one might wish to use will have a conda package available. Alternative ways of packaging R dependencies is discussed below.

Next, an R script was created by the plugin developers wherein the various DADA2 R functions are called as specified by the over-arching QIIME 2 action. This R script was written for two reasons. First, DADA2 does not have a command line interface that can be called directly from a shell instance within Python. Second, even if DADA2 did have a command line interface, it would likely have still been desirable to have the more granular control over DADA2's function that is afforded by calling them in the R language itself. This R script is located in `q2_dada2/assets/run_dada.R`. This `assets/` directory is where any such plugin-specific R source code should be placed. The R script is written so as to be callable from the command line and uses the `optparse` R package to allow parameterization when being called. The R script is then called in Python using the `subprocess` Python standard library function. An example of such a call and the various parameters being passed to the R script can be seen in the `_denoise_single` function in the `q2_dada2/_denoise.py` file.

Input data is passed to the DADA2 software in two ways. Simple parameters to functions such as a base pair position, or the name of a type of algorithm, are passed as parameters to the R script as discussed earlier. Large data, such as the sequences to be denoised, have to be handed over using the filesystem. Thus the Python software places the sequences in a location and format expected by the DADA2 software. The output data is handled similiarly; the Python software finds the output sequences in the locaton specified by DADA2 and processes them into the format that it requires. The specifics for transferring data that is in a format and location that the Python plugin software controls into a format and location that ones R software expects will vary. However, common patterns include using temporary directories and files with the `tempfile` Python standard library module and passing filepaths from the Python software to the R software, and back.

### The Embedded Approach
The embedded approach refers in essence to interacting with R software directly and repeatedly, from Python. The tool that will be discussed here that allows one to do this is the [rpy2 software](https://rpy2.github.io). Rpy2 is a python package that allows users to seamlessly call R software from within python by running an R interpreter in the background, translating Python API calls into R, and returning the results back into the Python interpreter.

Where the separated approach is best suited for stand-alone, mature R software that is interfaced with relatively seldomly and in a well-defined manner, the embedded approach allows a more interactive and "scripting" like experience. This is because rpy2 offers a vast set of tools for calling R code, including a functionality to execute any arbitrary R expression, from within Python. See the rpy2 documentation for details. It's important to note however that rpy2 is equally as capable of interfacing with mature APIs of standalone R packages, and can be used to do so without writing any R code.

As a concrete example of this approach, we'll refer to the `q2-qsip2` plugin, which can be visited [here](https://github.com/caporaso-lab/q2-qsip2). This plugin wraps the qSIP2 R package, which is available [here](https://github.com/jeffkimbrel/qSIP2). The qSIP2 package allows users to analyze the results of quantitative [stable isotope probing](https://en.wikipedia.org/wiki/Stable-isotope_probing) projects. The embedded approach was considered more desirable in this case because the qSIP2 package is less mature than e.g. DADA2, and was still under development at the time of creating the plugin. Such software packages are less likely to have stable APIs and so being able to interface with the package at a fine-grained level is an important ability that rpy2 gives us. Furthermore, such software is more likely to have bugs or small pieces of missing functionality. Here again, the embedded approach is advantageous in that it lets us write small amounts of R code to patch gaps in functionality, directly in Python. Such gaps in functionality can be dealt with on the fly instead of needing separately maintained R scripts.

The rpy2 library can greatly simplify data passing between Python and R in certain situations. Whereas in the separated approach complex or large data must be passed using the filesystem explicitly, rpy2 has built-in ways of converting common Python representations of certain data types to their R equivalents, and back again. A great example of this is the dataframe type: rpy2 can convert most `pandas` dataframes to an equivalent R `data.frame` and back, with only a simple context manager. An example of this can be seen [here](https://github.com/caporaso-lab/q2-qsip2/blob/ca3fef02aa717efd42f03d113ccdd46bd8ee2140/q2_qsip2/workflow.py#L108). The rpy2 library also automatically converts all primitive and many collection data types between the two languages.


### Examples of When One Approach is Best
Below are some examples of when one might prefer using one approach over the other.

**Separated**
- When wrapping mature R packages.
- When wrapping R software that has a command line interface that you wish to use.
- When you are more comfortable writing R than Python.
- When you want the QIIME 2 plugin itself (excluding any included R software) to be as minimal as possible.
- When you know R and don't have time to learn `rpy2`.

**Embedded**
- When using ad hoc R software that requires significant back-and-forth between it and your plugin code.
- When using many different pieces of R software.
- When you are more comfortable writing Python than R.
- When you want to reduce the complexity that arises from maintaining code written in two different programming languages.

## How to Include R Dependencies in QIIME 2 Plugins
### Conda Packages
As noted above, by the far most preferrable option is to use conda packages when they are available for the R software that you wish to include as a dependency of your plugin. To see whether an R package is available as a conda package your can search for it on [anaconda.org](https://anaconda.org). For example navigating here and entering "dada2" into the "search packages" search bar shows that the DADA2 package is available from the "bioconda" channel under the name "bioconductor-dada2". With this information we can now easily add DADA2 as a dependency to our plugin. First, we navigate to `conda-recipe/meta.yaml` and then we add `bioconductor-dada2` under the `run` section of the `requirements` section.

```yaml
requirements:
  run:
  - python {{ python }}
  - biom-format {{ biom_format }}
  - bioconductor-dada2
```

This informs conda that the DADA2 package is a requirement that the package needs to execute properly. This means conda will install it at the same time the python package representing the plugin is installed. Note that only conda packages that are hosted either by the `bioconda` or by the `conda-forge` channels can be included in this fashion.

### When a Conda Package is Not Available
Not all R software is available as a conda package. Recently developed R software, smaller/niche R software, and R software that isn't commonly used outside of the R ecosystem are especially unlikely to have available conda packages. When this is the case there are a couple of ways forward.

One way is to build a conda package for the R software that you wish to include as a dependency. This approach keeps the QIIME 2 plugin installation process as simple as posssible and has the additional benefit that the R package becomes avilable to others as a conda package. However, this can be a complex process, so it will not be discussed further here. Documentation of this process is available [here](https://docs.conda.io/projects/conda-build/en/latest/user-guide/tutorials/building-conda-packages.html).

The other way is to include the necessary shell commands for installing the R dependency in the Makefile of the plugin. This a flexible approach in that one can add any shell command that results in the R dependency being installed, including e.g. `Rscript -e "install.packages..."`, `git clone ...`, and so on. As an example of this approach we'll refer again to the `q2-qsip2` plugin. In the Makefile of that plugin, which can be viewed [here](https://github.com/caporaso-lab/q2-qsip2/blob/ca3fef02aa717efd42f03d113ccdd46bd8ee2140/Makefile#L16), we can see that underneath the `install` target we install the qSIP2 R package using the `devtools` library's `install_github` function, via the `Rscript` shell command.
An important consideration that needs to be made when creating such an installation command is that any shell command given in the `install` target must be guaranteed to be available on the installer's (user's) system, or the dependency will not be able to be installed and the plugin will not be usable. A downside to this approach is that an additional step will be needed to install your plugin, namely the step where the user runs `make install`.

## Testing
Special considerations need to made for testing when R software is included in a plugin. Generally speaking, any R software that is tested elsewhere (e.g. in a package that is being included as a dependency) does not need to be retested in the plugin. However, any R software that is written specifically for the plugin, or any R software that is being migrated into a plugin for ongoing maintenance should be tested in the plugin. Tests written in R should be called through the `test` target in the Makefile, using whatever shell command is necessary to do so. Tests written in python should be done so using `pytest` in the typical testing locations, with no Makefile modifications necessary.
