# optparse NEWS - User visible changes

## Noteworthy changes in release ?.? (????-??-??) [?]

### New Features

  - Initial support for Lua 5.4.

  - No need to preinstall `std._debug` and `std.normalize` for deployment,
    of course without runtime checking.  In development environments,
    installed `std._debug`, `std.strict` will be loaded and used for
    runtime checks as before.

### Bug fixes

  - Don't hang when option description text contains a '-' character.


## Noteworthy changes in release 1.3 (2017-12-17) [stable]

### Bug fixes

  - Don't hang when help text has a bare '-' as the first non-whitespace
    character on the line.

### Incompatible changes

  - The implementation now depends upon and requires the luarocks modules
    `std.normalize` and `std._debug`.


## Noteworthy changes in release 1.2 (2017-06-03) [stable]

### Bug fixes

  - Don't crash when first unrecognized argument is also a handler
    name (boolean, file, finished, flag, etc...)

  - Don't hang when help text option table formats long option name
    on its own line before indented description.


## Noteworthy changes in release 1.1.1 (2016-02-07) [stable]

### Bug fixes

  - Update for change in std.strict module path.

### Incompatible changes

  - `optparse._VERSION` is now `optparse.version` for consistency with
    other former stdlib modules.

## Noteworthy changes in release 1.1 (2016-01-29) [stable]

### New features

 - If lua-stdlib's `std.debug_init` module is loadable and has
   `_DEBUG.strict` set to `false`, then don't try to load the standalone
   `strict` module.

### Bug fixes

 - Uninstalled `std.debug_init` is handled correctly.

 - `optparse._VERSION` is now documented properly.


## Noteworthy changes in release 1.0.1 (2016-01-17) [stable]

### Bug fixes

 - Propagate metatable to parser factory output objects.


## Noteworthy changes in release 1.0 (2016-01-17) [stable]

### New features

  - Initial release, now separated out from lua-stdlib.
