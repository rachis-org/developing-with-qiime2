[![Jupyter Book Badge](https://jupyterbook.org/badge.svg)](https://develop.qiime2.org)

The canonical URL for *Developing with QIIME 2* is https://develop.qiime2.org.

This repository contains the source for *Developing with QIIME 2*. 📖

# Building this documentation

1. Clone the repository and change to its top-level directory:

```bash
git clone https://github.com/caporaso-lab/developing-with-qiime2.git
cd developing-with-qiime2
```

2. Create the book's build environment:

```bash
__DWQ2_ENV_NAME=dwq2-$(date "+%Y-%m-%d")
conda env create -n $__DWQ2_ENV_NAME --file ./environment-files/readthedocs.yml
conda activate $__DWQ2_ENV_NAME
```

3. Build the book.

```bash
make html
```

4. View the result.

Open `book/_build/html/index.html` in a web browser.
