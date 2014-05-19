class History
  histories: {}
  constructor: ($scope) ->
    $scope.history = []
    $scope.$on 'newMessage', (scope, msg, event, remote) =>
      @histories[remote.address] = [] unless @histories[remote.address]?
      @histories[remote.address].push {
        time: new Date()
        msg: msg
      }
      $scope.$apply =>
        $scope.history = @histories[remote.address]
  
module.exports = History