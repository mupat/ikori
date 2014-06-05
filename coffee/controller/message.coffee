class Message
  peer: null 
  constructor: ($rootScope, $scope) ->
    @$scope = $scope

    #define default values
    $scope.form = {}
    $scope.form.msg = ''
    $scope.form.open = false
       
    $scope.send = =>
      return unless $scope.form.msg? or $scope.form.msg.length is 0
      $rootScope.$broadcast 'message.own', $scope.form.msg, @peer
      $scope.form.msg = ''
     
    $scope.screen = =>
      $rootScope.$broadcast 'message.screen', @peer

    $scope.$on 'peer.remove', (scope, uuid) =>
      @_remove uuid

    $scope.$on 'channel.close', (scope, uuid) =>
      @_remove uuid

    $scope.$on 'channel.open', (scope, uuid) =>
      @peer = uuid
      $scope.form.open = true

  _remove: (uuid) ->
    if @peer is uuid
      @$scope.form.open = false
      @peer = null

module.exports = Message