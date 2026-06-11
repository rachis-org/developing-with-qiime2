(share-on-qiime2-library)=
# Distribute plugins on QIIME 2 Library

Distributing your plugin on the QIIME 2 Library is a great way to share your plugin with the QIIME 2 community, and we are regularly adding new functionality to make "the Library" more useful for both users and developers.

Having your plugin listed on the Library requires a few specific things, but as long as these are in place it's a simple process.

## Requirements before requesting the addition of your plugin to the Library

````{sidebar}
```{figure} ../../_static/github-about-example.png
---
name: github-about-example
---
The *About* section of a GitHub repository.
```
````

1. Your plugin's source code must be hosted in a GitHub repository.
   See [](share-on-github) if you need help with this.
1. You must have a brief description of your plugin in the *About* field for the repository.
   The *About* field will be on the top-right of your repository's front page (see {numref}`github-about-example`).
   This will be used as the short description for your plugin in Library and should be about 300 characters long at the most.
1. You must have a top-level `README.md` in your repository, and this file must be written in [GitHub-flavored Markdown](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax).
   This will be rendered as Markdown on Library and should give a detailed description of your plugin and what it does.
   If your `README.md` file references any resources (such as images) using paths relative to the root of your repository, these resources WILL NOT LOAD on the Library.
   Only resources referenced with absolute URLs will load.
1. Conda environment files must be provided for installation, and they must meet a few formatting requirements.
   This is the highest bar to clear to have your plugin be compatible with the QIIME 2 Library.
   * Your repository must include environment YAML files for each QIIME 2 release you support using the naming scheme `<plugin-name>-rachis-<distro>-<epoch>.yml`.
     These files must be located in your repository's `/environment-files` folder.
     More detailed instructions on how to do this are provided in [](facilitating-installation).
     One feature that we're working on adding to the Library is a system that can automatically submit PRs against your plugin repository to add new environment files when new QIIME 2 releases come out, to help you keep your plugin up-to-date with QIIME 2 - more on this soon!
   * Your plugin must be fully installable via these environment files with no extra steps required.
     If this isn't possible, you can still distribute your plugin in other ways (e.g., see [](share-on-github)), but it won't work with the QIIME 2 Library.
   * Your environment files must *not* contain a `name` field.
     The install instructions that are created by the Library will include a name for the environment.

## Requesting addition of your plugin to the Library

Once you have met the above requirements, open a pull request against the [library-plugins](https://github.com/qiime2/library-plugins) GitHub repository.
Your pull request should add a `<my-plugin-name>.yml` file to the `plugins` directory in that repository containing the following key-value pairs:

```
owner: <repository-owner>
name: <repository-name>
branch: <target-branch>
docs: <latest-documentation-url>
```

This [pull request](https://github.com/qiime2/library-plugins/pull/3/files) illustrates the addition of a plugin to the library in a single atomic commit, and can be used as an example for how to create your pull request.

```{warning}
Your plugin must be compliant with the above specifications for us to merge your pull request.
```
