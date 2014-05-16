chatAppControllers = angular.module 'chatApp.controllers', []

sessionCtrl = ($scope, broadcaster) ->
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

chatAppControllers.controller 'SessionCtrl', [
  '$scope'
  'broadcaster'
  sessionCtrl
]

