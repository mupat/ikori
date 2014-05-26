localStorage = window.localStorage

class User
  constructor: ($scope, config) ->
    $scope.editable = {}
    #map config informations to scope
    for key, value of config
      switch key
        when 'port'
          type = 'number'
          label = key
        when 'name'
          type = 'text'
          label = "your name"
        when 'broadcastInterval'
          type = 'number'
          label = "Interval for broadcast messages"
        when 'notificationInterval'
          type = 'number'
          label = "Interval for notification messages"
        when 'logging'
          type = 'checkbox'
          label = key
        else continue

      obj = 
        value: value
        type: type
        label: label
      $scope.editable[key] = obj
    
    $scope.save = (value) =>
      console.log 'save', value
      @oldValue = value

    $scope.change = (key, value) =>
      console.log 'change', key, value, @oldValue
      if value? or value.length > 0
        localStorage[key] = value
        config[key] = value
        console.log 'config', config, key, value
        # window.angular.module('chatApp').constant 'CONFIG',config
      else
        $scope.editable[key].value = @oldValue

module.exports = User