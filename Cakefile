# Copyright (c) 2013 Michele Bini

# This program is free software: you can redistribute it and/or modify
# it under the terms of the version 3 of the GNU General Public License
# as published by the Free Software Foundation.

# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


CoffeeScript = require 'coffee-script'
{ readFileSync, writeFileSync } = require 'fs'

print = do (stderr = process.stderr) -> (x) ->
  stderr.write x

compileAction = (from, to, f) ->
  print "[ Building #{to} <- #{from} ..."
  try
    if f()
      print " OK ]\n"
    else
      print " FAIL ]\n"
  catch error
    print "FAIL ]: \n"
    print error.toString()
    print "\n"

compileCoffeeScriptFile = do ->
  (from, to = from.replace(/\.coffee$/i, "") + ".js") -> compileAction from, to, ->
    compiledCode = CoffeeScript.compile (readFileSync from).toString()
    writeFileSync to, compiledCode

compileHtmlDotCoffee = (from, to = from.replace(/\.html\.coffee$/i, "") + ".html") -> compileAction from, to, ->
  global = eval "this"
  orig = global.process
  chunks = []
  global.process =
    stdout:
      write: (x) -> chunks.push "#{x}"
  try
    code = CoffeeScript.compile (readFileSync from).toString()
    eval code
    global.process = orig
    writeFileSync to, chunks.join("")
    true
  finally
    global.process = orig

compileBookmarklet = do ->
  min = do ->
    UGL = require 'uglify-js2'
    (code) ->
      ast = UGL.parse code
      ast.figure_out_scope()
      ast = ast.transform(UGL.Compressor())
      ast.figure_out_scope()
      x = ast.print_to_string()
      "javascript:" + encodeURIComponent x.replace(/;\n*$/, "")
  (from, to) -> compileAction from, to, ->
    compiled = CoffeeScript.compile((readFileSync from).toString(), bare: true)
    bookmarklet = (min "(function(){#{compiled}})()")
    writeFileSync to, bookmarklet
    true

task "build", "compile bookmarklet and js", ->
  compileCoffeeScriptFile "CamelCap.coffee"
  compileBookmarklet("CamelCap.coffee", "CamelCapBookmarklet.txt")
  compileHtmlDotCoffee "index.html.coffee"
