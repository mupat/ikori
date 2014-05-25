class History
  peer: null
  constructor: ($scope, peers) ->
    $scope.history = []
    $scope.$on 'channel.open', (scope, uuid) =>
      @peer = uuid
      $scope.$apply ->
        $scope.history = peers.getHistory uuid

    $scope.$on 'peer.message', (scope, entry) =>
      $scope.$apply ->
        $scope.history.push entry

    $scope.$on 'peer.remove', (scope, uuid) =>
      if @peer is uuid
        @peer = null
        $scope.history = []

module.exports = History