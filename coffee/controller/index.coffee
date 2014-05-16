chatAppControllers = angular.module 'chatApp.controllers', []

sessionCtrl = ($rootScope, $scope, broadcaster) ->
  $scope.peers = {}
  $rootScope.$on 'newPeer', (scope, remote, data) ->
    $scope.$apply ->
      $scope.peers[remote.address] = 
        remote: remote
        infos: data

  # on for debug purpose
  $rootScope.$on 'sent', (scope, msg) ->
    console.log 'sent', msg

  # start the broadcast
  broadcaster.sendBroadcasts()
  console.log 'started'

  $scope.startConnection = (remote) ->
    console.log 'start', remote

chatAppControllers.controller 'SessionCtrl', [
  '$rootScope'
  '$scope'
  'broadcaster'
  sessionCtrl
]

