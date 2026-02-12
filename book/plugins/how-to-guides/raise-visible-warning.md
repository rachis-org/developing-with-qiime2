(howto-raise-visible-warning)=

# Use the RachisWarning Class: An Always-Visible Warning

Warnings issued by the Python `warning` library are suppressed by defualt when using the command line interface (CLI).
In order to make sure the warnings issued by your plugin are visible in the CLI you must use the `RachisWarning` class.
This class can be imported from the QIIME2 framework, specifically from `qiime2.core.exceptions`.
Below is an [excerpt](https://github.com/qiime2/q2-feature-table/blob/b6a312e612338db0f69c97641372e7f0005b43f5/q2_feature_table/_merge.py#L90C12-L93C14) from the `q2-feature-table` plugin that may issue such a warning.

```python
from qiime2.core.excpetions import RachisWarnings

def merge_taxa(data: pd.DataFrame) -> pd.DataFrame:
    if len(data) > 1:
        depths = []
        for taxonomy in data:
            max = 0
            for _, row in taxonomy.iterrows():
                depth = row['Taxon'].count(';')
                if depth > max:
                    max = depth

            depths.append(max)

        if len(set(depths)) != 1:
            warnings.warn(
                "You are merging taxonomies with different depths.",
                RachisWarning
            )
```

This action issues a `RachisWarning` when the taxonomies have different depths.
Since the `RachisWarning` class is an empty subclass of `UserWarning` from the Python `warnings` [library](https://docs.python.org/3/library/warnings.html), the only difference in behavior is command line visibility.
