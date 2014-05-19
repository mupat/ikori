path = "./js/services/"
Broadcaster = require "#{path}broadcaster"
Network = require "#{path}network"
Logger = require "#{path}logger"
WebRTC = require "#{path}webrtc/"
User = require "#{path}user"

chatAppServices = angular.module 'chatApp.services', []

chatAppServices.service 'user', [User]
chatAppServices.service 'networkInterfaces', ['user', Network]
chatAppServices.service 'broadcaster', [
  '$rootScope'
  'user'
  'networkInterfaces'
  Broadcaster
]
chatAppServices.service 'webrtc', [
  '$rootScope'
  'broadcaster'
  WebRTC
]

#run logger immediately to make sure we log sent and error events from the services that using the rootScope
chatAppServices.run ['$rootScope', Logger] 