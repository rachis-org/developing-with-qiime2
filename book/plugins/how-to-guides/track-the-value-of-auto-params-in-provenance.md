(howto-track-the-value-of-auto-params-in-provenance)=
# Track the value of auto params in Provenance

There are cases where you might want an {term}`Action` to take a {term}`Parameter` that can be set to an explicit value by the user, or be algorithmically determined by the {term}`Action` itself. The most common use case for this is a random seed where you may allow the user to pass a set seed for reproducible outcomes or `None` to indicate they want a random outcome. This creates a problem for {term}`Provenance`: if `None` is passed into the {term}`Action`, then `None` will be recorded in {term}`Provenance`, making it impossible to exactly reproduce a prior {term}`Action` execution because the actual value used is unknown. This problem can be solved using the {term}`CaptureHolder` object.

```{note}
The {term}`CaptureHolder` only works if the value of your algorithmically set parameter is actually accessible in the Python implementation of the function. If you are passing a sentinel value into an underlying tool that sets a value for it in a manner inaccessible to you there is no way to capture the value in {term}`Provenance`.
```

The {term}`Action` registration is unchanged:

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

What changes is the implementation of the underlying Python function:

```python
from qiime2.plugin.type import CaptureHolder

def random_seed_method(random_seed: CaptureHolder[int] = None) -> int:
    # Resolve the seed: if the user passed None, generate a random value and
    # record it in provenance; otherwise use the user-supplied value as-is.
    random_int = CaptureHolder.get_or_set(
        random_seed, lambda: random.randrange(sys.maxsize)
    )

    # Use the resolved integer value (guaranteed to never be None here)
    my_value = my_function(random_int)

    return my_value
```

The following rules must be followed to use the {term}`CaptureHolder` object:

1. The type annotation on the {term}`CaptureHolder` {term}`Parameter` must be `CaptureHolder[T]`, where `T` is the Python view type that corresponds to the QIIME 2 {term}`Semantic Type` used for the {term}`Parameter` at registration (e.g., `CaptureHolder[int]` for a parameter registered as `Int`).
2. The default value of the {term}`CaptureHolder` {term}`Parameter` must be `None`.
3. `CaptureHolder.get_or_set(<instance>, <callable>)` must be called exactly once per {term}`CaptureHolder` {term}`Parameter`, before the parameter is used. The return value is the resolved value that should be used in place of the {term}`CaptureHolder` going forward.

`CaptureHolder.get_or_set` takes two arguments: the {term}`CaptureHolder` {term}`Parameter` instance, and a zero-argument callable that generates a value when one is needed. If the user passed `None`, the callable is invoked and its return value is used. If the user passed an explicit value, that value is returned directly. In both cases the resolved value is written back into the {term}`Action`'s {term}`Provenance` as though it had been passed in by the user originally.

```{note}
When calling the underlying function directly during testing (rather than through QIIME 2), `CaptureHolder.get_or_set` behaves correctly whether the parameter is a `CaptureHolder` instance, a plain value, or `None`. This means you can write unit tests that call the function directly without any special handling.
```
