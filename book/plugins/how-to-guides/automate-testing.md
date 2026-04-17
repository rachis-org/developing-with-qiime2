(automate-testing)=
# Automate testing of your plugin

Automating testing of your plugin is a good way to ensure that you are alerted to issues with your plugin before your users discover them.
This How-to guide provides instructions on automating testing of your plugin using GitHub Actions, and assumes that have configured installation of your plugin as described in [](facilitating-installation).

```{important}
You will need to adjust the environment file versions in the two Github Actions described below with each new QIIME 2 release.
These are specified as `ci-<repository-name>` and `cron-<repository-name>` in the text below.
We plan to develop functionality as part of the QIIME 2 Library that will help to automate this process for plugin developers, but as of now (16 August 2024) this process is manual.
```

## Automated Testing using Continuous Integration (CI) and Github Actions (GHA)

The weekly development builds of the QIIME 2 distributions can help you make sure your code stays current with the distribution(s) you are targeting as you can automate your testing against them.
[](setup-dev-environment) will help you install the most recent successful development metapackage build (again, usually weekly, but sometimes the builds fail and take time to debug).

There are a couple of things that we recommend implementing to help you ensure that your plugin remains compatible within the QIIME 2 ecosystem (discussed below).

### Configure Continuous Integration (CI) testing

Continuous Integration testing is designed to regularly install and run your plugin's unit tests in the targeted QIIME 2 distributions or your custom distribution.

To implement this, you'll need to create a Github Action (GHA) that will be triggered each time you make a commit to your repository - either through a pull request (PR) or a direct commit to one of your remote branches.
Github Actions can be a bit confusing to set up.
We recommend the online course, [*GitHub Automation for Scientists*](https://hutchdatascience.org/GitHub_Automation_for_Scientists), developed by the [ITCR Training Network](https://www.itcrtraining.org/), before moving forward.
Once you've read through this (and hopefully played around with a few of the toy examples provided therein), you can start to put together a CI workflow based the examples provided here.

``````{Note}
Before creating any GHAs for your plugin, you'll start by creating a top-level directory within your plugin's repository with the following name:
```
.github/workflows/
```

This naming structure is what allows Github to identify any relevant actions or workflows that should be run within your repository, and is where all of your GHA files should be created.
``````

Here is what the basic structure of your GHA will look like:

```
name: ci-<repository-name>
on:
  pull_request:
    branches: ["<target-branch>"]
  push:
    branches: ["<target-branch>"]
jobs:
  ci:
    uses: qiime2/distributions/.github/workflows/lib-community-ci.yaml@dev
    with:
      github-repo: <repository-name>
      env-file-name: <target-epoch>-<package-name>-environment.yml
```

With the bracketed terms defined as:
- `<target-branch>`: the branch that should be used when running the GHA
This will typically be your `main` branch, but may differ if you've customized the branch structure of your repository.
- `<repository-name>`: the name of your repository on GitHub
- `<target-epoch>-<package-name>-environment.yml`: the name of your environment file. If you haven't created this yet, refer back to [](facilitating-installation) before continuing.

Your GHA file will be stored under the `.github/workflows/` directory in your repository, and you can use the same name as your Github Action for the filename (e.g., `ci-<repository-name>.yml`).
Note that the extension will also be `.yml` (same as your environment file(s)).

After creating this file and pushing it to the main branch of your repository, this GHA should run anytime there is a commit to `<target-branch>` or a pull request against `<target-branch>`.

### Configure weekly automated testing

Keeping your package up to date with all of the downstream dependencies can feel like a lot of work and hassle, and it can be.
Unfortunately, software is never "done", and that's important to understand if you're distributing software for the community to use.
It's going to require maintenance because software is always changing, and the more dependencies your plugin has, the more likely it is that updates to one of your dependencies will necessitate changes to your plugin (e.g., due to an API change in the dependency).
Performing automated weekly test builds of your plugin will help you keep your package up to date and alert you as issues arise so you can discover them and address them on your own schedule, before it becomes a problem for your users.

In addition to running your unit tests for each commit and/or pull request against your plugin's `<target-branch>`, we recommend implementing regularly scheduled testing of your plugin against the development environments for the QIIME 2 distributions and/or plugins that it relies on.

The process for this will be very similar to the GHA discussed above.
The main differences are that your plugin's environment will be configured with the latest development version of the relevant distribution(s), rather than a specified release version, and that the GHA will be triggered at specific times rather than based on specific events (commits or pull requests).
We suggest having these tests run on a weekly basis to make sure you have ample time between QIIME 2 releases to fix any dependency conflicts or issues from code changes that may arise.

Here's the basic structure of the GHA you'll create to initiate these scheduled tests against your target distribution's development environment:
```
name: cron-<repository-name>
on:
  workflow_dispatch: {}
  schedule:
    - cron: 0 0 * * SUN
jobs:
  ci:
    uses: qiime2/distributions/.github/workflows/lib-community-ci.yaml@dev
    with:
      github-repo: <repository-name>
      env-file-name: development-<repository-name>-environment.yml>
```

This GHA file will also be stored under the `.github/workflows/` directory in your repository, and you can use the same name as your Github Action for the filename (e.g., `cron-<repository-name>.yml`).

Relative to the GHA example above, the differences are:

  - The trigger for this action (i.e., `on`) is either manual (`workflow_dispatch`) or a schedule (`cron`) (previously it was commits and pull requests).
  You can utilize the manual trigger under your repository's `actions` tab if you'd like to re-run these scheduled tests sooner than the next scheduled occurrence (if you're troubleshooting a test failure or upstream dependency issue).
  You can adjust the schedule to any frequency you'd prefer, but we recommend weekly testing to ensure you catch anything that may have fallen out of sync well in advance of the upcoming release.
  More information on the formatting for cron scheduling can be found [here](https://www.ibm.com/docs/en/db2/11.5?topic=task-unix-cron-format).
  - The environment file that is targeted by this action is different than what's used in your CI testing (`development` vs `<target-epoch>`).
  The idea here is that your CI testing is targeting official release versions of your QIIME 2 environment, while these scheduled tests are targeting the current development environment.
  In order to support this, you'll need to create a new 'development' environment file with each QIIME 2 release that looks like the following:

```
channels:
- https://packages.qiime2.org/qiime2/<next-epoch>/<target-distribution>/passed
- conda-forge
- bioconda
dependencies:
  - qiime2-<target-distribution>
  - pip
  - pip:
    - <repository-name>@git+https://github.com/<owner>/<repository-name>.git@<target-branch>
```

With the bracketed terms defined as:
- `<next-epoch>`: the next QIIME 2 release epoch.
QIIME 2 releases are scheduled for the first Wednesday of April and October, so this value is always predictable.
For example, if the most recent release was 2024.10, your `<next-epoch>` would be 2025.4.
- `<target-distribution>`: the rachis distribution that your plugin should be installed under (e.g., `qiime2` or `moshpit`).
- `<target-branch>` (optional): the branch of your repository that testing will be performed against. If not specified, this will default to your repository's *Default branch* (e.g., `main`). If you don't include this, you should leave off the `@` symbol following `.git`.

You can set up any additional GHAs on your repository that you feel will be beneficial to your plugin and general development workflow.
The actions outlined here are what the QIIME 2 developers recommend having to maintain an active and usable plugin.
