local _MODREV, _SPECREV = '1.5', '-1'

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
   'lua >= 5.1, < 5.5',
}

build = {
   type = 'builtin',
   modules = {
      optparse			= 'lib/optparse/init.lua',
      ['optparse._strict']	= 'lib/optparse/_strict.lua',
      ['optparse.version']	= 'lib/optparse/version.lua',
   },
   copy_directories = {'doc'},
}

if _MODREV == 'git' then
   build.copy_directories = nil

   source = {
      url = 'git://github.com/gvvaughan/optparse.git',
   }
end
