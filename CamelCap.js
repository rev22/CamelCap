(function() {
  var ace, require, _ref;

  ace = (_ref = window.ace) != null ? _ref : window.__ace_shadowed__;

  if (require = ace != null ? ace.require : void 0) {
    if (document.getElementById("camelcapcss")) {
      return;
    }
    require(["ace/layer/text"], function(_arg) {
      var Text, orig, patched, x, _i, _len, _ref1, _ref2, _results;
      Text = _arg.Text;
      if (document.getElementById("camelcapcss")) {
        return;
      }
      orig = Text.prototype.$renderToken;
      patched = (function(rgx) {
        return function(builder, col, token, value) {
          var match, p, q, s, type, type_c;
          if (match = rgx.exec(value)) {
            type = token.type;
            type_c = type + ".camel";
            p = 0;
            while (true) {
              q = rgx.lastIndex - 1;
              s = value.substring(p, q);
              col = orig.call(this, builder, col, {
                type: type,
                value: s
              }, s);
              s = value.substring(q, p = q + 1);
              col = orig.call(this, builder, col, {
                type: type_c,
                value: s
              }, s);
              if (!(match = rgx.exec(value))) {
                break;
              }
            }
            s = value.substring(p);
            return orig.call(this, builder, col, {
              type: type,
              value: s
            }, s);
          } else {
            return orig.apply(this, arguments);
          }
        };
      })(new RegExp("[a-z][0-9]*[A-Z]", "g"));
      Text.prototype.$renderToken = patched;
      x = document.createElement("style");
      x.id = "camelcapcss";
      x.innerHTML = ".ace_camel { font-weight: bold; }";
      document.head.appendChild(x);
      _ref1 = document.getElementsByClassName("ace_editor");
      _results = [];
      for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
        x = _ref1[_i];
        if (x = x != null ? (_ref2 = x.env) != null ? _ref2.editor : void 0 : void 0) {
          if (x = x != null ? x.renderer : void 0) {
            console.log("Attempting to reset mode");
            _results.push(x.updateFull());
          } else {
            _results.push(void 0);
          }
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    });
  }

}).call(this);
