
copyrightLine = "Copyright (c) 2013 Michele Bini <michele.bini@gmail.com>"

# This program is free software: you can redistribute it and/or modify
# it under the terms of the version 3 of the GNU General Public License
# as published by the Free Software Foundation.

# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

{ htmlcup } = require "htmlcup"
htmlcup.html5Page ->
  bookmarklet = do ->
    fs = require "fs"
    (readFileSync "CamelCapBookmarklet.txt").toString()
  @head ->
    @meta charset:"utf-8"
    @title "Make CamelCase readable!"
    @cssStyle """
      body {
        background:black;
        font-size: 16px;
        text-align:center;
      }
      body, footer,div {
        padding:0;margin:0;border:0;
      }
      body,* {
        color:#ccf;
        font-family: 'Crimson Text', Helvetica;
        /* font-variant: small-caps; */
      }
      b { color: #e7e7ff; }
      h1,h2,h3,h4,h5,h6 {
        font-weight: normal;
      }
      .info {
        opacity: 0.75
      }
      a.bookmarklet {
        background:#000710;
        font-size:120%;
        display: inline-block;
        box-shadow: 0 0 5px #aaf;
        line-height: 1.5;
        text-decoration: none;
      }
      .flowingContainer {
        vertical-align: top;
      }
      .flowingContent {
        max-width:25em;
        padding: 0.5em;
        display:inline-block;
        vertical-align: top;
        overflow: hidden;
      }
      .flowingContent.alongside {
        vertical-align: middle; /* doesn't seem to be honored by browser */
      }
      .flowingContent :not(.flowingContent) {
        vertical-align: baseline;
      }
      .flowingContent:hover {
        overflow: auto;
      }
      .halfsize {
        font-size: 50%;
      }
      footer {
        width:100%;
        font-size: 14px;
        border-top: 1px solid #113;
        /* box-shadow: -2px 0 1px white; */
        opacity:0.6;
      }
      footer:hover { opacity:1 }
      """
    @link href:'http://fonts.googleapis.com/css?family=Crimson+Text:400,700', rel:'stylesheet', type:'text/css'
  @body ->
    h = (x) => @printHtml x
    thinsp = => h "<span class=halfsize>&nbsp;</span>"
    midDot = => h " &middot; "
    c = camelCap = (h) -> h.replace /([a-z][0-9]*)([A-Z])/g, (m) -> m[0] + "<b>" + m[1] + "</b>"
    q = (x) =>
      @span "«"
      do thinsp
      h x
      do thinsp
      @span "»"
    wpUrl = (title) -> "http://en.wikipedia.org/wiki/" + encodeURIComponent(title)
    @div class:"flowingContainer", ->
      @div class:"flowingContent", ->
        @h2 ->
          @span "Turn "
          q "youCantReadThis"
          @span " into "
          q c "youCanReadThis"
        @h1 ->
          @span class:"info", "Install bookmarket: "
          @a class:"bookmarklet", href:bookmarklet, title:"Move this link to your bookmarks bar to install", ->
            h c "CamelCap"
        @p ->
          h "#{c "CamelCap"} is a visual aid for reading #{c "CamelCase"} code in an "; @a href:"http://ace.c9.io", "ACE editor"; h " They are often used for code editing in popular sites, such as #{c "GitHub"} or #{c "Cloud9"}"
        @p -> h "It works by highlighting uppercase characters in the middle of the #{camelCap "MixedCase"} identifiers."
        @p "To use it, click on the bookmarklet while your browser is visiting a page with an ACE editor.  Initially, scrolling in the editor may be needed for a correct display."
        @p class:"info", ->
          @span "More information about bookmarklets on "
          @a href:(wpUrl "Bookmarklet"), "Wikipedia"
      @div class:"flowingContent alongside", ->
        @p -> @small "Animation showing the difference:"
        @img alt:"Appreciate the difference", src:"CamelCapAnimation.gif"
      @footer ->
        @span copyrightLine.replace(/copyright( \(c\))?/i, "ⓒ")
        do midDot
        @a href:"http://github.com/rev22/CamelCap/tree/gh-pages", "Source code"
