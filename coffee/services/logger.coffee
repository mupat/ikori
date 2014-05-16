class Logger
  constructor: ($rootScope) ->
    $rootScope.$on 'sent', (scope, msg) ->
      console.log 'sent message', msg

    $rootScope.$on 'error', (scope, args...) ->
      console.log args...
  
    $rootScope.$on 'received', (scope, remote, msg) ->
      console.log 'received', remote, msg

    $rootScope.$on 'open', (scope, connection, channel) =>
      console.log 'channel opened', connection, channel

    $rootScope.$on 'close', (scope, connection, channel) =>
      console.log 'channel closed', connection, channel

module.exports = Logger