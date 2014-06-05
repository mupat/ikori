class Text
  autolinker: new window.Autolinker({ newWindow: false })

  constructor: (@$compile) ->
    obj =
      restrict: 'E'
      replace: true
      link: @run.bind(@)
    return obj

  run: (scope, element, attrs) ->
    formatted = @autolinker.link attrs.text
    template = @$compile("<p>#{formatted}</p>")(scope)
    element.append template

module.exports = Text