moment = require 'moment'

class History
  DATE_FORMAT: "YYYY-MM-DD HH:mm:ss"
  autolinker: new window.Autolinker({ newWindow: false })

  constructor: ($scope, $compile, @peers) ->
    @$scope = $scope
    $scope.history = {}
    $scope.history.peer = null
    $scope.history.log = []

    $scope.$on 'channel.open', (scope, uuid) =>
      $scope.history.peer = uuid
      $scope.history.log = @peers.getHistory uuid

    $scope.$on 'message.peer', (scope, msg, uuid) =>
      @_createEntry msg, uuid, uuid

    $scope.$on 'message.own', (scope, msg, uuid) =>
      @_createEntry msg, 'you', uuid

    $scope.$on 'peer.remove', (scope, infos) =>
      @_remove infos.uuid

    $scope.$on 'peer.close', (scope, uuid) =>
      @_remove uuid

  _createEntry: (msg, origin, uuid) ->
    obj =
      time: moment().utc().valueOf()
      msg: msg
      origin: origin
    @peers.addHistoryEntry uuid, obj

  _remove: (uuid) ->
    if @$scope.history.peer is uuid
      @$scope.history.peer = null
      @$scope.history.log = []

module.exports = History