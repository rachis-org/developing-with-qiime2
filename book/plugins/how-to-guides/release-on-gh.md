(howto-release-on-gh)=
# Creating a new release of your plugin on GitHub

As you add new features into your plugin, you may wish to create *release* versions to share with your users.
We’ve created a GitHub workflow automation that runs each time you publish a new release on your plugin’s repository that will mint and test a new release environment file, so you don't have to!
If you used our plugin template (see [](plugin-from-template)) on or after 20 June 2025, this automation is already included!
You can determine whether or not you have this automation by looking under the `.github/workflows/` directory in your plugin's repository - the file that creates this automation will be titled `release-env.yml`.
Note that you will need to have a correctly formatted release environment file in order for this automation to work properly.
More information on how to create and format a release environment file can be found in [](facilitating-installation).

A GitHub workflow is included upon creation of your plugin (using our plugin template) that will automatically run when a new GitHub release is published on your plugin's repository.
This workflow will mint a new *release* environment file that includes the latest QIIME 2 release of the given distribution you specified upon plugin creation, as well as the newly minted release version of your plugin.
Once this new environment file is created, a pull request will be opened on your plugin's repository that contains these changes.
An additional automated check will then run to test that installation of this newest version of your plugin, and a comment will be added on that pull request that will provide the status of this check (either success or failure).

```{figure} ../images/release-env-PR-overview.png
:align: center
```

If the check was successful, you can go ahead and merge this pull request.
```{figure} ../images/release-env-PR-passed.png
:align: center
```

If the check was unsuccessful, a link to the error log is provided for you to review and troubleshoot.
```{figure} ../images/release-env-PR-failed.png
:align: center
```

If you are stuck and need help interpreting these logs, you can always ask for help through the [*Developer Discussion* category on the QIIME 2 Forum](https://forum.qiime2.org/c/dev-discussion/7).

## How to publish a GitHub release
Released versions of software are helpful for bundling a cohesive grouping of new functionality and any relevant bug fixes into a particular snapshot in time, so that users know what to expect when they install a particular version of your plugin.
When you are ready, you can do this by creating an official release on GitHub.
This process will create a unique tag that you define, and this tag will be attached to the latest commit on your main branch (or another branch, if you would like to create and specify release branches).

Before creating your first release, you'll need to update some permissions on your plugin's GitHub repository in order for our automated checks to run.
You can update these permissions by navigating to your plugin repository's Settings page -> Actions -> General.

```{figure} ../images/settings-general.png
:align: center
```

From this page, you'll scroll down to the 'Workflow permissions' section, and select 'Read and write permissions' and 'Allow GitHub Actions to create and approve pull requests'.

```{figure} ../images/settings-gha-permissions.png
:align: center
```

Now that you've updated your GitHub repository's settings, you should be ready to publish your first GitHub release!

GitHub Documentation offers a helpful walkthrough of creating a new release, which you can find [here](https://docs.GitHub.com/en/repositories/releasing-projects-on-GitHub/managing-releases-in-a-repository#creating-a-release).

For more information on how to structure your release versions, check out [versioning guidelines for your plugin](versioning-your-plugin).
