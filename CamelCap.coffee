# Copyright (c) 2013 Michele Bini

# Please read the MIT-LICENSE file about licensing and the absence of any warranty

ace = window.ace ? window.__ace_shadowed__
if require = ace?.require
  return if document.getElementById "camelcapcss"
  require ["ace/layer/text"], ({Text}) ->
    return if document.getElementById "camelcapcss"
    orig = Text.prototype.$renderToken
  
    patched = do (
      rgx = new RegExp "[a-z][0-9]*[A-Z]", "g"
    ) -> (builder, col, token, value) ->
      if match = rgx.exec value
        type = token.type
        type_c = type + ".camel"
        p = 0
        loop
          q = rgx.lastIndex - 1
          s = value.substring(p, q)
          col = orig.call @, builder, col, { type, value: s }, s
          s = value.substring(q, p = q + 1)
          col = orig.call @, builder, col, { type: type_c, value: s }, s
          break unless match = rgx.exec value
        s = value.substring(p)
        orig.call @, builder, col, { type, value: s }, s            
      else
        orig.apply @, arguments
  
    Text.prototype.$renderToken = patched
  
    x = document.createElement "style"
    x.id = "camelcapcss"
    x.innerHTML = ".ace_camel { font-weight: bold; }"
    document.head.appendChild x
    
    for x in document.getElementsByClassName("ace_editor")
      if x = x?.env?.editor
        if x = x?.renderer
          console.log "Attempting to reset mode"
          x.updateFull()
