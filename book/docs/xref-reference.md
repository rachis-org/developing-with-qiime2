# JupyterBook 2 `xref` reference

This page provides serves some reference information about JupyterBook 2 xrefs in our documentation ecosystem.
Specifically, this includes:
 * our approach for avoiding circularity of xrefs (e.g., if book 1 and book 2 xref each other, and both have updates, the build order can potentially impact the freshness of the content that shows up in each)
 * canonical labels and links used for our most common `xrefs`.

 # Level 0: unversioned resources

 * news.rachis.org - glossary source (and potentially other broadly referenced source content in the future), rachis-glossary-target, https://news.rachis.org/en/latest/
 * library - plugin references, `rachis-library-target`, https://library.qiime2.org

# Level 1: framework references

* Developing with QIIME 2, developer manual, `developing-with-rachis-target`, https://develop.qiime2.org/en/latest/
* Using QIIME 2, rachis user manual, `using-rachis-target`, https://use.qiime2.org/en/latest/

# Level 2: data-set focused tutorials

* Gut-to-soil tutorial, user-focused QIIME 2 tutorial, `gut-to-soil-target`, https://gut-to-soil-tutorial.readthedocs.io/en/latest/
* Moving pictures tutorial, user-focused QIIME 2 tutorial, `moving-pictures-target`, https://moving-pictures-tutorial.readthedocs.io/en/latest/

# Level 3: Distribution and plugin documentation

At this moment, this is the highest level of xref, so nothing xrefs into these.
For that reason, canonical targets aren't yet defined.

* amplicon-docs, QIIME 2 user manual, *no target defined*, https://https://amplicon-docs.qiime2.org/en/latest/
* moshpit docs, MOSHPIT user manual, *no target defined*, https://moshpit.qiime2.org/en/latest/
* genome-sampler docs, `genome-sampler` documentation, *no target defined*, https://genome-sampler.readthedocs.io/en/latest/
* q2-fmt docs, `q2-fmt` documentation, *no target defined*, https://q2-fmt.readthedocs.io/en/latest/
