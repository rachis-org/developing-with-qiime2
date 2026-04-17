(share-on-github)=
# Distribute plugins on GitHub

GitHub is a straight-forward way to share your QIIME 2 plugin.
This tutorial will walk you through creating a QIIME 2 plugin from template, and then sharing it with installation instructions on GitHub.

This tutorial assumes that you have `git` and the [GitHub command line interface](https://cli.github.com/) installed on your computer.
If you don't have these installed, do that now using the GitHub command line interface [installation instructions](https://github.com/cli/cli#installation), which should install `git` if you don't already have it installed.

```{note}
All of the steps illustrated here that use the GitHub command line interface can also be performed through the typical GitHub web interface.
The GitHub command line interface is used here as it's easier to document and test the instructions (and it's pretty darn cool).
```

## Template your plugin

Create a new template plugin, according to the instructions in [](plugin-from-template).
Pay attention to the question about the "target distribution" - this enables templating of installation instructions and test machinery against the distribution of your choice.
For example, if you want your plugin to expand upon the `qiime2` distribution, this is where you indicate that.

After completing those steps, return to this page.

## Share your plugin on GitHub

Change into [your plugin's top-level directory](plugin-package-explanation-top-level-directory).
To confirm that a local `git` repository was initialized during the templating process, run:

```shell
git log
```

You should see that there has been one commit to this repository (or more, if you've done additional work on the plugin and committed those changes).

Next, you'll need to log in to GitHub via the command line interface to authenticate.
Run the following command, and follow the instructions:

```shell
gh auth login
```

After successful authentication, from your plugin's top-level directory run [`gh repo create`](https://cli.github.com/manual/gh_repo_create):

```shell
gh repo create
```

This will ask a series of questions.
As of this writing (24 April 2024), the first question is:

```shell
? What would you like to do?
  Create a new repository on GitHub from scratch
  Create a new repository on GitHub from a template repository
> Push an existing local repository to GitHub
```

You should select the last option as you're going to push your plugin's local `git` repository to GitHub.

Work through the remaining questions.
If you don't know how to answer to a specific question, the default is generally what you'll want to select.

After this process completes, you will have a new GitHub repository.
If you navigate to that repository in your web browser you should see that the tests are currently running (or recently completed).
If those tests pass, follow the instructions in the `README.md` on your repository to test installation of your plugin on your computer.
If that works, you should be ready to share those instructions with others.

## Expanding on the install instructions

Users should now be able to install and use your plugin if they're pointed at the `README.md` file.
The templated *Installation instructions* in the `README.md` file are intended to be a starting point, and they mention that as a note to readers.
You'll almost certainly want to update the install instructions for your plugin as you develop it.

Here are some tips related to updating the installation instructions for your plugin:
- If your plugin requires additional dependencies that can be installed with either conda or pip, you can add those in the environment yaml file that was templated into the `environments/` directory.
- We recommend doing what you can in the `Makefile` in your repository, so that the command `make install` continues to be the mechanism by which your plugin should be installed.
- Be sure to update the `README.md` if you introduce any new constraints (e.g., that your plugin can only be installed on Linux).
  It's fine to do that, but you should let your users know so they don't get grumpy about your plugin.

For more information on how to create a formal software release for your plugin, please see [release your plugin on Github](release-on-gh).

If you're ready to start getting users, the next steps are [helping prospective users discover your plugin](plugin-how-to-publicize), and [supporting them as they use it](plugin-how-to-support-your-users).
