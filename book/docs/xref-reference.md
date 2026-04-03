(xref-reference)=
# MyST `xref` reference

This page provides serves some reference information about JupyterBook 2 / MyST xref usage in our documentation ecosystem.
Specifically, this page includes:
 * our approach for avoiding circularity of xrefs (e.g., if book 1 and book 2 xref each other, and both have updates, the build order can potentially impact the freshness of the content that shows up in each)
 * canonical labels and links used for our most common `xrefs`.

# `xref` "levels"

A resource at a given "level" (listed below) should only xref to resources at numerically lower levels.
For example, Level 2 resources should only xref to resources in Levels 0 or 1.

This information is used when documentation is rebuilt.
Builds are performed in numeric order of the levels - so first all Level 0 resources build, then all Level 1 resources, and so on.
This is particularly important for xref-embedded content: it ensures that most recent version of content is embedded in a Level N resource from a Level N-1 resource when the Level N resource is built.
An example of this is the glossary, which is [embedded in *Using QIIME 2*](https://github.com/rachis-org/using-qiime2/blob/main/book/back-matter/glossary.md?plain=1) and [in amplicon-docs](https://github.com/qiime2/amplicon-docs/blob/main/docs/back-matter/glossary.md?plain=1) through an xref to content in [*Rachis News*](https://github.com/rachis-org/news.rachis.org/blob/main/blog/glossary.md?plain=1).

Build order within a level is not important.

## Level 0: unversioned resources

| Name | Description | Target | URL |
| ---- | ----------- | ------ | --- |
| `rachis` news | glossary source (and potentially other broadly referenced source content in the future) | `rachis-news-target` | <https://news.rachis.org/en/latest/> |
| library | plugin references | `rachis-library-target` | <https://library.qiime2.org> |

## Level 1: framework references

| Name | Description | Target | URL |
| ---- | ----------- | ------ | --- |
| Developing with QIIME 2 | developer manual | `developing-with-rachis-target` | <https://develop.qiime2.org/en/latest/> |
| Using QIIME 2 | rachis user manual | `using-rachis-target` | <https://use.qiime2.org/en/latest/> |

## Level 2: data-set focused tutorials

| Name | Description | Target | URL |
| ---- | ----------- | ------ | --- |
| Gut-to-soil tutorial | user-focused QIIME 2 tutorial | `gut-to-soil-target` | <https://gut-to-soil-tutorial.readthedocs.io/en/latest/> |
| Moving pictures tutorial | user-focused QIIME 2 tutorial | `moving-pictures-target` | <https://moving-pictures-tutorial.readthedocs.io/en/latest/> |

## Level 3: Examples of distribution and plugin documentation

At this moment, this is the highest level of xref, so nothing xrefs into these.
For that reason, canonical targets aren't yet defined.

| Name | Description | Target | URL |
| ---- | ----------- | ------ | --- |
| amplicon-docs | QIIME 2 user manual | *no target defined* | <https://amplicon-docs.qiime2.org/en/latest/> |
| moshpit docs | MOSHPIT user manual | *no target defined* | <https://moshpit.qiime2.org/en/latest/> |
| genome-sampler docs | `genome-sampler` documentation | *no target defined* | <https://genome-sampler.readthedocs.io/en/latest/> |
| q2-fmt docs | `q2-fmt` documentation | *no target defined* | <https://q2-fmt.readthedocs.io/en/latest/> |


# Miscellaneous notes

 * Remember that anchors can be found in the `myst.xref.json` at the top-level of the target's URL, for example: <https://news.rachis.org/en/latest/myst.xref.json>.
 * [MyST xref docs](https://mystmd.org/guide/website-metadata#myst-xref-json)
 * [MyST cross-referencing docs](https://mystmd.org/guide/cross-references)
