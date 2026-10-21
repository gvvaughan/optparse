local _MODREV, _SPECREV = '2', '-1'

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
   type = 'command',
   build_command = '$(LUA) build-aux/luke'
      .. ' package="' .. package .. '"'
      .. ' version="' .. _MODREV .. '"'
      .. ' PREFIX="$(PREFIX)"'
      .. ' LUA="$(LUA)"'
      ,
   install_command = '$(LUA) build-aux/luke install --quiet'
      .. ' INST_LUADIR="$(LUADIR)"'
      ,
   copy_directories = {'doc'},
}

test_dependencies = {
   'ansicolors',
   'luacov',
   'specl >= 16',
}

test = {
   type = 'command',
   command = 'specl -vfreport --coverage spec/*_spec.yaml',
}

if _MODREV == 'dev' then
   -- luarocks.org's ldoc fails on Lua 5.5; gvvaughan's works.
   build_dependencies = {'gvvaughan/ldoc'}

   build.copy_directories = nil

   source = {
      url = 'git+https://github.com/gvvaughan/optparse.git',
   }
else
   -- A release commits its LDocs, so don't build them again.
   build.build_command = build.build_command .. ' LDOC=true'
end
