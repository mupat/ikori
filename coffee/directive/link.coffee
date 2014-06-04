gui = global.window.nwDispatcher.requireNwGui()

class Link
  constructor: ->
    obj =
      restrict: 'E'
      link: @run.bind(@)
    return obj

  run: (scope, element, attrs) ->
    console.log 'here'
    # if link is not forced to be opened in app
    if attrs.rel isnt 'self'
      console.log 'add'
      element.on 'click', (event) ->
        event.preventDefault()
        gui.Shell.openExternal attrs.href
      
module.exports = Link
