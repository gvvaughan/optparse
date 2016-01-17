Parse and Process Command Line Options
======================================

Copyright (C) 2014-2016 [Gary V. Vaughan][github]

[![License](http://img.shields.io/:license-mit-blue.svg)](http://mit-license.org)
[![travis-ci status](https://secure.travis-ci.org/gvvaughan/optparse.png?branch=master)](http://travis-ci.org/gvvaughan/optparse/builds)
[![Stories in Ready](https://badge.waffle.io/gvvaughan/optparse.png?label=ready&title=Ready)](https://waffle.io/gvvaughan/optparse)

In the common case, you can write the long-form help output typical of
a modern command line program, and let this module generate a custom
parser that collects and diagnoses the options it describes.

The parser is actually an object instance which can then be tweaked for
the uncommon case, by hand, or by using the "on" method to tie your
custom handlers to options that are not handled quite the way you'd
like.

This is a pure Lua library compatible with [LuaJIT][], [Lua][] 5.1,
5.2 and 5.3.

[github]: http://github.com/gvvaughan/optparse/ "Github repository"
[lua]: http://www.lua.org "The Lua Project"
[luajit]: http://luajit.org "The LuaJIT Project"


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
    luarocks install http://raw.githubusercontent.com/gvvaughan/optparse/master/optparse-git-1.rockspec
```

The best way to install without [LuaRocks][] is to copy the
`optparse.lua` file into a directory in your package search path.

[luarocks]: http://www.luarocks.org "Lua package manager"


Use
---

The optparse package returns a parser factory when required:

```lua
    local OptionParser = require "optparse"

    local help = [[
    parseme (optparse spec) 0α1

    Copyright © 2016 Gary V. Vaughan
    This test program comes with ABSOLUTELY NO WARRANTY.

    Usage: parseme [<options>] <file>...

    Banner text.

    Long description.

    Options:

      -h, --help               display this help, then exit
          --version            display version information, then exit
      -b                       a short option with no long option
          --long               a long option with no short option
          --another-long       a long option with internal hypen
          --true               a Lua keyword as an option name
      -v, --verbose            a combined short and long option
      -n, --dryrun, --dry-run  several spellings of the same option
      -u, --name=USER          require an argument
      -o, --output=[FILE]      accept an optional argument
      --                       end of options

    Footer text.

    Please report bugs at <http://github.com/gvvaughan/optparse/issues>.
    ]]

    local parser = OptionParser (help)
    local arg, opts = parser:parse (_G.arg)
```

Modules not in the standard set may be removed from future versions of
optparse.


Documentation
-------------

The latest release of these libraries is [documented in LDoc][github.io].
Pre-built HTML files are included in the release.

[github.io]: http://gvvaughan.github.io/optparse


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

1. 2-character indentation using SPACES in Lua sources.

[issues]: http://github.com/gvvaughan/optparse/issues
