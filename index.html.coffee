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
        font-size: 16px;
        text-align:center;
      }
      body,* {
        background:black;
        color:#ccf;
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
        font-size:120%;
        display: inline-block;
        box-shadow: 0 0 3px white;
      }
      .flowingContent {
        max-width:25em;
        padding: 0.5em;
        display:inline-block;
        vertical-align: top;
        overflow: auto;
      }
      .halfsize {
        font-size: 50%;
      }
      """
  @body ->
    camelCap = (h) -> h.replace /([a-z][0-9]*)([A-Z])/g, (m) -> m[0] + "<b>" + m[1] + "</b>"
    q = (x) =>
      thinsp = => @printHtml "<span class=halfsize>&nbsp;</span>"
      @span "«"
      do thinsp
      @printHtml x
      do thinsp
      @span "»"
    wpUrl = (title) -> "http://en.wikipedia.org/wiki/" + encodeURIComponent(title)
    @div class:"flowingContainer", ->
      @div class:"flowingContent", ->
        @h2 ->
          @span "Turn "
          q "youCantReadThis"
          @span " into "
          q camelCap "youCanReadThis"
        @h1 ->
          @span class:"info", "Install bookmarket: "
          @a class:"bookmarklet", href:bookmarklet, title:"move this link to your bookmarks bar to install", ->
            @printHtml camelCap "CamelCap"
        @p ->
          cSpan = (x) => @span -> @printHtml camelCap x
          cSpan "CamelCap "
          @span "is a visual aid for reading "
          cSpan "CamelCase "
          @span "code in the "
          @a href:"http://ace.c9.io", "ACE editor"
        @p "To use it, click on the bookmarklet while your browser is visiting a page with an ACE editor.  Sometimes scrolling or editing may be needed to display the words as intended."
        @p class:"info", ->
          @span "More information about bookmarklets on "
          @a href:(wpUrl "Bookmarklet"), "Wikipedia"
      @div class:"flowingContent", ->
        @p -> @small "Animation showing the difference:"
        @img alt:"Appreciate the difference", src:"CamelCapAnimation.gif"
