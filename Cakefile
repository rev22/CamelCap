compileBookmarklet = do ->
  { compile } = require 'coffee-script'
  { readFileSync, writeFileSync } = require 'fs'
  min = do ->
    UGL = require 'uglify-js2'
    (code) ->
      ast = UGL.parse code
      ast.figure_out_scope()
      ast = ast.transform(UGL.Compressor())
      ast.figure_out_scope()
      x = ast.print_to_string()
      "javascript:" + encodeURIComponent x.replace(/;\n*$/, "")
  (from, to) ->
    compiled = compile((readFileSync from).toString(), bare: true)
    bookmarklet = (min "(function(){#{compiled}})()")
    writeFileSync to, bookmarklet

task "build", "compile bookmarklet", ->
  compileBookmarklet("CamelCap.coffee", "CamelCapBookmarklet.txt")
