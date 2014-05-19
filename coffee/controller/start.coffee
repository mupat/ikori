class Start
  constructor: ($rootScope, broadcaster) ->
    # start the broadcast
    broadcaster.sendBroadcasts()
    $rootScope.$broadcast 'started'

module.exports = Start