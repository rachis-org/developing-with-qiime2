(howto-raise-visible-warning)=
# Raising a Visible Warning

Warnings raised by the Python `warning` library are suppressed by defualt when using the command line interface (CLI). In order to make sure the warnings raised by your plugin are visible in the CLI you must use the `RachisWarning` subclass. This class can be imported from the QIIME2 framework, specifically from `qiime2.core.exceptions`. Below is an [excerpt](https://github.com/qiime2/q2-feature-table/blob/b6a312e612338db0f69c97641372e7f0005b43f5/q2_feature_table/_merge.py#L90C12-L93C14) from from the `q2-feature-table` plugin that raises such a `RachisWarning`.

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
This plugin has a `RachisWarning` raised when the taxonomies have different depths. Since the `RachisWarning` is a subclass of `UserWarning` from the
built in Python `warnings` [library](https://docs.python.org/3/library/warnings.html) they behave completely the same outside of command line visibility.