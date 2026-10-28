---
layout: default
---
# OPTPARSE

[optparse] parses and processes command line options for [LuaJIT] and
[Lua] 5.1 through 5.5.  Write the `--help` text of your program the way
you would anyway, and optparse builds a parser from it:

 * one help text, which is both the documentation of your options and
   the [specification](#2-the-specification) of the parser
 * a [parser](#3-parsing) that expands combined short options and
   `--long=ARG` arguments, and collects options into a table
 * built-in [handlers](#4-handlers) for flags, required and optional
   arguments, `--help`, `--version` and `--`
 * [custom handlers](#5-custom-handlers) for the uncommon case, and
   [argument types](#6-argument-types) such as booleans and files
 * consistent [error messages](#7-errors)

The [API reference](api/) has every function and field in detail.


## 1. Installation

Install the latest release with [LuaRocks]:

{% highlight bash %}
    luarocks install optparse
{% endhighlight %}

optparse is pure Lua, with no dependencies, so you can also copy
`init.lua` and `_normalize.lua` from its `lib/optparse` directory into an
`optparse` directory in your package search path.


## 2. The Specification

Loading optparse returns a factory, which you call with the help text of
your program to build a parser for it:

{% highlight lua %}
    local OptionParser = require 'optparse'

    local parser = OptionParser [[
    parseme 1.0
    Copyright (C) 2026 Your Name
    This program comes with ABSOLUTELY NO WARRANTY.

    Usage: parseme [<options>] <file>...

    Banner text.

    Long description.

    Options:

      -h, --help               display this help, then exit
          --version            display version information, then exit
      -b                       a short option with no long option
          --long               a long option with no short option
          --another-long       a long option with internal hyphen
      -v, --verbose            a combined short and long option
      -n, --dryrun, --dry-run  several spellings of the same option
      -u, --name=USER          require an argument
      -o, --output=[FILE]      accept an optional argument
      --                       end of options

    Footer text.

    Please report bugs at <https://github.com/you/parseme/issues>.
    ]]
{% endhighlight %}

The help text needs a `Usage:` line, and optparse splits it in two
there:

 * `versiontext` is everything before `Usage:`, which `--version`
   displays.  The last word of its first line is the `version` of your
   program, `1.0` above.
 * `helptext` is everything from `Usage:` on, which `--help` displays.
   The word after `Usage:` is the name of your `program`, which error
   messages start with.

A line in `helptext` that starts with two or more spaces and then a
hyphen specifies an option: every comma or space separated spelling at
the start of the line, until the description.  Everything else is
there for your users to read, and optparse ignores it.

How each option is written decides what optparse does with it:

| Written as                        | Handler                                   |
|-----------------------------------|-------------------------------------------|
| `-b`, `--long`, `-v, --verbose`   | [`flag`](#41-flags)                       |
| `-u, --name=USER`                 | [`required`](#42-required-arguments)      |
| `-o, --output=[FILE]`             | [`optional`](#43-optional-arguments)      |
| `--help`                          | [`showhelp`](#44-help-and-version)        |
| `--version`                       | [`showversion`](#44-help-and-version)     |
| `--`                              | [`finished`](#45-end-of-options)          |


## 3. Parsing

Pass the command line to `parse`, which returns the arguments it did not
recognise, and a table of the options it found:

{% highlight lua %}
    local arg, opts = parser:parse(_G.arg)
{% endhighlight %}

Each option is stored under one key, made from the last spelling written
in the specification, without its leading hyphens and with every other
non-alphanumeric character turned into `_`:

| Specification            | Key            |
|--------------------------|----------------|
| `-b`                     | `opts.b`       |
| `-v, --verbose`          | `opts.verbose` |
| `--another-long`         | `opts.another_long` |
| `-n, --dryrun, --dry-run`| `opts.dry_run` |

Before any handler runs, `parse` expands combined short options, so that
`-bv` is the same as `-b -v`, and splits a recognised `--long=ARG` into
`--long ARG`.  Then:

{% highlight bash %}
    $ parseme -bv --name=gary in.txt
{% endhighlight %}

returns `{'in.txt'}` and `{b = true, verbose = true, name = 'gary'}`.

An argument that is not a recognised option is returned in the first
table, in order, along with the argument after an unrecognised option,
unless it starts with a hyphen.  So `parseme --bogus in.txt` returns
`{'--bogus', 'in.txt'}`, and your program decides whether that is an
error.

### 3.1. Defaults

The second argument to `parse` is a table of defaults, for the options
that the command line leaves out:

{% highlight lua %}
    local arg, opts = parser:parse(_G.arg, {name = 'nobody'})
{% endhighlight %}

An option given on the command line keeps its value, even when that is
`false`.

### 3.2. The Parser Object

The parser is an object with the fields that optparse read from the
specification, `program`, `version`, `versiontext` and `helptext`, and
`opts` is a table whose missing fields are looked up in the parser.
`parse` also saves its results in the parser, as `parser.unrecognised`
and `parser.opts`.


## 4. Handlers

A handler is the function that `parse` calls when it finds an option.
optparse chooses one for each option in the specification, as in the
table in [section 2](#2-the-specification), and you can choose another
with [`on`](#5-custom-handlers).

### 4.1. Flags

`flag` stores `true`, however often the option is given:

{% highlight bash %}
    $ parseme -v -v          # opts.verbose == true
{% endhighlight %}

### 4.2. Required Arguments

`required` stores the next argument, even if it starts with a hyphen,
and reports an error if there is none.  Given more than once, the
option stores a list of its arguments, in order:

{% highlight bash %}
    $ parseme -u gary                 # opts.name == 'gary'
    $ parseme --name=gary -u root     # opts.name == {'gary', 'root'}
{% endhighlight %}

### 4.3. Optional Arguments

`optional` stores the next argument if there is one that does not start
with a hyphen, and `true` otherwise:

{% highlight bash %}
    $ parseme -o out.txt     # opts.output == 'out.txt'
    $ parseme -o -v          # opts.output == true
{% endhighlight %}

Like `required`, it stores a list when the option is given more than
once.

### 4.4. Help and Version

`showhelp` prints `helptext`, and `showversion` prints `versiontext`;
both then exit with status 0.

### 4.5. End of Options

`finished` stops `parse` there, so every argument after `--` is
returned as unrecognised, even when it looks like an option:

{% highlight bash %}
    $ parseme -- -b in.txt   # arg == {'-b', 'in.txt'}
{% endhighlight %}


## 5. Custom Handlers

`on` sets the handler for an option, replacing the one from the
specification, or adding an option that the specification leaves out:

{% highlight lua %}
    parser:on('-?', parser.showhelp)
    parser:on({'-e', '--eval'}, parser.required)
{% endhighlight %}

It takes a spelling of the option, or a list of them, which can leave
out the hyphens: a single letter is a short option, and a longer name a
long option.  The key in `opts` comes from the last spelling, as in
[section 3](#3-parsing).

A handler of your own is called with the parser, the expanded argument
list, the index of the option in that list, and the third argument
given to `on`, and returns the index of the next argument to process:

{% highlight lua %}
    -- Count each -v, for more and more verbose output.
    parser:on({'-v', '--verbose'}, function(parser, arglist, i)
       parser.opts.verbose = (parser.opts.verbose or 0) + 1
       return i + 1
    end)
{% endhighlight %}

`on` also passes its third argument on to the built-in handlers.  If it
is a function, `required`, `optional` and `flag` call it with the
parser, the option and its argument, and store what it returns; the
argument is `nil` for `optional` without one, and `true` for `flag`.
Otherwise, `required` and `optional` store it in place of the argument.


## 6. Argument Types

optparse comes with two functions to pass to `on` that way.  `boolean`
turns an argument into `true` or `false`, accepting `1`, `true`, `yes`
and `y`, or `0`, `false`, `no` and `n`, in any case, and reports an
error for anything else.  With `optional`, the option alone is `true`:

{% highlight lua %}
    parser:on('--color', parser.optional, parser.boolean)
{% endhighlight %}

so `--color` and `--color=yes` store `true`, and `--color=no` stores
`false`.

`file` reports an error unless the argument names a file that can be
read:

{% highlight lua %}
    parser:on('--config', parser.required, parser.file)
{% endhighlight %}


## 7. Errors

`opterr` writes an error message in the same form as optparse's own,
then exits with status 2:

{% highlight bash %}
    $ parseme --name
    parseme: error: option '--name' requires an argument.
    parseme: Try 'parseme --help' for help.
{% endhighlight %}

Call it from your own handlers, or after `parse`, to report errors the
same way:

{% highlight lua %}
    local arg, opts = parser:parse(_G.arg)
    if #arg == 0 then
       parser:opterr 'no files given'
    end
{% endhighlight %}


## 8. Bugs and Contributions

Please report bugs and make suggestions as [GitHub issues][issues], and
check that they are not already fixed on [master][optparse] first.  Pull
requests are especially welcome.


[issues]:   https://github.com/gvvaughan/optparse/issues
[lua]:      https://www.lua.org
[luajit]:   https://luajit.org
[luarocks]: https://luarocks.org
[optparse]: https://github.com/gvvaughan/optparse
