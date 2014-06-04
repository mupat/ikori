gui = global.window.nwDispatcher.requireNwGui()

class Link
  constructor: ->
    obj =
      restrict: 'E'
      link: @run.bind(@)
    return obj

  run: (scope, element, attrs) ->
    # if link should be open external in system default browser
    if attrs.target is 'external'
      element.on 'click', (event) ->
        event.preventDefault()
        gui.Shell.openExternal attrs.href
      
module.exports = Link
