local _MODREV, _SPECREV = 'dev', '-1'

rockspec_format = '3.0'
package = 'optparse'
version = _MODREV .. _SPECREV

description = {
   summary = 'Parse and process command-line options',
   detailed = [[
      Automatically generate a custom command-line option parser from
      just the long-form help text for your program.
   ]],
   homepage = 'https://gvvaughan.github.io/optparse',
   license = 'MIT/X11',
}

source = {
   url = 'https://github.com/gvvaughan/optparse/archive/v' .. _MODREV .. '.zip',
   dir = 'optparse-' .. _MODREV,
}

dependencies = {
   'lua >= 5.1, < 5.6',
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

test_dependencies = {
   'ansicolors',
   'luacov',
   'specl >= 15',
}

test = {
   type = 'command',
   command = 'specl --unicode -vfreport --coverage spec/*_spec.yaml',
}

if _MODREV == 'dev' then
   build.copy_directories = nil

   source = {
      url = 'git+https://github.com/gvvaughan/optparse.git',
   }
end
