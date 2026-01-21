(howto-create-documentation)=
# How to create documentation for a plugin or distribution

1. Create and activate the QIIME 2 deployment that you want to document.
1. Install q2doc (`pip install https://github.com/qiime2/q2doc/archive/refs/heads/dev.zip`, or clone it and `pip install .`).
1. Install [Jupyter Book 2 (alpha)](https://blog.jupyterbook.org/posts/2024-11-15-jupyter-book-2-alpha)
1. Create a top-level project directory, if you don't already have one.
   This could be the root directory of your plugin code repository (e.g., `q2-dwq2`, if your code is structured as in [](plugin-package-explanation)), or if this is solely a documentation project it should just be the top-level directory for the projects (e.g., `my-book`.)
   `cd` to that directory.
1. Add the following file to the top-level directory.

    `Makefile`:
    ```

    html:
        cd docs && q2doc autodoc .
        cd docs && jupyter book build --html
        cp -r docs/data/ docs/_build/html/data/

    serve:
        npx serve docs/_build/html/ -p 4000

    clean:
        rm -rf docs/_build/html/

    ```
1. Create a new directory for your documentation called `docs`.
   `cd` to that directory, and add the following files:

    `myst.yml`:
    ```
    # See docs at: https://mystmd.org/guide/frontmatter
    version: 1
    project:
    id: project-identifier
    title: project documentation
    # description:
    # keywords: []
    # authors:
    github: project-url
    references:
        dwq2: https://develop.qiime2.org/en/latest/
        uq2: https://use.qiime2.org/en/latest/

    plugins:
        - type: executable
        path: q2doc-plug.py

    bibliography:
        - q2doc.bib
        - references.bib

    site:
    template: https://github.com/ebolyen/myst-book-theme-poc.git
    options:
        folders: true
        # logo:
        pretty_urls: false
    ```

    `q2doc-plug.py`
    ```
    #!/usr/bin/env python

    from q2doc.__main__ import myst

    if __name__ == '__main__':
        myst()
    ```

1. Run `q2doc autodoc .`.
1. Run `jupyter book init --write-toc`.
1. Run `make html`.
1. Run `make serve`.