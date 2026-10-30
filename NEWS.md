# optparse NEWS - User visible changes

## Noteworthy changes in release ?.? (????-??-??) [?]

### New features

  - optparse checks the arguments of its functions, `optparse`, `on`,
    `parse`, `opterr`, the option handlers, and `boolean` and `file`, when
    typecheck is installed, and says which argument of which function was
    wrong, with `bad argument #2 to 'optparse.on' (string or table
    expected, got number)`.  Without typecheck there is no checking and
    no overhead, and typecheck does none either when `std._debug` has
    `argcheck = false` as it loads, as for the other libraries.

### Incompatible changes

  - With typecheck installed, `optparse(text:gsub(...))`, which also
    passes the number of replacements, is an error: "no more than 2
    arguments expected, got 3".  Put the call in parentheses, as in
    `optparse((text:gsub(...)))`, or do not install typecheck in
    production.


## Noteworthy changes in release 3 (2026-10-28) [stable]

### Incompatible changes

  - optparse is built from the `build` table of its rockspec, by the
    `luarocks-build-luke` LuaRocks build backend, which LuaRocks
    installs for the build, so there is no `build-aux/luke` build to
    run, and no build without LuaRocks.  Building LDocs, which a release
    commits, no longer needs a build dependency of its own.

  - The `help` alias of `parser.showhelp`, which has been undocumented
    since release 1.5, is removed.  Use `parser.showhelp`, as in
    `parser:on('-?', parser.showhelp)`.

### Bug fixes

  - optparse applies strict variable declarations to its own module
    whenever std.strict is installed, as std.normalize does, and no
    longer only when std._debug is installed too.  Setting the `strict`
    hint of std._debug to false still turns them off.

  - The manual says to copy `init.lua` and `_normalize.lua`, the files that
    optparse needs besides `version.lua`, where it named `_strict.lua`.

  - The `parse` method no longer raises an error for an argument list
    whose `__metatable` field is not a table, such as `true`.

  - `parser.flag` now records a value that is not a function, such as
    `parser:on('--stored', parser.flag, 'stored')`, as its documentation
    says, instead of recording nothing.  Passing `false` records `false`.

  - `parser.boolean` now reports an argument that is not a boolean, such
    as `--color=maybe`, with an error message and exit status 2, instead
    of raising a Lua error.


## Noteworthy changes in release 2 (2026-10-20) [stable]

### New features

  - optparse has a manual, `doc/optparse.md`, which is now the home page
    at <https://gvvaughan.github.io/optparse>.  The LDoc reference has
    moved to <https://gvvaughan.github.io/optparse/api>.

### Bug fixes

  - `parse` no longer replaces an option that the command line set to
    `false`, such as `--color=no` with `parser.boolean`, with a true
    value from its `defaults` argument.


## Noteworthy changes in release 1.6 (2026-07-25) [stable]

### New Features

  - Initial support for Lua 5.5.


## Noteworthy changes in release 1.5 (2022-07-30) [stable]

### Bug fixes

  - The parser no longer shadows the internal `optparse.version`
    `on_handler` by also saving the last word of the parsed
    `versiontext` into `optparse.version`.

    But, we don't want to break existing clients that use the content
    of the saved `optparse.version` string either.  Since the
    `on_handler` was never available to callers before due to being
    shadowed, rename it to `optparse.showversion`.

### Incompatible changes

  - For consistency with the renaming of `optparse.showversion`,
    similarly rename `optparse.help` to `optparse.showhelp`.  For
    backwards compatibility, `optparse.help` continues to be available
    too, but is now undocumented.  Consider using the `showhelp` in
    your projects, especially if you also start using `showversion`.


## Noteworthy changes in release 1.4 (2018-09-16) [stable]

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
