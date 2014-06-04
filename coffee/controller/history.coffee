moment = require 'moment'

class History
  DATE_FORMAT: "YYYY-MM-DD HH:mm:ss"
  peer: null
  constructor: ($scope, @peers) ->
    @$scope = $scope
    $scope.history = []

    $scope.$on 'channel.open', (scope, uuid) =>
      @peer = uuid
      history = @peers.getHistory uuid
      $scope.$apply ->
        $scope.history = history

    $scope.$on 'message.peer', (scope, msg, uuid) =>
      @_createEntry msg, uuid, uuid
      $scope.$apply ->
        $scope.history

    $scope.$on 'message.own', (scope, msg, uuid) =>
      @_createEntry msg, 'you', uuid

    $scope.$on 'peer.remove', (scope, infos) =>
      @_remove infos.uuid

    $scope.$on 'peer.close', (scope, uuid) =>
      @_remove uuid

    $scope.$on 'peer.update', (scope, uuid) =>
      if @peer is uuid
        $scope.history = window.angular.copy($scope.history)

    $scope.formatTime = (time) =>
      utc = moment.utc(time)
      timezone = moment().zone()
      return utc.subtract('minute', timezone).format(@DATE_FORMAT)
      # return utc.subtract('minute', timezone).calendar()

    $scope.formatOrigin = (origin) =>
      return origin if origin is 'you'
      return @peers.getName(origin)

  _createEntry: (msg, origin, uuid) ->
    obj =
      time: moment().utc().valueOf()
      msg: msg
      origin: origin
    @peers.addHistoryEntry uuid, obj

  _remove: (uuid) ->
    if @peer is uuid
      @peer = null
      @$scope.history = []

module.exports = History