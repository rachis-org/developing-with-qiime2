(howto-track-the-value-of-auto-params-in-provenance)=
# Track the value of auto params in Provenance

There are cases where you might want an {term}`Action` to take a {term}`Parameter` that can be set to an explicit value by the user, or be algorithmically determined by the {term}`Action` itself. The most common use case for this is a random seed where you may allow the user to pass a set seed for reproducible outcomes or `None` to indicate they want a random outcome. This creates a problem for future {term}`Provenance`. If a `None` is passed into the {term}`Action` then a `None` will be recorded in {term}`Provenance` making it impossible to exactly reproduce the prior {term}`Action` execution because the value of the random seed used will be unknown. This can be resolved using the {term}`CaptureHolder` object.

```{note}
The {term}`CaptureHolder` only works if the value of your algorithmically set parameter is actually accessible in the Python implementation of the function. If you are passing a sentinel value into an underlying tool that sets a value for it in a manner inaccessible to you there is no way to capture the value in {term}`Provenance`.
```

Using the {term}`CaptureHolder` object is simple. The actual {term}`Action` registration looks the same as it ever would.

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

The actual implementation of the {term}`Action` is what changes.

```python
from qiime2.plugin.type import CaptureHolder

def random_seed_method(random_seed: CaptureHolder[int] = None) -> int:
    # Ensure there is a random seed generated and set in provenance
    random_int = CaptureHolder.get_or_set(
        random_seed, lambda: random.randrange(sys.maxsize)
    )

    # Use the random value
    my_value = my_function(random_int)

    return my_value
```

The following rules must be followed to use the {term}`CaptureHolder` object:

1. The type annotation on the {term}`CaptureHolder` {term}`Parameter` must be CaptureHolder[T] where T is a type compliant with the type {term}`Semantic Type` used for the {term}`Parameter` at registration.
2. The default value set for the {term}`CaptureHolder` {term}`Parameter` must be `None`.
3. The method `CaptureHolder.get_or_set(<instance>, <callable>)` must be invoked once per {term}`CaptureHolder` {term}`Parameter`. This must be done before using the parameter

The `CaptureHolder.get_or_set` method takes two arguments, the first is your {term}`CaptureHolder` {term}`Parameter`, and the second is a callable that when called will generate a value for the {term}`Parameter`. If the user passed a `None` into the {term}`Parameter`, the callable will be called, and the return value from it will be returned from `CaptureHolder.get_or_set`. If the user passed an actual value, that value will be returned from `CaptureHolder.get_or_set`. The return value from `CaptureHolder.get_or_set` is then used in place of the {term}`CaptureHolder` {term}`Parameter` going forward, and that return value will be stored in the Action's provenance as if it was passed into the {term}`CaptureHolder` {term}`Parameter` in the first place.
