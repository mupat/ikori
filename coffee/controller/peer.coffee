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

    $scope.$on 'channel.open', (scope, uuid) ->
      $scope.$apply ->
        $scope.peers[uuid].open = true

    $scope.$on 'channel.close', (scope, uuid) ->
      $scope.$apply ->
        $scope.peers[uuid].open = false


    # $scope.peers = peer.getAll()
    # $scope.$on 'newPeer', (scope, uuid) ->
    #   # $scope.$apply ->
    #   $scope.peers[uuid] = peer.get(uuid)

    # $scope.$on 'removePeer', (scope, uuid) ->
    #   # $scope.$apply ->
    #   delete $scope.peers[uuid]

    # $scope.$on 'open', (scope, remote, channel, con) ->
    #   $scope.$apply ->
    #     $scope.peers[remote.address].open = true

    # $scope.$on 'close', (scope, remote, channel, con) ->
    #   $scope.$apply ->
    #     $scope.peers[remote.address].open = false if $scope.peers[remote.address]?

    $scope.startConnection = (uuid) ->
      # $rootScope.$broadcast 'peer.select', uuid
      webrtc.connect uuid

    # $scope.stopConnection = (uuid) ->
    #   webrtc.close uuid

module.exports = Peer