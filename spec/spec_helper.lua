local inprocess = require 'specl.inprocess'
local hell      = require 'specl.shell'
local std       = require 'specl.std'

badargs = require 'specl.badargs'

package.path = std.package.normalize ('./lib/?.lua', './lib/?/init.lua', package.path)


-- Allow user override of LUA binary used by hell.spawn, falling
-- back to environment PATH search for 'lua' if nothing else works.
local LUA = os.getenv 'LUA' or 'lua'


-- Allow use of bare 'unpack' even in Lua 5.3.
unpack = table.unpack or unpack


-- Simplified version for specifications, does not support functable
-- valued __len metamethod, so don't write examples that need that!
function len (x)
   local __len = getmetatable (x) or {}
   if type (__len) == 'function' then return __len (x) end
   if type (x) ~= 'table' then return #x end

   local n = #x
   for i = 1, n do
      if x[i] == nil then return i -1 end
   end
   return n
end


-- Error message specifications use this to shorten argument lists.
-- Copied from functional.lua to avoid breaking all tests if functional
-- cannot be loaded correctly.
function bind (f, fix)
   return function (...)
      local arg = {}
      for i, v in pairs (fix) do
         arg[i] = v
      end
      local i = 1
      for _, v in pairs {...} do
         while arg[i] ~= nil do i = i + 1 end
         arg[i] = v
      end
      return f (unpack (arg, 1, len (arg)))
   end
end


local function mkscript (code)
   local f = os.tmpname ()
   local h = io.open (f, 'w')
   h:write (code)
   h:close ()
   return f
end


--- Run some Lua code with the given arguments and input.
-- @string code valid Lua code
-- @tparam[opt={}] string|table arg single argument, or table of
--    arguments for the script invocation.
-- @string[opt] stdin standard input contents for the script process
-- @treturn specl.shell.Process|nil status of resulting process if
--    execution was successful, otherwise nil
function luaproc (code, arg, stdin)
   local f = mkscript (code)
   if type (arg) ~= 'table' then arg = {arg} end
   local cmd = {LUA, f, unpack (arg, 1, len (arg))}
   -- inject env and stdin keys separately to avoid truncating `...` in
   -- cmd constructor
   cmd.env = { LUA_PATH=package.path, LUA_INIT='', LUA_INIT_5_2='' }
   cmd.stdin = stdin
   local proc = hell.spawn (cmd)
   os.remove (f)
   return proc
end


local function tabulate_output (code)
   local proc = luaproc (code)
   if proc.status ~= 0 then return error (proc.errout) end
   local r = {}
   proc.output:gsub ('(%S*)[%s]*', function (x)
      if x ~= '' then r[x] = true end
   end)
   return r
end


--- Show changes to tables wrought by a require statement.
-- Lists new keys in T1 after `require 'import'`:
--
--       show_apis {added_to=T1, by=import}
--
-- @tparam table argt arguments table
-- @treturn table a list of keys according to criteria above
function show_apis (argt)
   return tabulate_output ([[
      local before, after = {}, {}
      for k in pairs (]] .. argt.added_to .. [[) do
         before[k] = true
      end

      local M = require ']] .. argt.by .. [['
      for k in pairs (]] .. argt.added_to .. [[) do
         after[k] = true
      end

      for k in pairs (after) do
         if not before[k] then print (k) end
      end
   ]])
end
