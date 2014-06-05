gui = global.window.nwDispatcher.requireNwGui()

class Link
  constructor: ->
    obj =
      restrict: 'E'
      # replace: true
      link: @run.bind(@)
    return obj

  run: (scope, element, attrs) ->
    # if link is not forced to be opened in app
    if attrs.rel isnt 'self'
      element.on 'click', (event) ->
        event.preventDefault()
        gui.Shell.openExternal attrs.href
      
module.exports = Link