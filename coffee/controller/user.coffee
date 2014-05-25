class User
  constructor: ($scope, user) ->
    $scope.name = user.name
  
module.exports = User