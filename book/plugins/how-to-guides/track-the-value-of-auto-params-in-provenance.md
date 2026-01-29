(howto-track-the-value-of-auto-params-in-provenance)=
# Track the value of auto params in Provenance

```{note}
The {term}`CaptureHolder` only works if the value of your algorithmically set parameter is actually accessible in the Python implementation of the function. If you are passing a sentinel value into an underlying tool that sets a value for it in a manner inaccessible to you there is no way to capture the value in {term}`Provenance`.
```

There are many cases where you might want an {term}`Action` to take a {term}`Parameter` that can either be set to an explicit value by the user, or be algorithmically determined and set by the {term}`Action` itself. These actions will generally take a sentinel value like "auto" or None to indicate their value should be determine algorithmically. By default this sentinel value is what will end up in the {term}`Action's <Action>` {term}`Provenance`, but it is generally more desirable for the generated value that was actually used to be stored in {term}`Provenance`. This can be achieved by using the {term}`CaptureHolder` view type.

One common example of this is setting a seed for random number generation. An example implementation of an {term}`Action` making use of this is as follows:

<!-- TODO: There is a real example of this awaiting merge here https://github.com/qiime2/q2-feature-table/pull/352. Probably replace the dummy method here with this after it has been released? -->

```python
from qiime2.plugin.type import CaptureHolder

def random_seed_method(random_seed: CaptureHolder = None) -> int:
    if random_seed.value is None:
        random_int = random.randrange(sys.maxsize)
        random_seed.set_value(random_int)

    return random_seed.value
```

The {term}`Action` registration would look like this:

```python
dummy_plugin.methods.register_function(
    function=random_seed_method,
    inputs={},
    parameters={
       'random_seed': Int
    },
    outputs=[('seed', SingleInt)],
    name='Takes a random seed',
    description='Takes an integer as a random seed and returns that same'
                ' integer. If no integer is provided, it generates one at'
                ' random and captures that randomly generated integer in'
                ' provenance.'
)
```

The following rules must be followed to use the {term}`CaptureHolder` object:

1. There must be a default value set for the {term}`CaptureHolder` {term}`Parameter`.
2. A value MUST be set for all {term}`CaptureHolder` parameters that were passed their default value before the Python function run by the {term}`Action` returns. If any are not set this will trigger an error.
3. The value on the {term}`CaptureHolder` may only be set once. Attempting to set it again will trigger an error.
4. Values set on a {term}`CaptureHolder` {term}`Parameter` must be valid instances of the {term}`Semantic Type` used for the {term}`Parameter` in the {term}`Action` registration.

If these rules are followed, then the {term}`Provenance` of the {term}`Results <Result>` returned by this {term}`Action` will contain the value that was generated within the {term}`Action` and set on the {term}`CaptureHolder` used by that run and not the placeholder value that was actually passed into the {term}`Action`.
