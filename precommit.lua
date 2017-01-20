#!/usr/bin/lua

-- m&mf (c) 2010-2015 by Vadim Peretokin

-- m&mf is licensed under a
-- Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.

-- You should have received a copy of the license along with this
-- work. If not, see <http://creativecommons.org/licenses/by-nc-sa/4.0/>.

-- docs
-- update version in doc
local args = {...}
local systemversion = args[1]

io.input("doc/conf.py")
t = io.read("*all")
t = string.gsub(t, [[version = '.-']], string.format("version = '%s'", systemversion))
t = string.gsub(t, [[release = '.-']], string.format("release = '%s'", systemversion))
io.output("doc/conf.py")
io.write(t)

-- regen docs
os.execute([[cd doc && sphinx-build -b html -d _build/doctrees   . _build/html]])

-- update ndb cache listing
package.path = package.path .. ";./doc/?.lua"
gl     = require"parse_glossary"
pretty = require"pl.pretty"

local data = gl.striptrailinglines(gl.readfile("doc/namedb.rst"))

local f = io.open([[m&m template/ndb-help.lua]], "w+")
f:write(pretty.write(data))
f:close()
