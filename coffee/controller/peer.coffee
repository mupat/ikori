class Peer
  constructor: ($scope, broadcaster, webrtc) ->
    $scope.peers = {}
    $scope.$on 'newPeer', (scope, remote, data) ->
      $scope.$apply ->
        $scope.peers[remote.address] = 
          remote: remote
          infos: data
          open: false

    $scope.$on 'open', (scope, remote, channel, con) ->
      $scope.$apply ->
        $scope.peers[remote.address].open = true

    $scope.$on 'close', (scope, remote, channel, con) ->
      $scope.$apply ->
        $scope.peers[remote.address].open = false

    $scope.startConnection = (remote) ->
      webrtc.connect remote

    $scope.stopConnection = (remote) ->
      webrtc.close remote

module.exports = Peer