class Message
  peer: null 
  constructor: ($rootScope, $scope) ->
    @$scope = $scope
    $scope.open = false
    $scope.send = =>
      $rootScope.$broadcast 'message.own', $scope.msg, @peer
      $scope.msg = ''
     
    $scope.screen = =>
      $rootScope.$broadcast 'message.screen', @peer

    $scope.$on 'peer.remove', (scope, uuid) =>
      @_remove uuid

    $scope.$on 'channel.close', (scope, uuid) =>
      @_remove uuid

    $scope.$on 'channel.open', (scope, uuid) =>
      @peer = uuid
      $scope.$apply ->
        $scope.open = true

  _remove: (uuid) ->
    if @peer is uuid
      @$scope.open = false
      @peer = null

module.exports = Message