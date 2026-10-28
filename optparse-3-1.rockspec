local _MODREV, _SPECREV = '3', '-1'

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

build_dependencies = {
   'luarocks-build-luke >= 0.3.1',
}

build = {
   type = 'luke',

   modules = {
      {['optparse']         = 'lib/optparse/init.lua'},
      {['optparse._normalize'] = 'lib/optparse/_normalize.lua'},
      {['optparse.version'] = 'lib/optparse/version.lua.in'},
   },

   -- A release commits its LDocs to install.
   copy_directories = {'doc'},
}

test_dependencies = {
   'ansicolors',
   'luacov',
   'specl >= 17',
}

test = {
   type = 'command',
   command = 'specl -vfreport --coverage spec/*_spec.yaml',
}

if _MODREV == 'dev' then
   -- luarocks.org's ldoc fails on Lua 5.5; gvvaughan's works.
   build_dependencies[#build_dependencies + 1] = 'gvvaughan/ldoc'

   -- Stamp a development build with who made it, and from which commit.
   build.version = '$USER/$gitref'

   build.copy_directories = nil

   source = {
      url = 'git+https://github.com/gvvaughan/optparse.git',
   }
end
