class Peer
  constructor: ($scope, webrtc) ->
    $scope.peers = {}
    $scope.$on 'newPeer', (scope, remote, infos) ->
      $scope.$apply ->
        $scope.peers[remote.address] = 
          remote: remote
          infos: infos
          open: false

    $scope.$on 'removePeer', (scope, address) ->
      $scope.$apply ->
        delete $scope.peers[address]

    $scope.$on 'open', (scope, remote, channel, con) ->
      $scope.$apply ->
        $scope.peers[remote.address].open = true

    $scope.$on 'close', (scope, remote, channel, con) ->
      $scope.$apply ->
        $scope.peers[remote.address].open = false if $scope.peers[remote.address]?

    $scope.startConnection = (remote) ->
      webrtc.connect remote

    $scope.stopConnection = (remote) ->
      webrtc.close remote

module.exports = Peer