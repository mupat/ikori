localStorage = window.localStorage

class Options
  constructor: ($rootScope, $scope, config) ->
    $rootScope.name = config.name #set own name as title

    $scope.toggle = ->
      $rootScope.optionsOpen = !$rootScope.optionsOpen

    $scope.name = config.name
    $scope.notificationInterval = config.notificationInterval
    
    $scope.save = (key, value) =>
      return unless value?

      if value isnt config[key]
        localStorage[key] = value
        config[key] = value
        #update own name in title
        if key is 'name'
          $rootScope.name = config.name

    $scope.video = false
    $scope.$on 'message.stream', (scope, stream) ->
      $scope.video = true
      window.document.getElementById('screen').src = window.URL.createObjectURL stream

module.exports = Options