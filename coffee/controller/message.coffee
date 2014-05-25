class Message
  peer: null 
  constructor: ($rootScope, $scope) ->
    $scope.send = =>
      $rootScope.$broadcast 'message.own', $scope.msg, @peer
      $scope.msg = ''
  
    $scope.open = false
    
    $scope.$on 'peer.remove', (scope, uuid) =>
      if @peer is uuid
        $scope.open = false
        @peer = null

    $scope.$on 'channel.open', (scope, uuid) =>
      @peer = uuid
      $scope.$apply ->
        $scope.open = true

module.exports = Message