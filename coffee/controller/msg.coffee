class Message
  remote: {}
  constructor: ($rootScope, $scope, webrtc) ->
    $scope.send = =>
      $rootScope.$broadcast 'newOwnMessage', $scope.msg, @remote
      webrtc.send @remote, $scope.msg
      $scope.msg = ''
  
    $scope.open = false
    $scope.$on 'open', (scope, remote, channel, con) =>
      @remote = remote
      $scope.$apply ->
        $scope.open = true

    $scope.$on 'close', (scope, remote, channel, con) =>
      @remote = {}
      $scope.$apply ->
        $scope.open = false

module.exports = Message