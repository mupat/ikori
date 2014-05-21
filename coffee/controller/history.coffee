class History
  histories: {}
  constructor: (@$scope, user, network) ->
    @$scope.history = []

    @$scope.$on 'open', (scope, remote) =>
      @histories[remote.address] = [] unless @histories[remote.address]?
      @$scope.history = @histories[remote.address]

    @$scope.$on 'close', =>
      @$scope.history = []

    @$scope.$on 'newRemoteMessage', (scope, msg, event, remote) =>
      @$scope.$apply =>
        @_add msg, network.getPeerInfos(remote.address)['name'], remote.address

    $scope.$on 'newOwnMessage', (scope, msg, remote) =>
      @_add msg, user.getInfos()['name'], remote.address
  
  _add: (msg, origin, identifier) ->
    @histories[identifier].push {
      time: new Date()
      msg: msg
      origin: origin
    }

module.exports = History