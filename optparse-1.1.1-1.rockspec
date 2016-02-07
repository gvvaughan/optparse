package = "optparse"
version = "1.1.1-1"

description = {
  summary = "Parse and process command-line options",
  detailed = [[
    Automatically generate a custom command-line option parser from
    just the long-form help text for your program.
  ]],
  homepage = "http://gvvaughan.github.io/optparse",
  license = "MIT/X11",
}

source = {
  url = "http://github.com/gvvaughan/optparse/archive/v1.1.1.zip",
  dir = "optparse-1.1.1",
}

dependencies = {
  "lua >= 5.1, < 5.4",
}

build = {
  type = "builtin",
  modules = {
    optparse			= "lib/optparse/init.lua",
    ["optparse.version"]	= "lib/optparse/version.lua",
  },
}
