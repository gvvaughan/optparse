local _MODREV, _SPECREV = '1.2', '-1'

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
  url = 'http://github.com/gvvaughan/optparse/archive/v' .. _MODREV .. '.zip',
  dir = 'optparse-' .. _MODREV,
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
