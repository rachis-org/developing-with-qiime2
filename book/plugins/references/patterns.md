# Plugin development patterns

This page makes recommendations for plugin developers to help make your plugins consistent with others.
The items outlined on this page aren't requirements, but might improve your users' experience.

## Name inputs, outputs, and parameters consistently

It can be frustrating for users if different names are used by different actions to refer to the same thing.
For example, if one action calls a sample metadata parameter `metadata`, and another calls it `sample-metadata`, that makes it harder for users to remember how to call either action (or any others that take sample metadata as input).
When you're naming inputs, outputs, and parameters for your actions, look at other actions in commonly used plugins and try to align your naming with existing naming when it makes sense.[^my-name-is-better]

### Metadata parameter name recommendations

We make the following recommendations for naming `Metadata` parameters, based on [a review](https://gist.github.com/gregcaporaso/4be64940f80256316e3308d2ae2ec0da) of how these had actually been named in the plugins in the QIIME 2 *amplicon distribution* in November 2025.

- If your action takes only one sample metadata input, call it `metadata`. ([example: `kmer-diversity`](https://amplicon-docs.qiime2.org/en/latest/references/plugins/boots.html#q2-action-boots-kmer-diversity))
- If your action takes only one feature metadata input, call it `feature-metadata`.
- If your action takes a sample metadata input and a feature metadata input, called them `sample-metadata` and `feature-metadata`, respectively. ([example: `biplot`](https://amplicon-docs.qiime2.org/en/latest/references/plugins/emperor.html#q2-action-emperor-biplot))
- If your action uses a metadata parameter to take a list of identifiers, name that in a way that is relevant for that action. ([example: `get-ncbi-data`](https://amplicon-docs.qiime2.org/en/latest/references/plugins/rescript.html#q2-action-rescript-get-ncbi-data))
  - If this list of identifiers is used for filtering purposes, call that parameter `ids-to-keep` or `ids-to-exclude`, based on whether the ids provided are retained for the analysis or excluded from the analysis, respectively. ([example: `filter-taxa`](https://amplicon-docs.qiime2.org/en/latest/references/plugins/rescript.html#q2-action-rescript-filter-taxa))
- If your action takes more than one sample metadata input, called them `metadata1`, `metadatá2`, ... ([example: `merge`](https://amplicon-docs.qiime2.org/en/latest/references/plugins/metadata.html#q2-action-metadata-merge))
- If your action takes more than one feature metadata input, called them `feature-metadata1`, `feature-metadata2`, ...

[^my-name-is-better]: Sometimes you may have a slightly better name for an input, output, or parameter than what is widely used.
 Counterintuitively, using that name might make your users' experience more challenging because it's not the name they've come to expect.
 In this case, it probably makes sense to go with the existing name.
 Other times you might have a name that's *much* better than what others are using (e.g., because the other name is actively misleading).
 In this case, you should probably go with your name, but it may be worth contacting developers of the other plugins you looked at to discuss a broad change.
