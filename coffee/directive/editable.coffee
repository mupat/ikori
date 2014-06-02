class Editable
  FORMAT: /^[a-zA-Z0-9]{1,}$/
  constructor: ->
    obj = 
      restrict: 'A'
      require: '?ngModel' # get a hold of NgModelController
      link: @run.bind(@)
    return obj
  
  #https://docs.angularjs.org/api/ng/type/ngModel.NgModelController
  #http://stackoverflow.com/questions/16308322/angularjs-attribute-directive-input-value-change
  run: (scope, element, attr, ngModel) ->
    console.log 'here', @, scope, element, attr, ngModel, scope.name, scope[attr.ngModel]
    return unless ngModel # do nothing if no ng-model

    element.on 'blur keyup change', ->
      scope.$apply

    ngModel.$render ->
      console.log 'render', ngModel
      element.html(ngModel.$viewValue || '')

    element.on 'blur keyup change', ->
      scope.$apply ->
        ngModel.$setViewValue element.html()

    ngModel.$setViewValue scope[attr.ngModel]

module.exports = Editable