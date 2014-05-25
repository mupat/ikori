path = "./public/js/services/"
Network = require "#{path}network/"
Logger = require "#{path}logger"
WebRTC = require "#{path}webrtc/"
Notification = require "#{path}notification"
Peer = require "#{path}peer"

chatAppServices = angular.module 'chatApp.services', []

chatAppServices.service 'peer', [
  '$rootScope'
  'CONFIG'
  Peer
]

chatAppServices.service 'notification', [
  '$rootScope'
  'USER'
  'CONFIG'
  Notification
]
chatAppServices.service 'network', [
  '$rootScope'
  'CONFIG'
  'USER'
  'peer'
  Network
]
chatAppServices.service 'webrtc', [
  '$rootScope'
  'network'
  'peer'
  WebRTC
]

#run logger immediately to make sure we log sent and error events from the services that using the rootScope
chatAppServices.run ['$rootScope', Logger] 