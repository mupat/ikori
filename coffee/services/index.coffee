path = "./public/js/services/"
Network = require "#{path}network"
Logger = require "#{path}logger"
WebRTC = require "#{path}webrtc/"
User = require "#{path}user"
Config = require "#{path}config"
Notification = require "#{path}notification"

chatAppServices = angular.module 'chatApp.services', []

chatAppServices.service 'user', [User]
chatAppServices.service 'config', [Config]
chatAppServices.service 'notification', [
  '$rootScope'
  Notification
]
chatAppServices.service 'network', [
  '$rootScope'
  'config'
  'user'
  Network
]
chatAppServices.service 'webrtc', [
  '$rootScope'
  'network'
  WebRTC
]

#run logger immediately to make sure we log sent and error events from the services that using the rootScope
chatAppServices.run ['$rootScope', Logger] 