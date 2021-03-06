class Peer
  constructor: ($rootScope, $scope, webrtc, peers) ->
    $scope.peers = {}
    $scope.current = null

    $scope.toggle = ->
      $rootScope.sidebarOpen = !$rootScope.sidebarOpen

    $scope.$on 'peer.new', (scope, infos) ->
      $scope.$apply ->
        infos.open = false
        $scope.peers[infos.uuid] = infos

    $scope.$on 'peer.remove', (scope, infos) ->
      $scope.$apply ->
        $scope.current = null
        delete $scope.peers[infos.uuid]

    $scope.$on 'peer.update', (scope, infos) ->
      infos.open = $scope.peers[infos.uuid].open
      $scope.$apply ->
        $scope.peers[infos.uuid] = infos

    $scope.$on 'channel.open', (scope, uuid) ->
      $rootScope.sidebarOpen = false
      $scope.current = $scope.peers[uuid].name
      $scope.$apply ->
        for peer in $scope.peers
          peer.open = false
        $scope.peers[uuid].open = true

    $scope.$on 'channel.close', (scope, uuid) ->
      $scope.$apply ->
        $scope.current = null
        $scope.peers[uuid].open = false if $scope.peers[uuid]?

    $scope.startConnection = (uuid) ->
      webrtc.connect uuid

module.exports = Peer