Parse and Process Command Line Options
======================================

Copyright (C) 2014-2018, 2021-2022, 2026 [Gary V. Vaughan][github]

[![License](https://img.shields.io/:license-mit-blue.svg)](https://mit-license.org)
[![workflow status](https://github.com/gvvaughan/optparse/actions/workflows/spec.yml/badge.svg?branch=release-v3)](https://github.com/gvvaughan/optparse/actions)
[![codecov.io](https://codecov.io/gh/gvvaughan/optparse/graph/badge.svg?branch=release-v3)](https://codecov.io/gh/gvvaughan/optparse?branch=release-v3)

In the common case, you can write the long-form help output typical of
a modern command line program, and let this module generate a custom
parser that collects and diagnoses the options it describes.

The parser is actually an object instance which can then be tweaked for
the uncommon case, by hand, or by using the "on" method to tie your
custom handlers to options that are not handled quite the way you'd
like.

This is a pure Lua library compatible with [LuaJIT][], [Lua][] 5.1,
5.2, 5.3, 5.4 and 5.5.

[github]: https://github.com/gvvaughan/optparse/ "Github repository"
[lua]: https://www.lua.org "The Lua Project"
[luajit]: https://luajit.org "The LuaJIT Project"


Installation
------------

The simplest and best way to install optparse is with [LuaRocks][]. To
install the latest release (recommended):

```bash
luarocks install optparse
```

To install current git master (for testing, before submitting a bug
report for example):

```bash
luarocks install https://raw.githubusercontent.com/gvvaughan/optparse/master/optparse-dev-1.rockspec
```

The best way to install without [LuaRocks][] is to copy `init.lua` and
`_normalize.lua` from `lib/optparse` into an `optparse` directory in your
package search path.

[luarocks]: https://luarocks.org "Lua package manager"


Documentation
-------------

optparse includes [comprehensive documentation][github.io], which is
written in [doc/optparse.md][manual].

[github.io]: https://gvvaughan.github.io/optparse
[manual]:    doc/optparse.md


Bug reports and code contributions
----------------------------------

Please make bug reports and suggestions as [GitHub Issues][issues].
Pull requests are especially appreciated.

But first, please check that your issue has not already been reported by
someone else, and that it is not already fixed by [master][github] in
preparation for the next release (see Installation section above for how
to temporarily install master with [LuaRocks][]).

There is no strict coding style, but please bear in mind the following
points when proposing changes:

0. Follow existing code. There are a lot of useful patterns and avoided
   traps there.

1. 3-character indentation using SPACES in Lua sources: It makes rogue
   TABs easier to see, and lines up nicely with 'if' and 'end' keywords.

2. Simple strings are easiest to type using single-quote delimiters,
   saving double-quotes for where a string contains apostrophes.

3. Save horizontal space by only using SPACEs where the parser requires
   them.

4. Use vertical space to separate out compound statements to help the
   coverage reports discover untested lines.

5. Prefer explicit string function calls over object methods, to mitigate
   issues with monkey-patching in caller environment.

[issues]: https://github.com/gvvaughan/optparse/issues
