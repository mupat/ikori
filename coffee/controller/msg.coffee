class Message
  constructor: ($scope, webrtc) ->
    $scope.send = ->
      console.log 'send', $scope.msg
      webrtc.send remote, $scope.msg
  
    $scope.open = false
    $scope.$on 'open', (scope, remote, channel, con) ->
      @remote = remote
      $scope.$apply ->
        $scope.open = true

    $scope.$on 'close', (scope, remote, channel, con) ->
      $scope.$apply ->
        $scope.open = false
module.exports = Message