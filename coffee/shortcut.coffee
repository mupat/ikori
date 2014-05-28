mapKeys =
  116: 'f5'
  82: 'r'
  73: 'i'
  67: 'c'
  86: 'v'

gui = require 'nw.gui'
win = gui.Window.get()
clipboard = gui.Clipboard.get()

reload = (event) ->
  if event.shiftKey then win.reloadIgnoringCache()
  else win.reload()

devtools = (event) ->
  if win.isDevToolsOpen() then win.closeDevTools()
  else win.showDevTools()

copy = ->
  clipboard.set window.getSelection().toString(), 'text'

paste = ->
  window.document.activeElement.value = clipboard.get('text')

window.document.onkeydown = (event) ->
  #console.log 'key', mapKeys[event.which], event.keyCode, String.fromCharCode(event.keyCode), event.shiftKey, event.metaKey
  switch mapKeys[event.which]
    when 'f5' # reload on linux and win
      reload event
    when 'r' # reload on mac
      return unless event.metaKey
      reload event
    when 'i' # devtools
      return devtools event if event.metaKey and event.altKey # on mac
      devtools event if event.shiftKey and event.ctrlKey # on linux and win
    when 'c' # copy to clipboard
      return copy() if event.metaKey # on mac
      copy() if event.ctrlKey # on linux and win
    when 'v' # paste from clipboard
      return paste() if event.metaKey # on mac
      paste() if event.ctrlKey # on linux and win
