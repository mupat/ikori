localStorage = window.localStorage

class Options
  constructor: ($rootScope, $scope, config) ->
    $rootScope.name = config.name #set own name as title

    $scope.toggle = ->
      $rootScope.optionsOpen = !$rootScope.optionsOpen

    $scope.name = config.name
    $scope.notification_interval = config.notificationInterval

    # $scope.editable = {}
    # #map config informations to scope
    # for key, value of config
    #   switch key
    #     when 'port'
    #       type = 'number'
    #       label = key
    #     when 'name'
    #       type = 'text'
    #       label = "your name"
    #     when 'broadcastInterval'
    #       type = 'number'
    #       label = "Interval for broadcast messages"
    #     when 'notificationInterval'
    #       type = 'number'
    #       label = "Interval for notification messages"
    #     when 'logging'
    #       type = 'checkbox'
    #       label = key
    #     else continue

    #   obj = 
    #     value: value
    #     type: type
    #     label: label
    #   $scope.editable[key] = obj
    
    $scope.save = (value) =>
      @oldValue = value

    $scope.change = (key, value) =>
      if value? or value.length > 0
        localStorage[key] = value
        config[key] = value
        if key is 'name'
          $rootScope.name = config.name #update own name in title
      else
        $scope.editable[key].value = @oldValue

    $scope.video = false
    $scope.$on 'message.stream', (scope, stream) ->
      $scope.video = true
      window.document.getElementById('screen').src = window.URL.createObjectURL stream

module.exports = Options