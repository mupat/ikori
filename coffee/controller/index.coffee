chatAppControllers = angular.module 'chatApp.controllers', []

sessionCtrl = ($scope, broadcaster, webrtc) ->
  $scope.peers = {}
  $scope.$on 'newPeer', (scope, remote, data) ->
    $scope.$apply ->
      $scope.peers[remote.address] = 
        remote: remote
        infos: data

  # start the broadcast
  broadcaster.sendBroadcasts()
  console.log 'started'

  $scope.startConnection = (remote) ->
    console.log 'start', remote
    webrtc.connect remote

chatAppControllers.controller 'SessionCtrl', [
  '$scope'
  'broadcaster'
  'webrtc'
  sessionCtrl
]

