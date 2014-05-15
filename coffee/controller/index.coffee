chatAppControllers = angular.module 'chatApp.controllers', []

sessionCtrl = ($scope, broadcaster) ->
  $scope.peers = {}
  console.log 'contr', broadcaster
  # broadcaster.on 'broadcast_answer', (remote, data) ->
  #   $scope.$apply ->
  #     $scope.peers[remote.address] = 
  #       remote: remote
  #       infos: data

  $scope.startConnection = (remote) ->
    console.log 'start', remote

chatAppControllers.controller 'SessionCtrl', [
  '$scope', 
  'broadcaster', 
  sessionCtrl
]

