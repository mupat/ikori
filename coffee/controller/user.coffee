class User
  constructor: ($scope, user) ->
    $scope.name = user.getInfos()['name']
  
module.exports = User