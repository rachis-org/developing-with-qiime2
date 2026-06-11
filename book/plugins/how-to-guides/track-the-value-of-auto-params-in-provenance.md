(howto-track-the-value-of-auto-params-in-provenance)=
# Track the value of random seeds and other automated parameter settings in data provenance

There are cases where you might want an {term}`Action` to take a {term}`Parameter` that can be set to an explicit value by the user, or be algorithmically determined by the {term}`Action` itself.
The most common use case for this is a random seed, where you may allow the user to pass a set seed (usually because they are trying to reproduce a previous result) or have the {term}`Action` set a random seed for general use (usually the default approach, achieved by setting the default value to `None`).
This creates a challenge for reproducibility: if `None` is passed into the {term}`Action`, then `None` will be recorded in the output's {term}`Provenance`.
The value that the seed was set to internally is lost, making it impossible to exactly reproduce a prior {term}`Action` execution because the random seed is not known.

This problem is solved by using the {term}`CaptureHolder` object.

```{note}
The {term}`CaptureHolder` only works if the value of the algorithmically set parameter is actually accessible in the Python implementation of the function.
If you are passing a sentinel value into an underlying tool (e.g., R code that is used under the hood by your {term}`Action`) which sets its value, that value will be inaccessible in the {term}`Provenance`.
```

The {term}`Action` registration is unchanged:

```python
my_plugin.methods.register_function(
    function=method_with_random_seed,
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
from qiime2.plugin import CaptureHolder


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

`CaptureHolder.get_or_set` takes two arguments: the {term}`CaptureHolder` {term}`Parameter` instance, and a zero-argument callable that generates a value when one is needed.
If the user passed `None`, the callable is invoked and its return value is used.
If the user passed an explicit value, that value is returned directly.
In both cases the resolved value is written back into the {term}`Action`'s {term}`Provenance` as though it had been passed in by the user originally.

## Modifying the Value on a CaptureHolder

{term}`CaptureHolder` objects also support overwriting the value that was set on them. This is a feature that will not be necessary in most cases, and should be used with care.

For a real example of how this might be useful, [`scikit_learn.PCA`](https://scikit-learn.org/stable/modules/generated/sklearn.decomposition.PCA.html) allows the user to pass in n_components as an integer, or a float 0 < n_components < 1. The float will cause PCA to select the number of components such that the amount of variance that needs to be explained is less than the percentage specified by n_components. Fortunately, it is possible to retrieve the integer number of components that ended up being used from the PCA object. In a situation like this, if a user passes in a float, it may be desirable to set the integer number of components actually used in provenance, and not the float.

This can be accomplished by calling `CaptureHolder.set_value` as seen below.

```python
from qiime2.plugin import CaptureHolder


def random_seed_method(random_seed: CaptureHolder[int] = None) -> int:
    # Resolve the seed: if the user passed None, generate a random value and
    # record it in provenance; otherwise use the user-supplied value as-is.
    random_int = CaptureHolder.get_or_set(
        random_seed, lambda: random.randrange(sys.maxsize)
    )

    # Use the resolved integer value (guaranteed to never be None here)
    my_value = my_function(random_int)
    # Set the new value on the CaptureHolder overwriting the old one
    CaptureHolder.set_value(random_seed, my_value, overwrite=True)

    return my_value
```

`CaptureHolder.set_value` takes three arguments: the {term}`CaptureHolder` {term}`Parameter` instance, the value you are setting on it, and a boolean called `overwrite` that defaults to `False`. You must pass `overwrite=True` and explicitly assert that you are changing the value on the {term}`CaptureHolder`, and as a result the value in {term}`Provenance` just to make sure you know what you're doing and want to do this. The value set in {term}`Provenance` needs to be a value that could be passed into the given {term}`Action` for the given {term}`Parameter` leading to the same result as the run the {term}`Provenance` is recording.

```{note}
When calling the underlying function directly during testing (rather than through QIIME 2), `CaptureHolder.get_or_set` and `CaptureHolder.set` behave correctly whether the parameter is a `CaptureHolder` instance, a plain value, or `None`.
This means you can write unit tests that call the function directly without any special handling.
```
