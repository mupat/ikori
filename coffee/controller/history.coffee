class History
  histories: {}
  constructor: (@$scope, user) ->
    @$scope.history = []

    @$scope.$on 'open', (scope, remote) =>
      @histories[remote.address] = [] unless @histories[remote.address]?
      @$scope.history = @histories[remote.address]

    @$scope.$on 'close', =>
      @$scope.history = []

    @$scope.$on 'newRemoteMessage', (scope, msg, event, remote) =>
      @$scope.$apply =>
        @_add msg, remote.address, remote.address

    $scope.$on 'newOwnMessage', (scope, msg, remote) =>
      console.log 'own', msg, remote
      @_add msg, user.getInfos()['name'], remote.address
  
  _add: (msg, origin, identifier) ->
    console.log 'hist', @histories, identifier
    @histories[identifier].push {
      time: new Date()
      msg: msg
      origin: origin
    }

module.exports = History