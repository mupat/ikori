calc = (length) ->
  return length * 20 + "px"

run = (scope, element, attr) ->
  console.log 'run', scope, element, attr
  element.css {
    width: calc(scope[attr.ngModel].length)
  }

  element.on 'keypress', (event) ->
    console.log 'keydown', scope[attr.ngModel], event, event.target.value, event.srcElement.value
    element.css {
      width: calc(event.srcElement.value.length)
    }

module.exports = run