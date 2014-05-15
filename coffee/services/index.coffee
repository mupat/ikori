Broadcaster = require './js/services/broadcaster'
Network = require './js/services/network'

chatAppServices = angular.module 'chatApp.services', []

chatAppServices.service 'networkInterfaces', [Network]
chatAppServices.service 'broadcaster', [
  '$rootScope'
  'networkInterfaces'
  Broadcaster
]