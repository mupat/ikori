path = "./js/controller/"
PeerCtrl = require "#{path}peer"
Start = require "#{path}start"

chatAppControllers = angular.module 'chatApp.controllers', []

chatAppControllers.controller 'PeerCtrl', [
  '$scope'
  'broadcaster'
  'webrtc'
  PeerCtrl
]

chatAppControllers.run ['$rootScope', 'broadcaster', Start]
