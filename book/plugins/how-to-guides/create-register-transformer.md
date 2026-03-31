(howto-create-register-transformer)=
# Creating and registering a Transformer

Transformers are often short Python functions that convert one file format or data type to another file format or data type.
These functions are never directly called by users or developers, so by convention they don't get informative function names (as the annotations of the input and output provide complete detail on what they do).

Here are two example `transformer` that are [defined and registered in `q2-types`](https://github.com/qiime2/q2-types/blob/e25f9355958755343977e037bbe39110cfb56a63/q2_types/distance_matrix/_transformer.py#L16):

```python
import skbio

from ..plugin_setup import plugin
from .
import LSMatFormat


@plugin.register_transformer
def _1(data: skbio.DistanceMatrix) -> LSMatFormat:
    ff = LSMatFormat()
    with ff.open() as fh:
        data.write(fh, format='lsmat')
    return ff


@plugin.register_transformer
def _2(ff: LSMatFormat) -> skbio.DistanceMatrix:
    return skbio.DistanceMatrix.read(str(ff), format='lsmat', verify=False)
```


These transformers define how an `skbio.DistanceMatrix` object is transformed into an `LSMatFormat` object (the underlying format of the data in a `DistanceMatrix` artifact class, defined [here in q2-types](https://github.com/qiime2/q2-types/blob/e25f9355958755343977e037bbe39110cfb56a63/q2_types/distance_matrix/_format.py#L15), and registered to the `DistanceMatrix` semantic type [here](https://github.com/qiime2/q2-types/blob/e25f9355958755343977e037bbe39110cfb56a63/q2_types/distance_matrix/_type.py#L18)).
The transformers are registered using the `@plugin.register_transformer` decorator.