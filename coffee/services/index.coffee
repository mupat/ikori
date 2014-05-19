path = "./js/services/"
Broadcaster = require "#{path}broadcaster"
Network = require "#{path}network"
Logger = require "#{path}logger"
WebRTC = require "#{path}webrtc/"

chatAppServices = angular.module 'chatApp.services', []

chatAppServices.service 'networkInterfaces', [Network]
chatAppServices.service 'broadcaster', [
  '$rootScope'
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