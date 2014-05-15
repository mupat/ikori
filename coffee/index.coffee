require 'coffee-script/register'

# Broadcaster = require "./js/broadcaster"
# Network = require "./js/network"

# network = new Network()
# broadcaster = new Broadcaster network.interfaces

# broadcaster.on 'broadcast_answer', (remote, data) ->
#   console.log 'got broadcast answer', remote, data

# broadcaster.on 'sent', (msg) ->
#   console.log 'sent', msg

# broadcaster.on 'error', (args...) ->
#   console.error args...

# broadcaster.sendBroadcasts()
# console.log 'started'

#angularjs stuff
# controllers = require "./js/controller/index"

chatApp = angular.module 'chatApp', [
  'chatApp.controllers'
  'chatApp.services'
]