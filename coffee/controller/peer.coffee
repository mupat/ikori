class Peer
  constructor: ($rootScope, $scope, webrtc, peers) ->
    $scope.peers = {}

    $scope.$on 'peer.new', (scope, infos) ->
      $scope.$apply ->
        infos.open = false
        $scope.peers[infos.uuid] = infos

    $scope.$on 'peer.remove', (scope, infos) ->
      $scope.$apply ->
        delete $scope.peers[infos.uuid]

    $scope.$on 'peer.update', (scope, infos) ->
      $scope.$apply ->
        $scope.peers[infos.uuid] = infos

    $scope.$on 'channel.open', (scope, uuid) ->
      $scope.$apply ->
        $scope.peers[uuid].open = true

    $scope.$on 'channel.close', (scope, uuid) ->
      $scope.$apply ->
        $scope.peers[uuid].open = false if $scope.peers[uuid]?

    $scope.startConnection = (uuid) ->
      webrtc.connect uuid

module.exports = Peer