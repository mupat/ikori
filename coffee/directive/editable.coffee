class Editable
  constructor: ->
    obj = 
      restrict: 'A'
      require: '?ngModel' # get a hold of NgModelController
      link: @run.bind(@)
    return obj

  run: (scope, element, attr, ngModel) ->
    return unless ngModel # do nothing if no ng-model

    # set given values
    element.data 'oldValue', scope[attr.ngModel]
    element.data 'pattern', new RegExp(attr.pattern)

    # render value if it should be render from inside the app
    ngModel.$render ->
      element.html(ngModel.$viewValue || '')

    # update model on element different element events
    element.on 'blur keyup change', ->
      text = element.html()
      # test if input matches pattern
      if element.data('pattern').test text
        # if it matchs, then set it 
        element.data 'oldValue', text
        value = text        
      else
        # if it not matchs, then return to previous value
        element.html element.data('oldValue')
        value = element.data('oldValue')

      # apply changes
      scope.$apply ->
        ngModel.$setViewValue value

    # init value to model and element
    ngModel.$setViewValue scope[attr.ngModel]
    element.html scope[attr.ngModel]

module.exports = Editable