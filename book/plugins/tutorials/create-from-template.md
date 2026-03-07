(plugin-from-template)=
# Create your plugin from a template

The easiest way to create a new QIIME 2 plugin is using our [Copier template](https://copier.readthedocs.io/en/stable/), which can be found at https://github.com/caporaso-lab/plugin-template.
Here we'll work through building your QIIME 2 plugin from this template.

## Install the tools needed for templating your plugin

Here we'll illustrate how to install and use Copier with `pipx`, though these instructions can be adapted to follow any of the approaches documented in the [Copier installation instructions](https://copier.readthedocs.io/en/stable/).

First, install `pipx`, as documented in their install instructions [here](https://pipx.pypa.io/stable/).
Then, install Copier by running the following commands:

```bash
pipx install copier
```

## Run `Copier` to create your plugin

Next, run `Copier` to create your plugin from the template using the following command.

```shell
copier copy https://github.com/caporaso-lab/plugin-template.git .
```

During the plugin templating process, you'll be prompted for information on your new plugin.
For the questions about the *Target distribution* and whether you're *targeting the stable or latest development QIIME 2 release*, use the default values unless you have a specific reason not to.
For all of the other questions, feel free to customize your plugin by providing whatever values you'd like.

The plugin I'm going to create will be called `q2-dwq2` (for *Developing with QIIME 2*).
After you've answered all of the questions, your plugin should have been successfully created and be ready to be installed and used.

```{note}
If you'd like to learn more about the files that were created in this process, you can refer to [](plugin-package-explanation).
You don't need to know what all of these files are to continue the tutorial though, so you can also come back to that later.
```

## Install and test your new plugin

After the plugin has been created, change into the top-level directory for the plugin.
For me, that's `q2-dwq2/`.
In that directory, you'll find a file called `README.md`, which has a section in it containing *Installation instructions*.
Follow all of the installation instructions, and then follow the instructions in that file for testing and using your new plugin.

After completing all of those steps, you now have a QIIME 2 {term}`deployment` on your computer that includes your new plugin.
When you requested help text on your plugin (e.g., `qiime dwq2 --help`), you should have seen some of the information you provided when creating the plugin.

The template plugin includes a simple (and silly) action called `duplicate-table`, along with associated unit tests.
This provides an example action and example unit tests.
You'll ultimately want to delete this action, but for now let's use it to make sure everything is working as expected.

Call your plugin's `duplicate-table` action with the `--help` parameter (e.g., `qiime dwq2 duplicate-table --help`).
You should see text that looks like the following:

```shell
Usage: qiime dwq2 duplicate-table [OPTIONS]

  Create a copy of a feature table with a new uuid. This is for demonstration
  purposes only. 🧐

Inputs:
  --i-table ARTIFACT FeatureTable[Frequency]
                          The feature table to be duplicated.       [required]
Outputs:
  --o-new-table ARTIFACT FeatureTable[Frequency]
                          The duplicated feature table.             [required]
Miscellaneous:
  --output-dir PATH       Output unspecified results to a directory
  --verbose / --quiet     Display verbose output to stdout and/or stderr
                          during execution of this action. Or silence output
                          if execution is successful (silence is golden).
  --example-data PATH     Write example data and exit.
  --citations             Show citations and exit.
  --help                  Show this message and exit.
```

If you'd like to try the action out, you can call your `duplicate-table` action on any QIIME 2 `FeatureTable[Frequency]` artifact (e.g., you can download one from the QIIME 2 user documentation with [this link](https://gut-to-soil-tutorial.readthedocs.io/en/latest/data/gut-to-soil/asv-table.qza)).
Load your duplicated table with [QIIME 2 View](https://view.qiime2.org), and poke through its Provenance to see how data provenance is recorded for your plugin.

## Initialize a git repository (optional but recommended)

At this stage, I recommend initializing a git repository.
This facilitates managing your plugin in version control, and is especially good practice if you are templating a plugin that you ultimately plan to distribute to others.

You can check if you have git installed by running `git --version`.
If you get a response with a version number (something like `git version 2.44.0`), git is installed and a new local repository will be initialized.
If you get a response suggesting that `git` is not installed, you can install [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) and then continue.

From the top-level directory of your new plugin (for me, that's `q2-dwq2/`), run the following commands:

```
git init -b main
```

```
git add .
git commit \
 -m "initial commit" \
 -m "This plugin was initiated from the Copier template at https://github.com/caporaso-lab/plugin-template" \
 -m "See https://develop.qiime2.org to learn more."
```

The git repository that is created will be a local git repository, meaning that it only exists on your computer and won't be shared through a site like GitHub.
If you'd like to learn how to share your plugins, see [](share-on-github).

## Next steps

Congratulations - you've created a working QIIME 2 plugin from a template!
If you'd like to learn QIIME 2 plugin development, in the next step of the tutorial we'll [](add-nw-align-method).
If you're already comfortable with QIIME 2 plugin development, you're all set to make this plugin your own.
In either case, if you'd like to host your plugin in a GitHub repository, you can refer to [](share-on-github).

```{tip}
You can see my code after following these steps by looking at the specific commit in my plugin repository on GitHub: {{ dwq2_cookiecutter_build_commit_url }}.
My code will look a little different than yours as I generated it using an older version of the template plugin than you used - everything in the tutorial will still work the same though.
```
