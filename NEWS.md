# optparse NEWS - User visible changes

## Noteworthy changes in release ?.? (????-??-??) [?]

### New features

 - If lua-stdlib's `std.debug_init` module is loadable and has
   `_DEBUG.strict` set to `false`, then don't try to load the standalone
   `strict` module.


## Noteworthy changes in release 1.0.1 (2016-01-17) [stable]

### Bug fixes

 - Propagate metatable to parser factory output objects.


## Noteworthy changes in release 1.0 (2016-01-17) [stable]

### New features

  - Initial release, now separated out from lua-stdlib.
