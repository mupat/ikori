mapKeys =
  116: 'f5'
  82: 'r'
  73: 'i'
  67: 'c'
  # 86: 'v'
  90: 'v'

gui = require 'nw.gui'
win = gui.Window.get()
clipboard = gui.Clipboard.get()

reload = (event) ->
  if event.shiftKey then win.reloadIgnoringCache()
  else win.reload()

devtools = (event) ->
  if win.isDevToolsOpen() then win.closeDevTools()
  else win.showDevTools()

copy = (text) ->
  clipboard.set text, 'text'

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
      devtools event if event.metaKey and event.altKey # on mac
      devtools event if event.shiftKey and event.ctrlKey # on linux and win
    when 'c' # copy to clipboard
      copy window.getSelection().toString() if event.metaKey # on mac
      copy window.getSelection().toString() if event.ctrlKey # on linux and win
    when 'v' # paste from clipboard
      paste() if event.metaKey # on mac
      paste() if event.ctrlKey # on linux and win

console.log 'win', window