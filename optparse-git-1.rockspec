local _MODREV, _SPECREV = 'git', '-1'

package = 'optparse'
version = _MODREV .. _SPECREV

description = {
  summary = 'Parse and process command-line options',
  detailed = [[
    Automatically generate a custom command-line option parser from
    just the long-form help text for your program.
  ]],
  homepage = 'http://gvvaughan.github.io/optparse',
  license = 'MIT/X11',
}

source = {
  url = 'git://github.com/gvvaughan/optparse.git',
}

dependencies = {
  'lua >= 5.1, < 5.4',
}

build = {
  type = 'builtin',
  modules = {
    optparse			= 'lib/optparse/init.lua',
    ['optparse.version']	= 'lib/optparse/version.lua',
  },
}
