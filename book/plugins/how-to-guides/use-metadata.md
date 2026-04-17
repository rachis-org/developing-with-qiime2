(how-to-use-metadata)=
# How to use Metadata

Metadata (the `qiime2.metadata.Metadata` class, internally) allows users to annotate a QIIME 2 {term}`Result` with study-specific values: age, elevation, body site, pH, etc.
QIIME 2 offers a consistent API for developers to expose their {term}`Methods <Method>` and {term}`Visualizers <Visualizer>` to user-defined metadata.
For more details about how users might create and utilize metadata in their studies, check out the [Metadata In QIIME 2](https://docs.qiime2.org/2018.4/tutorials/metadata/) tutorial.

````{margin}
```{note}
Refer to the [](metadata-api) for additional information on using metadata in your plugins.
```
````

## Metadata

Actions may request an entire `Metadata` object to work on.
At its core, `Metadata` is just a pandas [pd.Dataframe](https://pandas.pydata.org/docs/reference/api/pandas.DataFrame.html), but the `Metadata` object provides many convenience methods and properties, and unifies the code necessary for handling these data (or metadata).
Examples of {term}`Actions <Action>`  that consume and operate on `Metadata` include:

- [q2-longitudinal's `volatility`](https://docs.qiime2.org/2018.4/plugins/available/longitudinal/volatility/)
- [q2-metadata's `tabulate`](https://docs.qiime2.org/2018.4/plugins/available/metadata/tabulate/)
- [q2-feature-table's `filter-features`](https://docs.qiime2.org/2018.4/plugins/available/feature-table/filter-features/)
- And many more

Plugins may work with metadata directly, or they may choose to filter, regroup, partition, pivot, etc. - it all depends on the intended outcome relevant to the {term}`method <Method>` or {term}`visualizer <Visualizer>` in question.

`Metadata` is subject to framework-level validations, normalization, and verification.
We recommend [familiarizing yourself](https://docs.qiime2.org/2018.4/tutorials/metadata/) with this behavior before utilizing `Metadata` in your {term}`Action`.
We think having this kind of behavior available via a centralized API helps ensure consistency for all users of `Metadata`.

```python
def my_viz(output_dir: str, md: qiime2.Metadata) -> None:
    df = md.to_dataframe()
    ...
```

## Metadata Columns

Plugin {term}`Actions <Action>` may also request one or more `MetadataColumns` (the `qiime2.metadata.MetadataColumn`, internally) to operate on, a good example of this is identifying which column of metadata contains barcodes, when using [q2-demux's `emp-single`](https://docs.qiime2.org/2018.4/plugins/available/demux/emp-single/) or [q2-cutadapt's `demux-paired`](https://docs.qiime2.org/2018.4/plugins/available/cutadapt/demux-paired/), for example.

Instances of `MetadataColumn` exist as one of two concrete classes: `NumericMetadataColumn` (`qiime2.metadata.NumericMetadataColumn`) and `CategoricalMetadataColumn` (`qiime2.metadata.CategoricalMetadataColumn`).

By default, QIIME 2 will attempt to infer the type of each metadata column: if the column consists only of numbers or missing data, the column is inferred to be numeric.
Otherwise, if the column contains any non-numeric values, the column is inferred to be categorical.
Missing data (i.e. empty cells) are supported in categorical columns as well as numeric columns.

```python
...
numeric_md_cols = metadata.filter(column_type='numeric')
categorical_md_cols = metadata.filter(column_type='categorical')
...
```

If your {term}`Action` always needs one type of column or another, you can simply register that type in your plugin registration:

```python
plugin.methods.register_function(
    ...
    parameters={'metadata': MetadataColumn[Numeric]},
    parameter_descriptions={'metadata': 'Numeric metadata column to '
                            'compute pairwise Euclidean distances from'},
    ...
```

This will ensure that all the necessary type-checking is performed by the framework before these data are passed into the {term}`Action` utilizing it.

### Numeric Metadata Columns

Columns that consist only of numeric (or missing) values are eligible for being instantiated as `NumericMetadataColumn` (although these values can be loaded as `CategoricalMetadataColumn`, too).

### Categorical Metadata Columns

All types of data columns can be instantiated as `CategoricalMetadataColumn` - values will be cast to strings.

## How can the Metadata API Help Me?

The `qiime2.metadata.Metadata` API has many interesting features - here are some of the more commonly utlitized elements amongst the plugins within the qiime2 {term}`Distribution`.

### Merging Metadata

{term}`Interfaces <Interface>` can allow users to specify more than one metadata file at a time, the framework will handle merging the files or objects `qiime2.metadata.Metadata.merge` prior to handing the final merged set to your {term}`Action`.

### Dropping Empty Columns

When working with a single metadata metadata column, plugin code can determine if there are missing values (`qiime2.metadata.MetadataColumn.has_missing_values`), and then subsequently drop those IDs (`qiime2.metadata.MetadataColumn.drop_missing_values`) from the column.

### Normalizing TSV Files

By saving (`qiime2.metadata.Metadata.save`) a materialized `Metadata` instance, visualizations that want to provide data exports can do so in a consistent manner (e.g. [q2-longitudinal's `volatility`](https://docs.qiime2.org/2018.4/plugins/available/longitudinal/volatility/), and the [relevant code](https://github.com/qiime2/q2-longitudinal/blob/93558f4d6b5f34c9a01f8d7a63175dfba249b361/q2_longitudinal/_longitudinal.py#L330).

### Advanced Filtering

The `filter` (`qiime2.metadata.Metadata.filter_columns`) method can be used to restrict column types, drop empty columns, or remove columns made entirely of unique values.

### SQL Filtering

Advanced metadata querying is enabled by SQL-based filtering (`qiime2.metadata.Metadata.get_ids`).

(artifacts-as-metadata)=
## Making Artifacts Viewable as Metadata

By [registering a transformer](howto-create-register-transformer) from a particular {term}`format <Format>` to `qiime2.Metadata`, the framework will allow the {term}`type <Type>` represented by that format to be {term}`viewed <View>` as `Metadata` --- this can open up all kinds of exciting opportunities for plugins!

```python
@plugin.register_transformer
def _1(data: cool_project.InterestingDataFormat) -> qiime2.Metadata:
    df = pd.Dataframe(data)
    return qiime2.Metadata(df)
```

(metadata-tabulate)=
### A visualizer for free!

If your {term}`type <Type>` is viewable as `Metadata` (as in, the necessary transformers are registered), there is a general-purpose metadata visualization in the q2-metadata plugin called `tabulate`, which renders an interactive (searchable, sortable) table of the metadata in question.
Cool!

## Generating metadata as output from visualizations

In most cases, if you want to output something that looks like metadata from a QIIME 2 action, you should [assign it an artifact class that has a transformer to `Metadata`](artifacts-as-metadata).
However in some cases you may want to output actual metadata.
In this case, you can create an output for your action of artifact class `ImmutableMetadata`.
This will generate an artifact containing the metadata that your function provides as output.

`ImmutableMetadata` artifacts can be [viewed as `Metadata`](artifacts-as-metadata), so they can be used anywhere that a typical metadata `.tsv` file can be provided as input in QIIME 2.
This includes q2-metadata's `tabulate` visualizer.
Additionally, if you want to obtain a `.tsv` file representation of an `ImmutableMetadata` artifact, you can [export it](https://docs.qiime2.org/2024.2/tutorials/exporting/).
