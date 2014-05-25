class Logger
  constructor: ($rootScope) ->
    $rootScope.$on 'started', (scope) ->
      console.log 'broadcast started'

    $rootScope.$on 'socket.sent', (scope, msg) ->
      console.log 'sent message', msg

    $rootScope.$on 'error', (scope, args...) ->
      console.log args...
  
    $rootScope.$on 'socket.received', (scope, remote, msg) ->
      console.log 'received', remote, msg

    $rootScope.$on 'channel.open', (scope, connection, channel) =>
      console.log 'channel opened', connection, channel

    $rootScope.$on 'channel.close', (scope, connection, channel) =>
      console.log 'channel closed', connection, channel

module.exports = Logger